using AirplaneEditor.Airplane;
using Game.Math_WPF.Mathematics;
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
    /// 
    /// This doesn't perfectly match unity.  My guess is the way they distribute mass compared to this.  I
    /// like this way better, where every part can specify its own density
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
            public double Height { get; init; }
        }

        public record ShapeCapsule : ShapeBase
        {
            public override ShapeType ShapeType => ShapeType.Capsule;

            public Axis Direction { get; init; }

            public double Radius { get; init; }
            public double Height { get; init; }
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

            var aabb = Math3D.GetAABB(shapes.Select(o => o.LocalPose?.P ?? new Vector3D()));

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

            double inertia_size = Math1D.Max(inertia.InertiaTensor.X, inertia.InertiaTensor.Y, inertia.InertiaTensor.Z);
            double shape_size = Math1D.Max(aabb.max.X - aabb.min.X, aabb.max.Y - aabb.min.Y, aabb.max.Z - aabb.min.Z);
            if (shape_size.IsNearZero())
                shape_size = 1;
            Vector3D inertia_normalized = inertia.InertiaTensor * (shape_size * 1.5 / inertia_size);

            window.AddLine(inertia.CenterMass, inertia.CenterMass + transform.Transform(new Vector3D(inertia_normalized.X, 0, 0)), sizes.line, Colors.Red);
            window.AddLine(inertia.CenterMass, inertia.CenterMass + transform.Transform(new Vector3D(0, inertia_normalized.Y, 0)), sizes.line, Colors.Green);
            window.AddLine(inertia.CenterMass, inertia.CenterMass + transform.Transform(new Vector3D(0, 0, inertia_normalized.Z)), sizes.line, Colors.Blue);

            window.AddEllipsoid(inertia.CenterMass, inertia_normalized, UtilityWPF.ColorFromHex("1BBB"), true, true, inertia.InertiaTensor_Rotation);

            //This is to compare with unity

            Vector3D euler = ToEueler_Unity(inertia.InertiaTensor_Rotation);

            window.AddText($"mass:\t{inertia.TotalMass.ToStringSignificantDigits(5)}");
            window.AddText($"tensor:\t{inertia.InertiaTensor.X.ToStringSignificantDigits(5)}\t{inertia.InertiaTensor.Y.ToStringSignificantDigits(5)}\t{inertia.InertiaTensor.Z.ToStringSignificantDigits(5)}");
            window.AddText($"rotation:\t{euler.X.ToStringSignificantDigits(5)}\t{euler.Y.ToStringSignificantDigits(5)}\t{euler.Z.ToStringSignificantDigits(5)}");
            window.AddText($"center mass:\t{inertia.CenterMass.X.ToStringSignificantDigits(5)}\t{inertia.CenterMass.Y.ToStringSignificantDigits(5)}\t{inertia.CenterMass.Z.ToStringSignificantDigits(5)}");

            window.Show();
        }

        #region Private Methods - main function

        // https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/master/PhysX_3.4/Source/PhysXExtensions/src/ExtRigidBodyExt.cpp
        // https://en.wikipedia.org/wiki/List_of_moments_of_inertia

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
                    it = getCylinder(cylinder.Direction, cylinder.Radius, cylinder.Height, cylinder.LocalPose);

                else if (shape is ShapeCapsule capsule)
                    it = getCapsule(capsule.Direction, capsule.Radius, capsule.Height, capsule.LocalPose);

                else if (shape is ShapeEllipsoid ellipsoid)
                    it = getEllipsoid(ellipsoid.RadiusX, ellipsoid.RadiusY, ellipsoid.RadiusZ, ellipsoid.LocalPose);

                //NOTE: The c++ code had logic for a mesh.  It wasn't copied here, since this project doesn't need it

                else
                    throw new ApplicationException($"Unknown shape: {shape.ShapeType}");

                it = scaleDensity(it, shape.density);


                // Individual shapes are fine.  The error seems to be how the inertias are added together (even when no rotation is there)


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
        private static BodyInertia getCylinder(Axis direction, double radius, double height, PxTransform pose = null)
        {
            BodyInertia retVal = getCylinder_modelcoords(direction, radius, height);

            if (pose != null)
                retVal = BodyInertia.Transform(retVal, pose);

            return retVal;
        }
        private static BodyInertia getCylinder_modelcoords(Axis direction, double radius, double height)
        {
            double half_height = height / 2d;

            // Compute mass of cylinder
            double m = computeCylinderRatio(radius, height);

            // Iz = 1/2 * mr^2
            // Ix, Iy = 1/12 * m * (3r^2 + h^2)

            double i1 = radius * radius * m / 2d;       // along axis
            double i2 = (3d * radius * radius + height * height) * m / 12d;        // other two directions


            var test_inertia = CylinderTest(height, radius, 1);     // This matches (direction is hardcoded to Y)
            if (!test_inertia.mass.IsNearValue(m) || !test_inertia.inertia[0, 0].IsNearValue(i2) || !test_inertia.inertia[1, 1].IsNearValue(i1) || !test_inertia.inertia[2, 2].IsNearValue(i2))
                throw new ApplicationException("different");


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

        private static double computeCylinderRatio(double r, double h) { return Math.PI * r * r * h; }

        // Capsule
        private static BodyInertia getCapsule(Axis direction, double radius, double height, PxTransform pose = null)
        {
            BodyInertia retVal = getCapsule_modelcoords(direction, radius, height);

            if (pose != null)
                retVal = BodyInertia.Transform(retVal, pose);

            return retVal;
        }
        private static BodyInertia getCapsule_modelcoords(Axis direction, double rad, double height)
        {
            // Height can't include the top/bottom domes
            double remaining_height = Math.Max(0, height - rad - rad);
            double half_height = remaining_height / 2d;

            // Compute mass of capsule
            double m = computeCapsuleRatio(rad, remaining_height);

            double t = Math.PI * rad * rad;
            double i1 = t * ((rad * rad * rad * 8d / 15d) + (half_height * rad * rad));


            //TODO: i2 doesn't match unity.  Maybe it should be height instead of half height?
            //Need to look up the exact equations of cylinder and sphere inertias
            double i2 = t * ((rad * rad * rad * 8d / 15d) + (half_height * rad * rad * 3d / 2d) + (half_height * half_height * rad * 4d / 3d) + (half_height * half_height * half_height * 2d / 3d));



            var test_inertia = CapsuleTest(remaining_height, rad, 1);       // direction is hardcoded to Y
            if (!test_inertia.mass.IsNearValue(m) || !test_inertia.inertia[0, 0].IsNearValue(i2) || !test_inertia.inertia[1, 1].IsNearValue(i1) || !test_inertia.inertia[2, 2].IsNearValue(i2))
                throw new ApplicationException("different");



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

        private static double computeCapsuleRatio(double r, double h) { return computeSphereRatio(r) + computeCylinderRatio(r, h); }

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

        // From another source
        // https://www.gamedev.net/tutorials/programming/math-and-physics/capsule-inertia-tensor-r3856/
        private static (PxMat33 inertia, double mass) CapsuleTest(double height, double radius, double density)
        {
            double rSq = radius * radius;

            double cM = Math.PI * height * rSq * density;       // cylinder mass
            double hsM = Math.PI * 2d * rSq * radius * density / 3d;        // hemisphere mass

            double i00 = 0;
            double i11 = 0;
            double i22 = 0;

            // from cylinder
            i11 = rSq * cM * 0.5;
            i00 = i22 = i11 * 0.5 + cM * height * height / 12d;

            // from hemispheres
            double temp0 = hsM * 2d * rSq / 5d;
            i11 += temp0 * 2d;

            double temp1 = height * 0.5;
            double temp2 = temp0 + hsM * (temp1 * temp1 + 3d * height * radius / 8);

            i00 += temp2 * 2d;
            i22 += temp2 * 2d;

            double mass = cM + hsM * 2d;

            return (PxMat33.createDiagonal(new Vector3D(i00, i11, i22)), mass);
        }
        private static (PxMat33 inertia, double mass) CylinderTest(double height, double radius, double density)
        {
            double rSq = radius * radius;

            double cM = Math.PI * height * rSq * density;       // cylinder mass

            double i00 = 0;
            double i11 = 0;
            double i22 = 0;

            i11 = rSq * cM * 0.5;
            i00 = i22 = i11 * 0.5 + cM * height * height / 12d;

            return (PxMat33.createDiagonal(new Vector3D(i00, i11, i22)), cM);
        }

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

            if (box.LocalPose != null)
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
            var transform = new Transform3DGroup();

            if (cylinder.LocalPose != null)
            {
                transform.Children.Add(new RotateTransform3D(new QuaternionRotation3D(cylinder.LocalPose.Q)));
                transform.Children.Add(new TranslateTransform3D(cylinder.LocalPose.P));
            }

            var model = GetCylinderShapePrimitives(cylinder.Direction, cylinder.Height, cylinder.Radius);

            // Top Cap
            Point3D center = transform.Transform(model.cap_center).ToPoint();
            window.AddCircle(center, cylinder.Radius, size_line, color, new Triangle_wpf(transform.Transform(model.cap_normal), center));

            // Bottom Cap
            center = transform.Transform(-model.cap_center).ToPoint();
            window.AddCircle(center, cylinder.Radius, size_line, color, new Triangle_wpf(transform.Transform(-model.cap_normal), center));

            // Right Line
            window.AddLine(transform.Transform((model.cap_center + model.right).ToPoint()), transform.Transform((-model.cap_center + model.right).ToPoint()), size_line, color);

            // Left Line
            window.AddLine(transform.Transform((model.cap_center - model.right).ToPoint()), transform.Transform((-model.cap_center - model.right).ToPoint()), size_line, color);

            // Front Line
            window.AddLine(transform.Transform((model.cap_center + model.front).ToPoint()), transform.Transform((-model.cap_center + model.front).ToPoint()), size_line, color);

            // Back Line
            window.AddLine(transform.Transform((model.cap_center - model.front).ToPoint()), transform.Transform((-model.cap_center - model.front).ToPoint()), size_line, color);
        }

        private static void AddShapeVisual_Capsule(Debug3DWindow window, double size_dot, double size_line, Color color, ShapeCapsule capsule)
        {
            double cylinder_height = capsule.Height - capsule.Radius - capsule.Radius;

            // Detect if sphere
            if (cylinder_height <= 0)
            {
                ShapeSphere sphere = new ShapeSphere()
                {
                    density = capsule.density,
                    LocalPose = capsule.LocalPose,
                    Radius = capsule.Radius,
                };

                AddShapeVisual_Sphere(window, size_dot, size_line, color, sphere);
                return;
            }

            // Draw cylinder portion
            ShapeCylinder cylinder = new ShapeCylinder()
            {
                density = capsule.density,
                Direction = capsule.Direction,
                Height = cylinder_height,
                LocalPose = capsule.LocalPose,
                Radius = capsule.Radius,
            };

            AddShapeVisual_Cylinder(window, size_dot, size_line, color, cylinder);

            // Draw arcs
            var transform = new Transform3DGroup();

            if (cylinder.LocalPose != null)
            {
                transform.Children.Add(new RotateTransform3D(new QuaternionRotation3D(cylinder.LocalPose.Q)));
                transform.Children.Add(new TranslateTransform3D(cylinder.LocalPose.P));
            }

            var model = GetCylinderShapePrimitives(cylinder.Direction, cylinder.Height, cylinder.Radius);

            Point3D center = transform.Transform(model.cap_center).ToPoint();
            Vector3D up = transform.Transform(model.cap_normal);
            window.AddArc(center, transform.Transform(model.right), up, capsule.Radius, 0, 180, size_line, color);
            window.AddArc(center, transform.Transform(model.front), up, capsule.Radius, 0, 180, size_line, color);

            center = transform.Transform(-model.cap_center).ToPoint();
            up = transform.Transform(-model.cap_normal);
            window.AddArc(center, transform.Transform(model.right), up, capsule.Radius, 0, 180, size_line, color);
            window.AddArc(center, transform.Transform(model.front), up, capsule.Radius, 0, 180, size_line, color);
        }

        private static void AddShapeVisual_Ellipsoid(Debug3DWindow window, double size_dot, double size_line, Color color, ShapeEllipsoid ellipsoid)
        {
            Point3D center = ellipsoid.LocalPose?.P.ToPoint() ?? new Point3D();

            RotateTransform3D rot = new RotateTransform3D(new QuaternionRotation3D(ellipsoid.LocalPose?.Q ?? Quaternion.Identity));

            window.AddEllipse(center, rot.Transform(new Vector3D(1, 0, 0)), rot.Transform(new Vector3D(0, 1, 0)), ellipsoid.RadiusX, ellipsoid.RadiusY, size_line, color);
            window.AddEllipse(center, rot.Transform(new Vector3D(1, 0, 0)), rot.Transform(new Vector3D(0, 0, 1)), ellipsoid.RadiusX, ellipsoid.RadiusZ, size_line, color);
            window.AddEllipse(center, rot.Transform(new Vector3D(0, 1, 0)), rot.Transform(new Vector3D(0, 0, 1)), ellipsoid.RadiusY, ellipsoid.RadiusZ, size_line, color);
        }

        /// <summary>
        /// Cylinder and capsule share these same base properties
        /// </summary>
        private static (Vector3D cap_center, Vector3D cap_normal, Vector3D right, Vector3D front) GetCylinderShapePrimitives(Axis direction, double height, double radius)
        {
            Vector3D cap_center, cap_normal, right, front;

            switch (direction)
            {
                case Axis.X:
                    cap_center = new Vector3D(height / 2, 0, 0);
                    cap_normal = new Vector3D(1, 0, 0);
                    right = new Vector3D(0, -radius, 0);
                    front = new Vector3D(0, 0, -radius);
                    break;

                case Axis.Y:
                    cap_center = new Vector3D(0, height / 2, 0);
                    cap_normal = new Vector3D(0, 1, 0);
                    right = new Vector3D(radius, 0, 0);
                    front = new Vector3D(0, 0, -radius);
                    break;

                case Axis.Z:
                    cap_center = new Vector3D(0, 0, height / 2);
                    cap_normal = new Vector3D(0, 0, 1);
                    right = new Vector3D(radius, 0, 0);
                    front = new Vector3D(0, radius, 0);
                    break;

                default:
                    throw new ApplicationException($"Unknown Axis: {direction}");
            }

            return (cap_center, cap_normal, right, front);
        }

        /// <summary>
        /// Returns as a vector the way that unity works
        /// </summary>
        /// <remarks>
        /// Working with euler angles is a bad idea, use axis/angle instead.  This function is just to compare
        /// returned inertia tensor with unity
        /// 
        /// https://docs.unity3d.com/ScriptReference/Quaternion-eulerAngles.html
        /// https://github.com/Unity-Technologies/UnityCsReference/blob/master/Runtime/Export/Math/Quaternion.cs
        /// 
        /// In Unity these rotations are performed around the Z axis, the X axis, and the Y axis, in that order
        /// </remarks>
        private static Vector3D ToEueler_Unity(Quaternion quat)
        {
            //public Vector3 eulerAngles => return Internal_MakePositive(Internal_ToEulerRad(this) * Mathf.Rad2Deg);
            //[FreeFunction("QuaternionScripting::ToEuler", IsThreadSafe = true)] extern private static Vector3 Internal_ToEulerRad(Quaternion rotation);

            if (quat.IsIdentity)
                return new Vector3D(0, 0, 0);

            Vector3D retVal = Internal_ToEulerRad(quat);


            //TODO: find the source for Internal_MakePositive

            return retVal;
        }

        // ******************************************************************************
        // https://gist.github.com/HelloKitty/91b7af87aac6796c3da9
        private static Vector3D Internal_ToEulerRad(Quaternion rotation)
        {
            const double Mathf_Rad2Deg = 360d / (Math.PI * 2d);

            double sqw = rotation.W * rotation.W;
            double sqx = rotation.X * rotation.X;
            double sqy = rotation.Y * rotation.Y;
            double sqz = rotation.Z * rotation.Z;

            double unit = sqx + sqy + sqz + sqw; // if normalised is one, otherwise is correction factor

            double test = rotation.X * rotation.W - rotation.Y * rotation.Z;

            Vector3D v;

            if (test > 0.4995d * unit)
            { // singularity at north pole
                v.Y = 2f * Math.Atan2(rotation.Y, rotation.X);
                v.X = Math.PI / 2;
                v.Z = 0;
                return NormalizeAngles(v * Mathf_Rad2Deg);
            }

            if (test < -0.4995d * unit)
            { // singularity at south pole
                v.Y = -2f * Math.Atan2(rotation.Y, rotation.X);
                v.X = -Math.PI / 2;
                v.Z = 0;
                return NormalizeAngles(v * Mathf_Rad2Deg);
            }

            Quaternion q = new Quaternion(rotation.W, rotation.Z, rotation.X, rotation.Y);

            v.Y = (float)Math.Atan2(2f * q.X * q.W + 2f * q.Y * q.Z, 1 - 2f * (q.Z * q.Z + q.W * q.W));     // Yaw
            v.X = (float)Math.Asin(2f * (q.X * q.Z - q.W * q.Y));                                           // Pitch
            v.Z = (float)Math.Atan2(2f * q.X * q.Y + 2f * q.Z * q.W, 1 - 2f * (q.Y * q.Y + q.Z * q.Z));     // Roll

            return NormalizeAngles(v * Mathf_Rad2Deg);
        }
        private static Vector3D NormalizeAngles(Vector3D angles)
        {
            angles.X = NormalizeAngle(angles.X);
            angles.Y = NormalizeAngle(angles.Y);
            angles.Z = NormalizeAngle(angles.Z);
            return angles;
        }
        private static double NormalizeAngle(double angle)
        {
            double modAngle = angle % 360d;

            if (modAngle < 0d)
                return modAngle + 360d;
            else
                return modAngle;
        }
        // ******************************************************************************

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
