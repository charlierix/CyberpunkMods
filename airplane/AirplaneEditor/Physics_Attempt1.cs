using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

// Copied from the top of PhysX source files:
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions
// are met:
//  * Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in the
//    documentation and/or other materials provided with the distribution.
//  * Neither the name of NVIDIA CORPORATION nor the names of its
//    contributors may be used to endorse or promote products derived
//    from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
// OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Copyright (c) 2008-2018 NVIDIA Corporation. All rights reserved.
// Copyright (c) 2004-2008 AGEIA Technologies, Inc. All rights reserved.
// Copyright (c) 2001-2004 NovodeX AG. All rights reserved.

namespace AirplaneEditor
{
    // https://answers.unity.com/questions/1484654/how-to-calculate-inertia-tensor-and-tensor-rotatio.html
    public static class Physics_Attempt1
    {
        #region enum: ShapeType

        public enum ShapeType
        {
            Sphere,
            Box,
            Cylinder,
            Capsule,
            Ellipsoid,
        }

        #endregion
        #region record: Shape

        public abstract record ShapeBase
        {
            public abstract ShapeType ShapeType { get; }

            public double density { get; init; }
        }

        public record ShapeSphere : ShapeBase
        {
            public override ShapeType ShapeType => ShapeType.Sphere;

            public double Radius { get; init; }

            public PxTransform LocalPose { get; init; }     // this can be null
        }

        public record ShapeBox : ShapeBase
        {
            public override ShapeType ShapeType => ShapeType.Box;

            public Vector3D HalfWidths { get; init; }
        }

        public record ShapeCylinder : ShapeBase
        {
            public override ShapeType ShapeType => ShapeType.Cylinder;

            public Axis Direction { get; init; }

            public double Radius { get; init; }
            public double Length { get; init; }
        }

        public record ShapeCapsule : ShapeBase
        {
            public override ShapeType ShapeType => ShapeType.Capsule;

            public Axis Direction { get; init; }

            public double Radius { get; init; }
            public double Length { get; init; }
        }

        public record ShapeEllipsoid : ShapeBase
        {
            public override ShapeType ShapeType => ShapeType.Ellipsoid;

            public double RadiusX { get; init; }
            public double RadiusY { get; init; }
            public double RadiusZ { get; init; }
        }

        #endregion
        #region record: PxTransform

        // https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PxShared/include/foundation/PxTransform.h

        public record PxTransform
        {
            public Quaternion Q { get; init; }
            public Vector3D P { get; init; }
        }

        #endregion

        #region record: BodyInertia

        /// <summary>
        /// The original was a class: InertiaTensorComputer
        /// This is its member variables.  All the functions were changed to static
        /// </summary>
        private record BodyInertia
        {
            public PxMat33 I;

            /// <summary>
            /// center of mass
            /// </summary>
            public Vector3D CenterOfMass { get; init; }

            public double Mass { get; init; }

            public static BodyInertia GetZeroInertia()
            {
                return new BodyInertia()     //Ext::InertiaTensorComputer inertiaComp(true);
                {
                    CenterOfMass = new Vector3D(0, 0, 0),
                    I = new PxMat33()
                    {
                        column0 = new Vector3D(0, 0, 0),
                        column1 = new Vector3D(0, 0, 0),
                        column2 = new Vector3D(0, 0, 0),
                    },
                    Mass = 0,
                };
            }
            public static BodyInertia GetDiagonal(double mass, Vector3D diag)
            {
                return new BodyInertia()
                {
                    Mass = mass,
                    I = PxMat33.createDiagonal(diag),
                    CenterOfMass = new Vector3D(),     // center is at the origin
                };

                //PX_ASSERT(mI.column0.isFinite() && mI.column1.isFinite() && mI.column2.isFinite());
                //PX_ASSERT(PxIsFinite(mMass));
            }

            public static BodyInertia Transform(BodyInertia inertia, PxTransform transform)
            {
                BodyInertia retVal = inertia;

                retVal = BodyInertia.Rotate(retVal, PxMat33.from_rot(transform.Q));
                retVal = BodyInertia.Translate(retVal, transform.P);

                return retVal;
            }
            public static BodyInertia Rotate(BodyInertia inertia, PxMat33 rot)
            {
                return inertia with
                {
                    //well known inertia tensor rotation expression is: RIR' -- this could be optimized due to symmetry, see code to do that in Body::updateGlobalInverseInertia
                    I = rot * inertia.I * rot.getTranspose(),

                    //com also needs to be rotated
                    CenterOfMass = rot * inertia.CenterOfMass,
                };

                //PX_ASSERT(mI.column0.isFinite() && mI.column1.isFinite() && mI.column2.isFinite());
                //PX_ASSERT(mG.isFinite());
            }
            public static BodyInertia Translate(BodyInertia inertia, Vector3D t)
            {
                if (t.IsNearZero())     //its common for this to be zero
                    return inertia;

                PxMat33 newI = inertia.I;

                var t1 = new PxMat33()
                {
                    column0 = new Vector3D(0, inertia.CenterOfMass.Z, -inertia.CenterOfMass.Y),
                    column1 = new Vector3D(-inertia.CenterOfMass.Z, 0, inertia.CenterOfMass.X),
                    column2 = new Vector3D(inertia.CenterOfMass.Y, -inertia.CenterOfMass.X, 0),
                };

                Vector3D sum = inertia.CenterOfMass + t;
                if (sum.IsNearZero())
                {
                    newI += (t1 * t1) * inertia.Mass;
                }
                else
                {
                    var t2 = new PxMat33()
                    {
                        column0 = new Vector3D(0, sum.Z, -sum.Y),
                        column1 = new Vector3D(-sum.Z, 0, sum.X),
                        column2 = new Vector3D(sum.Y, -sum.X, 0),
                    };

                    newI += (t1 * t1 - t2 * t2) * inertia.Mass;
                }

                return inertia with
                {
                    I = newI,
                    CenterOfMass = inertia.CenterOfMass + t,      // move center of mass
                };

                //PX_ASSERT(mI.column0.isFinite() && mI.column1.isFinite() && mI.column2.isFinite());
                //PX_ASSERT(mG.isFinite());
            }

            public static BodyInertia Add(BodyInertia it1, BodyInertia it2)
            {
                double totalMass = it1.Mass + it2.Mass;

                return new BodyInertia()
                {
                    CenterOfMass = (it1.CenterOfMass * it1.Mass + it2.CenterOfMass * it2.Mass) / totalMass,

                    Mass = totalMass,

                    I = it1.I + it2.I,
                };

                //PX_ASSERT(mI.column0.isFinite() && mI.column1.isFinite() && mI.column2.isFinite());
                //PX_ASSERT(mG.isFinite());
                //PX_ASSERT(PxIsFinite(mMass));
            }
        }

        #endregion
        #region record: PxMat33

        // https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PxShared/include/foundation/PxMat33.h

        /// <remarks>
        /// Some clarifications, as there have been much confusion about matrix formats etc in the past.
        /// 
        /// Short:
        /// - Matrix have base vectors in columns (vectors are column matrices, 3x1 matrices).
        /// - Matrix is physically stored in column major format
        /// - Matrices are concaternated from left
        /// 
        /// Long:
        /// Given three base vectors a, b and c the matrix is stored as
        /// 
        /// |a.x b.x c.x|
        /// |a.y b.y c.y|
        /// |a.z b.z c.z|
        /// 
        /// Vectors are treated as columns, so the vector v is
        /// 
        /// |x|
        /// |y|
        /// |z|
        /// 
        /// And matrices are applied _before_ the vector (pre-multiplication)
        /// v' = M*v
        /// 
        /// |x'|   |a.x b.x c.x|   |x|   |a.x*x + b.x*y + c.x*z|
        /// |y'| = |a.y b.y c.y| * |y| = |a.y*x + b.y*y + c.y*z|
        /// |z'|   |a.z b.z c.z|   |z|   |a.z*x + b.z*y + c.z*z|
        /// 
        /// 
        /// Physical storage and indexing:
        /// To be compatible with popular 3d rendering APIs (read D3d and OpenGL)
        /// the physical indexing is
        /// 
        /// |0 3 6|
        /// |1 4 7|
        /// |2 5 8|
        /// 
        /// index = column*3 + row
        /// 
        /// which in C++ translates to M[column][row]
        /// 
        /// The mathematical indexing is M_row,column and this is what is used for _-notation
        /// so _12 is 1st row, second column and operator(row, column)!
        /// </remarks>
        private record PxMat33
        {
            // the three base vectors
            public Vector3D column0 { get; init; }
            public Vector3D column1 { get; init; }
            public Vector3D column2 { get; init; }

            /// <summary>
            /// Construct from diagonal, off-diagonals are zero
            /// </summary>
            public static PxMat33 createDiagonal(Vector3D diag)
            {
                return new PxMat33()
                {
                    column0 = new Vector3D(diag.X, 0, 0),
                    column1 = new Vector3D(0, diag.Y, 0),
                    column2 = new Vector3D(0, 0, diag.Z),
                };
            }

            public static PxMat33 from_rot(Quaternion q)
            {
                // hopefully their quaternions are built the same as wpf's

                double x = q.X;
                double y = q.Y;
                double z = q.Z;
                double w = q.W;

                double x2 = x + x;
                double y2 = y + y;
                double z2 = z + z;

                double xx = x2 * x;
                double yy = y2 * y;
                double zz = z2 * z;

                double xy = x2 * y;
                double xz = x2 * z;
                double xw = x2 * w;

                double yz = y2 * z;
                double yw = y2 * w;
                double zw = z2 * w;

                return new PxMat33()
                {
                    column0 = new Vector3D(1d - yy - zz, xy + zw, xz - yw),
                    column1 = new Vector3D(xy - zw, 1d - xx - zz, yz + xw),
                    column2 = new Vector3D(xz + yw, yz - xw, 1d - xx - yy),
                };
            }

            #region Operator Overloads

            // Add
            public static PxMat33 operator +(PxMat33 mat, PxMat33 other)
            {
                return new PxMat33()
                {
                    column0 = mat.column0 + other.column0,
                    column1 = mat.column1 + other.column1,
                    column2 = mat.column2 + other.column2
                };
            }

            // Subtract
            public static PxMat33 operator -(PxMat33 mat, PxMat33 other)
            {
                return new PxMat33()
                {
                    column0 = mat.column0 - other.column0,
                    column1 = mat.column1 - other.column1,
                    column2 = mat.column2 - other.column2
                };
            }

            // Scalar multiplication
            public static PxMat33 operator *(PxMat33 mat, double scalar)
            {
                return new PxMat33()
                {
                    column0 = mat.column0 * scalar,
                    column1 = mat.column1 * scalar,
                    column2 = mat.column2 * scalar,
                };
            }

            // Matrix vector multiplication (returns 'this->transform(vec)')
            public static Vector3D operator *(PxMat33 mat, Vector3D vec)
            {
                return transform(mat, vec);
            }

            // Matrix multiplication
            public static PxMat33 operator *(PxMat33 mat, PxMat33 other)
            {
                // Rows from this <dot> columns from other
                // column0 = transform(other.column0) etc
                return new PxMat33()
                {
                    column0 = transform(mat, other.column0),
                    column1 = transform(mat, other.column1),
                    column2 = transform(mat, other.column2),
                };
            }

            #endregion

            #region Public Methods

            // Get transposed matrix
            public PxMat33 getTranspose()
            {
                return new PxMat33()
                {
                    column0 = new Vector3D(column0.X, column1.X, column2.X),
                    column1 = new Vector3D(column0.Y, column1.Y, column2.Y),
                    column2 = new Vector3D(column0.Z, column1.Z, column2.Z),
                };
            }

            #endregion

            #region Private Methods

            // Transform vector by matrix, equal to v' = M*v
            private static Vector3D transform(PxMat33 mat, Vector3D other)
            {
                return (mat.column0 * other.X) + (mat.column1 * other.Y) + (mat.column2 * other.Z);
            }

            #endregion
        }

        #endregion

        public static (Point3D center_mass, Vector3D inertia_tensor, double total_mass) GetInertiaTensor(ShapeBase[] shapes)
        {
            BodyInertia inertia = computeMassAndInertia(shapes);


            //NOTE: There's no need to take I * Mass.  Mass is already part of I

            //TODO: Verify that this is still a diagonal.  If so, that diagonal can be simplified into a vector
            //inertia.I;
            //
            // It's not perfect diagonal.  Need to search for the conversion function


            return (inertia.CenterOfMass.ToPoint(), new Vector3D(), inertia.Mass);
        }

        #region Private Methods - main function

        // https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/master/PhysX_3.4/Source/PhysXExtensions/src/ExtRigidBodyExt.cpp

        private static BodyInertia computeMassAndInertia(ShapeBase[] shapes)
        {
            var retVal = BodyInertia.GetZeroInertia();

            foreach (ShapeBase shape in shapes)
            {
                BodyInertia it = null;

                if (shape is ShapeSphere sphere)
                    it = getSphere(sphere.Radius, sphere.LocalPose);

                //TODO: Implement the rest of the shapes

                else
                    throw new ApplicationException($"Unknown shape: {shape.ShapeType}");

                it = scaleDensity(it, shape.density);

                retVal = BodyInertia.Add(retVal, it);
            }

            return retVal;
        }

        #endregion
        #region Private Methods - shape inertias

        // These were copied from here:
        // https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/master/PhysX_3.4/Source/PhysXExtensions/src/ExtInertiaTensor.h

        private static BodyInertia getSphere(double radius, PxTransform pose = null)
        {
            BodyInertia retVal = getSphere_modelcoords(radius);

            if (pose != null)
                retVal = BodyInertia.Transform(retVal, pose);

            return retVal;
        }
        private static BodyInertia getSphere_modelcoords(double radius)
        {
            double m = computeSphereRatio(radius);      // Compute mass of the sphere
            double s = m * radius * radius * (2d / 5d);     // Compute moment of inertia

            return BodyInertia.GetDiagonal(m, new Vector3D(s, s, s));
        }

        private static BodyInertia scaleDensity(BodyInertia inertia, double densityScale)
        {
            return inertia with
            {
                I = inertia.I * densityScale,
                Mass = inertia.Mass * densityScale,
            };
            //PX_ASSERT(mI.column0.isFinite() && mI.column1.isFinite() && mI.column2.isFinite());
            //PX_ASSERT(PxIsFinite(mMass));
        }

        // Sphere
        private static double computeSphereRatio(double radius) { return (4d / 3d) * Math.PI * radius * radius * radius; }
        private static double computeSphereMass(double radius, double density) { return density * computeSphereRatio(radius); }
        private static double computeSphereDensity(double radius, double mass) { return mass / computeSphereRatio(radius); }

        // Box
        private static double computeBoxRatio(Vector3D extents) { return volume(extents); }
        private static double computeBoxMass(Vector3D extents, double density) { return density * computeBoxRatio(extents); }
        private static double computeBoxDensity(Vector3D extents, double mass) { return mass / computeBoxRatio(extents); }

        // Ellipsoid
        private static double computeEllipsoidRatio(Vector3D extents) { return (4d / 3d) * Math.PI * volume(extents); }
        private static double computeEllipsoidMass(Vector3D extents, double density) { return density * computeEllipsoidRatio(extents); }
        private static double computeEllipsoidDensity(Vector3D extents, double mass) { return mass / computeEllipsoidRatio(extents); }

        // Cylinder
        private static double computeCylinderRatio(double r, double l) { return Math.PI * r * r * (2d * l); }
        private static double computeCylinderMass(double r, double l, double density) { return density * computeCylinderRatio(r, l); }
        private static double computeCylinderDensity(double r, double l, double mass) { return mass / computeCylinderRatio(r, l); }

        // Capsule
        private static double computeCapsuleRatio(double r, double l) { return computeSphereRatio(r) + computeCylinderRatio(r, l); }
        private static double computeCapsuleMass(double r, double l, double density) { return density * computeCapsuleRatio(r, l); }
        private static double computeCapsuleDensity(double r, double l, double mass) { return mass / computeCapsuleRatio(r, l); }

        private static double volume(Vector3D extents)
        {
            double v = 1d;
            if (extents.X != 0d) v *= extents.X;
            if (extents.Y != 0d) v *= extents.Y;
            if (extents.Z != 0d) v *= extents.Z;
            return v;
        }

        #endregion
    }
}
