﻿using Game.Math_WPF.Mathematics;
using Game.Math_WPF.WPF;
using Game.Math_WPF.WPF.Controls3D;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
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

    /// <summary>
    /// Functions copied out of PhysX that calculates an inertia tensor for a set of parts
    /// </summary>
    /// <remarks>
    /// Keeping everything in one file so that it's self contained and portable
    /// </remarks>
    public static class Util_InertiaTensor
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

            public PxTransform LocalPose { get; init; }     // this can be null
        }

        public record ShapeSphere : ShapeBase
        {
            public override ShapeType ShapeType => ShapeType.Sphere;

            public double Radius { get; init; }
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
        #region record: Result

        public record Result
        {
            public Point3D CenterMass { get; init; }
            public double TotalMass { get; init; }

            /// <summary>
            /// This can be thought of as the inertia about the X,Y,Z axiis
            /// </summary>
            /// <remarks>
            /// A sphere will have the same values
            /// 
            /// A thin cylinder along X will have low inertia about X, but the same larger values about Y and Z
            /// </remarks>
            public Vector3D InertiaTensor { get; init; }
            /// <remarks>
            /// The moment of inertia was in a 3x3 matrix
            /// 
            /// That matrix was rotated to get InertiaTensor to be the diagonal (all values in diagonal,
            /// zeros everywhere else)
            /// 
            /// This is the rotation that was used
            /// </remarks>
            public Quaternion InertiaTensor_Rotation { get; init; }
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

            public double this[int col, int row]
            {
                get
                {
                    Vector3D vec;
                    switch (col)
                    {
                        case 0:
                            vec = column0;
                            break;

                        case 1:
                            vec = column1;
                            break;

                        case 2:
                            vec = column2;
                            break;

                        default:
                            throw new ArgumentOutOfRangeException($"Invalid column: {col}");
                    }

                    switch (row)
                    {
                        case 0:
                            return vec.X;

                        case 1:
                            return vec.Y;

                        case 2:
                            return vec.Z;

                        default:
                            throw new ArgumentOutOfRangeException($"Invalid row: {row}");
                    }
                }
            }

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

        public static Result GetInertiaTensor(ShapeBase[] shapes)
        {
            BodyInertia inertia = computeMassAndInertia(shapes);

            var as_diag = PxDiagonalize(inertia.I);

            //NOTE: There's no need to take I * Mass.  Mass is already part of I

            return new Result()
            {
                CenterMass = inertia.CenterOfMass.ToPoint(),
                TotalMass = inertia.Mass,
                InertiaTensor = as_diag.inertia_tensor,
                InertiaTensor_Rotation = as_diag.inertiaTensorRotation,
            };
        }

        public static void VisualizeInertiaTensor(ShapeBase[] shapes, Result inertia, string title = null)
        {
            var window = new Debug3DWindow()
            {
                Title = string.IsNullOrWhiteSpace(title) ?
                    "Inertia Tensor" :
                    title,
            };

            var sizes = Debug3DWindow.GetDrawSizes(shapes.Select(o => o.LocalPose?.P ?? new Vector3D()));

            // center of mass
            window.AddDot(inertia.CenterMass, sizes.dot * 2, Colors.White);

            foreach (var shape in shapes)
            {
                AddShapeVisual(window, sizes.dot, sizes.line * 0.5, shape);
            }

            if (inertia.InertiaTensor_Rotation != Quaternion.Identity)
            {
                Vector3D axis = inertia.InertiaTensor_Rotation.Axis;

                // inertia.InertiaTensor_Rotation axis and angle
                window.AddLine(inertia.CenterMass, inertia.CenterMass + axis, sizes.line * 0.25, Colors.LightGray);

                // inertia axiis
                window.AddText3D(Math.Round(inertia.InertiaTensor_Rotation.Angle).ToString(), inertia.CenterMass + axis, axis, 0.05, Colors.LightGray, false);
            }

            var transform = new RotateTransform3D(new QuaternionRotation3D(inertia.InertiaTensor_Rotation));

            // inertia ellipsoid

            //(unrotated)
            //window.AddLine(inertia.CenterMass, inertia.CenterMass + new Vector3D(inertia.InertiaTensor.X, 0, 0), sizes.line, Colors.Red);
            //window.AddLine(inertia.CenterMass, inertia.CenterMass + new Vector3D(0, inertia.InertiaTensor.Y, 0), sizes.line, Colors.Green);
            //window.AddLine(inertia.CenterMass, inertia.CenterMass + new Vector3D(0, 0, inertia.InertiaTensor.Z), sizes.line, Colors.Blue);

            //window.AddEllipse(inertia.CenterMass, inertia.InertiaTensor, UtilityWPF.ColorFromHex("1BBB"), true, true);

            window.AddLine(inertia.CenterMass, inertia.CenterMass + transform.Transform(new Vector3D(inertia.InertiaTensor.X, 0, 0)), sizes.line, Colors.Red);
            window.AddLine(inertia.CenterMass, inertia.CenterMass + transform.Transform(new Vector3D(0, inertia.InertiaTensor.Y, 0)), sizes.line, Colors.Green);
            window.AddLine(inertia.CenterMass, inertia.CenterMass + transform.Transform(new Vector3D(0, 0, inertia.InertiaTensor.Z)), sizes.line, Colors.Blue);

            window.AddEllipse(inertia.CenterMass, inertia.InertiaTensor, UtilityWPF.ColorFromHex("1BBB"), true, true, inertia.InertiaTensor_Rotation);



            //TODO: Text to compare with unity
            //window.AddText();





            window.Show();
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

                else if (shape is ShapeBox box)
                    it = getBox(box.HalfWidths, box.LocalPose);

                else if (shape is ShapeCylinder cylinder)
                    it = getCylinder(cylinder.Direction, cylinder.Radius, cylinder.Length, cylinder.LocalPose);

                else if (shape is ShapeCapsule capsule)
                    it = getCapsule(capsule.Direction, capsule.Radius, capsule.Length, capsule.LocalPose);

                else if (shape is ShapeEllipsoid ellipsoid)
                    it = getEllipsoid(ellipsoid.RadiusX, ellipsoid.RadiusY, ellipsoid.RadiusZ, ellipsoid.LocalPose);

                //NOTE: The c++ code had logic for a mesh.  It wasn't copied here, since this project doesn't need it

                else
                    throw new ApplicationException($"Unknown shape: {shape.ShapeType}");

                it = scaleDensity(it, shape.density);

                retVal = BodyInertia.Add(retVal, it);
            }

            return retVal;
        }

        #endregion
        #region Private Methods - inertia tensor

        // https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/master/PxShared/src/foundation/src/PsMathUtils.cpp

        /// <summary>
        /// This turns the matrix into values that can be used in the rigid body
        /// </summary>
        /// <remarks>
        /// The moment of inertia calculated and stored in a 3x3 matrix
        /// 
        /// This function looks like it iteratively narrows down on a rotation that has all the
        /// values in the diagonal (zeros everywhere else)
        /// 
        /// That diagonal is then returned as a vector
        /// </remarks>
        private static (Vector3D inertia_tensor, Quaternion inertiaTensorRotation) PxDiagonalize(PxMat33 m)
        {
            // jacobi rotation using quaternions (from an idea of Stan Melax, with fix for precision issues)

            const int MAX_ITERS = 24;

            Quaternion q = Quaternion.Identity;

            PxMat33 d = null;
            for (int i = 0; i < MAX_ITERS; i++)
            {
                PxMat33 axes = PxMat33.from_rot(q);
                d = axes.getTranspose() * m * axes;

                double d0 = Math.Abs(d[1, 2]);
                double d1 = Math.Abs(d[0, 2]);
                double d2 = Math.Abs(d[0, 1]);

                int a = d0 > d1 && d0 > d2 ?        // rotation axis index, from largest off-diagonal element
                    0 :
                    d1 > d2 ?
                        1 :
                        2;

                int a1 = getNextIndex3(a);
                int a2 = getNextIndex3(a1);

                if (d[a1, a2].IsNearZero() || Math.Abs(d[a1, a1] - d[a2, a2]) > 2e6f * Math.Abs(2d * d[a1, a2]))
                    break;

                double w = (d[a1, a1] - d[a2, a2]) / (2d * d[a1, a2]);      // cot(2 * phi), where phi is the rotation angle
                double absw = Math.Abs(w);

                Quaternion r;
                if (absw > 1000)
                {
                    r = indexedRotation(a, 1 / (4 * w), 1);     // h will be very close to 1, so use small angle approx instead
                }
                else
                {
                    double t = 1 / (absw + Math.Sqrt(w * w + 1)); // absolute value of tan phi
                    double h = 1 / Math.Sqrt(t * t + 1);          // absolute value of cos phi

                    //PX_ASSERT(h != 1); // |w|<1000 guarantees this with typical IEEE754 machine eps (approx 6e-8)

                    r = indexedRotation(a, Math.Sqrt((1 - h) / 2) * Math.Sin(w), Math.Sqrt((1 + h) / 2));
                }

                q = (q * r).ToUnit();
            }

            return (new Vector3D(d.column0.X, d.column1.Y, d.column2.Z), q);
        }

        // indexed rotation around axis, with sine and cosine of half-angle
        private static Quaternion indexedRotation(int axis, double s, double c)
        {
            double[] v = { 0d, 0d, 0d };
            v[axis] = s;
            return new Quaternion(v[0], v[1], v[2], c);
        }

        private static int getNextIndex3(int i)
        {
            //return (i + 1 + (i >> 1)) & 3;        // without the bitshift, it's cycling 0,1,2,3,0,...
            return (i + 1) % 3;     // this is the c# equivalent
        }

        #endregion
        #region Private Methods - shape inertias

        // https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/master/PhysX_3.4/Source/PhysXExtensions/src/ExtInertiaTensor.h

        // Sphere
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

        private static double computeSphereRatio(double radius) { return (4d / 3d) * Math.PI * radius * radius * radius; }

        // Box
        private static BodyInertia getBox(Vector3D halfWidths, PxTransform pose = null)
        {
            BodyInertia retVal = getBox_modelcoords(halfWidths);

            if (pose != null)
                retVal = BodyInertia.Transform(retVal, pose);

            return retVal;
        }
        private static BodyInertia getBox_modelcoords(Vector3D halfWidths)
        {
            // Setup inertia tensor for a cube with unit density
            double mass = 8d * computeBoxRatio(halfWidths);
            double s = (1d / 3d) * mass;

            double x = halfWidths.X * halfWidths.X;
            double y = halfWidths.Y * halfWidths.Y;
            double z = halfWidths.Z * halfWidths.Z;

            return BodyInertia.GetDiagonal(mass, new Vector3D(y + z, z + x, x + y) * s);
        }

        private static double computeBoxRatio(Vector3D extents) { return volume(extents); }

        // Cylinder
        private static BodyInertia getCylinder(Axis direction, double radius, double length, PxTransform pose = null)
        {
            BodyInertia retVal = getCylinder_modelcoords(direction, radius, length);

            if (pose != null)
                retVal = BodyInertia.Transform(retVal, pose);

            return retVal;
        }
        private static BodyInertia getCylinder_modelcoords(Axis direction, double radius, double length)
        {
            // Compute mass of cylinder
            double m = computeCylinderRatio(radius, length);

            double i1 = radius * radius * m / 2d;       // cap
            double i2 = (3d * radius * radius + 4d * length * length) * m / 12d;        // side

            Vector3D diag;
            switch (direction)
            {
                case Axis.X:
                    diag = new Vector3D(i1, i2, i2);
                    break;

                case Axis.Y:
                    diag = new Vector3D(i2, i1, i2);
                    break;

                case Axis.Z:
                    diag = new Vector3D(i2, i2, i1);
                    break;

                default:
                    throw new ApplicationException($"Unknown Axis: {direction}");
            }

            return BodyInertia.GetDiagonal(m, diag);
        }

        private static double computeCylinderRatio(double r, double l) { return Math.PI * r * r * (2d * l); }

        // Capsule
        private static BodyInertia getCapsule(Axis direction, double radius, double length, PxTransform pose = null)
        {
            BodyInertia retVal = getCapsule_modelcoords(direction, radius, length);

            if (pose != null)
                retVal = BodyInertia.Transform(retVal, pose);

            return retVal;
        }
        private static BodyInertia getCapsule_modelcoords(Axis direction, double rad, double len)
        {
            // Compute mass of capsule
            double m = computeCapsuleRatio(rad, len);

            double t = Math.PI * rad * rad;
            double i1 = t * ((rad * rad * rad * 8d / 15d) + (len * rad * rad));
            double i2 = t * ((rad * rad * rad * 8d / 15d) + (len * rad * rad * 3d / 2d) + (len * len * rad * 4d / 3d) + (len * len * len * 2d / 3d));

            Vector3D diag;
            switch (direction)
            {
                case Axis.X:
                    diag = new Vector3D(i1, i2, i2);
                    break;

                case Axis.Y:
                    diag = new Vector3D(i2, i1, i2);
                    break;

                case Axis.Z:
                    diag = new Vector3D(i2, i2, i1);
                    break;

                default:
                    throw new ApplicationException($"Unknown Axis: {direction}");
            }

            return BodyInertia.GetDiagonal(m, diag);
        }

        private static double computeCapsuleRatio(double r, double l) { return computeSphereRatio(r) + computeCylinderRatio(r, l); }

        // Ellipsoid
        private static BodyInertia getEllipsoid(double rad_x, double rad_y, double rad_z, PxTransform pose = null)
        {
            BodyInertia retVal = getEllipsoid_modelcoords(rad_x, rad_y, rad_z);

            if (pose != null)
                retVal = BodyInertia.Transform(retVal, pose);

            return retVal;
        }
        private static BodyInertia getEllipsoid_modelcoords(double rad_x, double rad_y, double rad_z)
        {
            // Compute mass of ellipsoid
            double m = computeEllipsoidRatio(new Vector3D(rad_x, rad_y, rad_z));

            // Compute moment of inertia
            double s = m * (2d / 5d);

            // Setup inertia tensor for an ellipsoid centered at the origin
            return BodyInertia.GetDiagonal(m, new Vector3D(rad_y * rad_z, rad_z * rad_x, rad_x * rad_y) * s);
        }

        private static double computeEllipsoidRatio(Vector3D extents) { return (4d / 3d) * Math.PI * volume(extents); }

        #endregion
        #region Private Methods = visualize

        private static void AddShapeVisual(Debug3DWindow window, double size_dot, double size_line, ShapeBase shape)
        {
            Color color = Colors.Gray;

            window.AddDot(shape.LocalPose?.P ?? new Vector3D(), size_dot, color);

            if (shape is ShapeSphere sphere)
                AddShapeVisual_Sphere(window, size_dot, size_line, color, sphere);

            else if (shape is ShapeBox box)
                AddShapeVisual_Box(window, size_dot, size_line, color, box);

            else if (shape is ShapeCylinder cylinder)
                AddShapeVisual_Cylinder(window, size_dot, size_line, color, cylinder);

            else if (shape is ShapeCapsule capsule)
                AddShapeVisual_Capsule(window, size_dot, size_line, color, capsule);

            else if (shape is ShapeEllipsoid ellipsoid)
                AddShapeVisual_Ellipsoid(window, size_dot, size_line, color, ellipsoid);

            else
                throw new ApplicationException($"Unknown shape type: {shape.ShapeType}");
        }

        private static void AddShapeVisual_Sphere(Debug3DWindow window, double size_dot, double size_line, Color color, ShapeSphere sphere)
        {
            Point3D center = sphere.LocalPose?.P.ToPoint() ?? new Point3D();

            window.AddCircle(center, sphere.Radius, size_line, color, new Triangle_wpf(new Vector3D(1, 0, 0), center));
            window.AddCircle(center, sphere.Radius, size_line, color, new Triangle_wpf(new Vector3D(0, 1, 0), center));
            window.AddCircle(center, sphere.Radius, size_line, color, new Triangle_wpf(new Vector3D(0, 0, 1), center));
        }

        private static void AddShapeVisual_Box(Debug3DWindow window, double size_dot, double size_line, Color color, ShapeBox box)
        {
            var transform = new Transform3DGroup();

            if(box.LocalPose != null)
            {
                transform.Children.Add(new RotateTransform3D(new QuaternionRotation3D(box.LocalPose.Q)));
                transform.Children.Add(new TranslateTransform3D(box.LocalPose.P));
            }

            Vector3D h = box.HalfWidths;

            Point3D p0 = transform.Transform(new Point3D(-h.X, -h.Y, h.Z));		// 0
            Point3D p1 = transform.Transform(new Point3D(h.X, -h.Y, h.Z));		// 1
            Point3D p2 = transform.Transform(new Point3D(h.X, h.Y, h.Z));		// 2
            Point3D p3 = transform.Transform(new Point3D(-h.X, h.Y, h.Z));		// 3

            Point3D p4 = transform.Transform(new Point3D(-h.X, -h.Y, -h.Z));    // 4
            Point3D p5 = transform.Transform(new Point3D(h.X, -h.Y, -h.Z));		// 5
            Point3D p6 = transform.Transform(new Point3D(h.X, h.Y, -h.Z));		// 6
            Point3D p7 = transform.Transform(new Point3D(-h.X, h.Y, -h.Z));		// 7

            var lines = new List<(Point3D, Point3D)>();

            // Front face
            lines.Add((p0, p1));
            lines.Add((p1, p2));
            lines.Add((p2, p3));
            lines.Add((p3, p0));

            // Back face
            lines.Add((p6, p5));
            lines.Add((p5, p4));
            lines.Add((p4, p7));
            lines.Add((p7, p6));

            // Sides
            lines.Add((p0, p4));
            lines.Add((p1, p5));
            lines.Add((p2, p6));
            lines.Add((p3, p7));

            window.AddLines(lines, size_line, color);
        }

        private static void AddShapeVisual_Cylinder(Debug3DWindow window, double size_dot, double size_line, Color color, ShapeCylinder cylinder)
        {
        }

        private static void AddShapeVisual_Capsule(Debug3DWindow window, double size_dot, double size_line, Color color, ShapeCapsule capsule)
        {
        }

        private static void AddShapeVisual_Ellipsoid(Debug3DWindow window, double size_dot, double size_line, Color color, ShapeEllipsoid ellipsoid)
        {
        }

        #endregion
        #region Private Methods

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

        private static double volume(Vector3D extents)
        {
            double v = 1d;

            if (!extents.X.IsNearZero()) v *= extents.X;
            if (!extents.Y.IsNearZero()) v *= extents.Y;
            if (!extents.Z.IsNearZero()) v *= extents.Z;

            return v;
        }

        #endregion
    }
}
