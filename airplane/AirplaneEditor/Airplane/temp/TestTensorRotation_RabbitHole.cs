using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Airplane.temp
{
    public static class TestTensorRotation_RabbitHole
    {
        private static void NOTES()
        {
            // Looks like PxRigidDynamic is the main class
            // PxRigidBody is a base class?

            // what's the difference between Np and Px?




            //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Include/PxRigidBody.h

            /*
            A body's linear and angular velocities can be read using the following methods::

                PxVec3 PxRigidBody::getLinearVelocity();
                PxVec3 PxRigidBody::getAngularVelocity();

            A body's linear and angular velocities can be set using the following methods::

                void PxRigidBody::setLinearVelocity(const PxVec3& linVel, bool autowake);
                void PxRigidBody::setAngularVelocity(const PxVec3& angVel, bool autowake);
             */






            //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Source/PhysX/src/NpRigidDynamic.h
            //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Source/PhysX/src/NpRigidDynamic.cpp
            //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Include/extensions/PxRigidBodyExt.h
            //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Source/PhysXExtensions/src/ExtRigidBodyExt.cpp

            /*
            The relevant methods of PxRigidBody and PxRigidBodyExt are listed below
            (The PxForceMode member defaults to PxForceMode::eFORCE to apply simple forces)

                void PxRigidBody::addForce(const PxVec3& force, PxForceMode::Enum mode, bool autowake);
                void PxRigidBody::addTorque(const PxVec3& torque, PxForceMode::Enum mode, bool autowake);

                void PxRigidBodyExt::addForceAtPos(PxRigidBody& body, const PxVec3& force,
                    const PxVec3& pos, PxForceMode::Enum mode, bool wakeup);
                void PxRigidBodyExt::addForceAtLocalPos(PxRigidBody& body, const PxVec3& force,
                    const PxVec3& pos, PxForceMode::Enum mode, bool wakeup);
                void PxRigidBodyExt::addLocalForceAtPos(PxRigidBody& body, const PxVec3& force,
                    const PxVec3& pos, PxForceMode::Enum mode, bool wakeup);
                void PxRigidBodyExt::addLocalForceAtLocalPos(PxRigidBody& body, const PxVec3& force,
                    const PxVec3& pos, PxForceMode::Enum mode, bool wakeup);
            */









            // This is an enum to figure out exact calculation: eFORCE, eIMPULSE, eVELOCITY_CHANGE, eACCELERATION
            //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Include/PxForceMode.h


        }
        private static void NOTES_OTHERSOURCES_INERTIATENSOR()
        {
            // The bottom of the article talks about how to update the matrices
            //http://allenchou.net/2013/12/game-physics-motion-dynamics-implementations/


            // more about how to come up with the world inverse inertia tensor
            //https://stackoverflow.com/questions/18290798/calculating-rigid-body-inertia-tensor-world-coordinates



            // this stays pretty high level
            //https://gafferongames.com/post/rotation_and_inertia_tensors/
            //https://gafferongames.com/post/collision_response_and_coulomb_friction/

        }



        //mBody.getGlobalInertiaTensorInverse()
        public static PxMat33 GetWorldInverseInertiaTensor(Vector3D inverse_inertia_tensor, Quaternion rotation_world)
        {

            // GetPaddedMatrix is supposed to return a 3x3 matrix, but it returns a 3x4
            //
            // I think it's just turning the quaternion into a matrix that's used to rotate the vector
            //
            // So, based on that assumption, just rotate the vector using the quaternion instead of replicating their
            // get matrix function

            //PX_INLINE PxMat33 Body::getGlobalInertiaTensorInverse() const
            //{
            //    PxMat33 inverseInertiaWorldSpace;
            //    Cm::transformInertiaTensor(getInverseInertia(), Gu::PxMat33Padded(getBody2World().q), inverseInertiaWorldSpace);
            //    return inverseInertiaWorldSpace;
            //}

            //PxMat33 M = PxMat33.from_rot(Roation);      //TODO: verify whether padded is the same as this

            PxMat34 M34 = GetPaddedMatrix(rotation_world);

            PxMat33 M = new PxMat33()
            {
                column0 = M34.column0.ToVector3D(),     // this is lossy.  GetPaddedMatrix should have returned a 3x3
                column1 = M34.column1.ToVector3D(),
                column2 = M34.column2.ToVector3D(),
            };

            var retVal = TransformInertiaTensor(inverse_inertia_tensor, M);

            return retVal;
        }


        //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Source/GeomUtils/headers/GuSIMDHelpers.h
        private static PxMat34 GetPaddedMatrix(Quaternion q)
        {
            //using namespace Ps::aos;

            QuatGetMat34V(q, out VectorND column0V, out VectorND column1V, out VectorND column2V);


            //#if defined(PX_SIMD_DISABLED) || PX_ANDROID || (PX_LINUX && (PX_ARM || PX_A64))
            //			V3StoreU(column0V, column0);
            //			V3StoreU(column1V, column1);
            //			V3StoreU(column2V, column2);
            //#else
            //            V4StoreU(column0V, &column0.x);
            //            V4StoreU(column1V, &column1.x);
            //            V4StoreU(column2V, &column2.x);
            //#endif

            return new PxMat34()
            {
                column0 = column0V,
                column1 = column1V,
                column2 = column2V,
            };
        }

        //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PxShared/src/foundation/include/PsVecMathSSE.h
        //PX_FORCE_INLINE void QuatGetMat33V(const QuatVArg q, Vec3V& column0, Vec3V& column1, Vec3V& column2)
        //{
        //    const __m128 q2 = V4Add(q, q);
        //    const __m128 qw2 = V4MulAdd(q2, V4GetW(q), _mm_load_ps(minus1w));           // (2wx, 2wy, 2wz, 2ww-1)
        //    const __m128 nw2 = Vec3V_From_Vec4V(V4Neg(qw2));                            // (-2wx, -2wy, -2wz, 0)
        //    const __m128 v = Vec3V_From_Vec4V(q);

        //    const __m128 a0 = _mm_shuffle_ps(qw2, nw2, _MM_SHUFFLE(3, 1, 2, 3));        // (2ww-1, 2wz, -2wy, 0)
        //    column0 = V4MulAdd(v, V4GetX(q2), a0);

        //    const __m128 a1 = _mm_shuffle_ps(qw2, nw2, _MM_SHUFFLE(3, 2, 0, 3));        // (2ww-1, 2wx, -2wz, 0)
        //    column1 = V4MulAdd(v, V4GetY(q2), _mm_shuffle_ps(a1, a1, _MM_SHUFFLE(3, 1, 0, 2)));

        //    const __m128 a2 = _mm_shuffle_ps(qw2, nw2, _MM_SHUFFLE(3, 0, 1, 3));        // (2ww-1, 2wy, -2wx, 0)
        //    column2 = V4MulAdd(v, V4GetZ(q2), _mm_shuffle_ps(a2, a2, _MM_SHUFFLE(3, 0, 2, 1)));
        //}


        //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PxShared/src/foundation/include/windows/PsWindowsInlineAoS.h
        //PX_FORCE_INLINE Vec4V V4MulAdd(const Vec4V a, const Vec4V b, const Vec4V c)
        //  return V4Add(V4Mul(a, b), c);



        //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PxShared/src/foundation/include/PsVecMathAoSScalarInline.h
        //PX_FORCE_INLINE Vec3V Vec3V_From_Vec4V(Vec4V f)
        //    return Vec3V(f.x, f.y, f.z);

        //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PxShared/src/foundation/include/windows/PsWindowsInlineAoS.h
        //PX_FORCE_INLINE Vec3V Vec3V_From_Vec4V(Vec4V v)
        //    return V4ClearW(v);




        //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/Externals/clang/4.0.0/linux32/lib/clang/4.0.0/include/xmmintrin.h
        //#define _MM_SHUFFLE(z, y, x, w) (((z) << 6) | ((y) << 4) | ((x) << 2) | (w))

        //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/Externals/clang/4.0.0/linux32/lib/clang/4.0.0/include/xmmintrin.h
        /*
        /// \brief Selects 4 float values from the 128-bit operands of [4 x float], as
        ///    specified by the immediate value operand.
        ///
        /// \headerfile <x86intrin.h>
        ///
        /// \code
        /// __m128 _mm_shuffle_ps(__m128 a, __m128 b, const int mask);
        /// \endcode
        ///
        /// This intrinsic corresponds to the <c> VSHUFPS / SHUFPS </c> instruction.
        ///
        /// \param a
        ///    A 128-bit vector of [4 x float].
        /// \param b
        ///    A 128-bit vector of [4 x float].
        /// \param mask
        ///    An immediate value containing an 8-bit value specifying which elements to
        ///    copy from \ a and \a b. \n
        ///    Bits [3:0] specify the values copied from operand \a a. \n
        ///    Bits [7:4] specify the values copied from operand \a b. \n
        ///    The destinations within the 128-bit destination are assigned values as
        ///    follows: \n
        ///    Bits [1:0] are used to assign values to bits [31:0] in the
        ///    destination. \n
        ///    Bits [3:2] are used to assign values to bits [63:32] in the
        ///    destination. \n
        ///    Bits [5:4] are used to assign values to bits [95:64] in the
        ///    destination. \n
        ///    Bits [7:6] are used to assign values to bits [127:96] in the
        ///    destination. \n
        ///    Bit value assignments: \n
        ///    00: Bits [31:0] copied from the specified operand. \n
        ///    01: Bits [63:32] copied from the specified operand. \n
        ///    10: Bits [95:64] copied from the specified operand. \n
        ///    11: Bits [127:96] copied from the specified operand.
        /// \returns A 128-bit vector of [4 x float] containing the shuffled values.
        #define _mm_shuffle_ps(a, b, mask) __extension__ ({ \
          (__m128)__builtin_shufflevector((__v4sf)(__m128)(a), (__v4sf)(__m128)(b), \
                                          0 + (((mask) >> 0) & 0x3), \
                                          0 + (((mask) >> 2) & 0x3), \
                                          4 + (((mask) >> 4) & 0x3), \
                                          4 + (((mask) >> 6) & 0x3)); })
        */

        /*
        __m128 _mm_shuffle_ps(__m128 lo,__m128 hi, _MM_SHUFFLE(hi3,hi2,lo1,lo0))
        
        Interleave inputs into low 2 floats and high 2 floats of output. Basically
           out[0]=lo[lo0];
           out[1]=lo[lo1];
           out[2]=hi[hi2];
           out[3]=hi[hi3];
        For example, _mm_shuffle_ps(a,a,_MM_SHUFFLE(i,i,i,i)) copies the float a[i] into all 4 output floats.         
        */


        private static void QuatGetMat34V(Quaternion quat, out VectorND column0, out VectorND column1, out VectorND column2)
        {
            VectorND q = new VectorND(quat.X, quat.Y, quat.Z, quat.W);
            VectorND minus1w = new VectorND(0, 0, 0, -1);       //const PX_ALIGN(16, PxF32) minus1w[4] = { 0.0f, 0.0f, 0.0f, -1.0f };

            VectorND q2 = q + q;
            VectorND qw2 = (q2 * q[3]) + minus1w;           // (2wx, 2wy, 2wz, 2ww-1)
            Vector3D v = new Vector3D(q[0], q[1], q[2]);

            Vector3D a0 = new Vector3D(qw2[3], qw2[2], -qw2[1]);     // (2ww-1, 2wz, -2wy, 0)
            //column0 = V4MulAdd(v, V4GetX(q2), a0);
            //column0 = V4Add(v * q2[0], a0);
            column0 = (v * q2[0] + a0).ToVectorND();

            Vector3D a1 = new Vector3D(qw2[3], qw2[0], -qw2[2]);       // (2ww-1, 2wx, -2wz, 0)
            //column1 = V4MulAdd(v, V4GetY(q2), _mm_shuffle_ps(a1, a1, _MM_SHUFFLE(3, 1, 0, 2)));
            //column1 = V4Add(v * q2[1], _mm_shuffle_ps(a1, a1, _MM_SHUFFLE(3, 1, 0, 2)));
            //column1 = V4Add(v * q2[1], new VectorND(0, a1.Y, a1.X, a1.Z));
            column1 = (v * q2[1]).ToVectorND() + new VectorND(0, a1.Y, a1.X, a1.Z);

            Vector3D a2 = new Vector3D(qw2[3], qw2[1], -qw2[0]);       // (2ww-1, 2wy, -2wx, 0)
            //column2 = V4MulAdd(v, V4GetZ(q2), _mm_shuffle_ps(a2, a2, _MM_SHUFFLE(3, 0, 2, 1)));
            //column2 = V4Add(v * q2[2], _mm_shuffle_ps(a2, a2, _MM_SHUFFLE(3, 0, 2, 1)));
            //column2 = V4Add(v * q2[2], new VectorND(0, a2.X, a2.Z, a2.Y));
            column2 = (v * q2[2]).ToVectorND() + new VectorND(0, a2.X, a2.Z, a2.Y);
        }


        //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Source/Common/src/CmUtils.h
        private static PxMat33 TransformInertiaTensor(Vector3D invD, PxMat33 M)
        {
            double axx = invD.X * M[0, 0], axy = invD.X * M[1, 0], axz = invD.X * M[2, 0];
            double byx = invD.Y * M[0, 1], byy = invD.Y * M[1, 1], byz = invD.Y * M[2, 1];
            double czx = invD.Z * M[0, 2], czy = invD.Z * M[1, 2], czz = invD.Z * M[2, 2];


            double r00 = axx * M[0, 0] + byx * M[0, 1] + czx * M[0, 2];
            double r11 = axy * M[1, 0] + byy * M[1, 1] + czy * M[1, 2];
            double r22 = axz * M[2, 0] + byz * M[2, 1] + czz * M[2, 2];

            double r01 = axx * M[1, 0] + byx * M[1, 1] + czx * M[1, 2];
            double r10 = r01;

            double r02 = axx * M[2, 0] + byx * M[2, 1] + czx * M[2, 2];
            double r20 = r02;

            double r12 = axy * M[2, 0] + byy * M[2, 1] + czy * M[2, 2];
            double r21 = r12;

            return new PxMat33()
            {
                column0 = new Vector3D(r00, r01, r02),
                column1 = new Vector3D(r10, r11, r12),
                column2 = new Vector3D(r20, r21, r22),
            };
        }
    }

    #region record: PxMat34

    // Copy of PxMat33, made to test a function that returns vector4s

    // https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PxShared/include/foundation/PxMat33.h

    /// <summary>
    /// This is a 3x3 matrix
    /// </summary>
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
    public record PxMat34
    {
        // the three base vectors
        public VectorND column0 { get; init; }
        public VectorND column1 { get; init; }
        public VectorND column2 { get; init; }

        #region Operator Overloads

        // Add
        public static PxMat34 operator +(PxMat34 mat, PxMat34 other)
        {
            return new PxMat34()
            {
                column0 = mat.column0 + other.column0,
                column1 = mat.column1 + other.column1,
                column2 = mat.column2 + other.column2
            };
        }

        // Subtract
        public static PxMat34 operator -(PxMat34 mat, PxMat34 other)
        {
            return new PxMat34()
            {
                column0 = mat.column0 - other.column0,
                column1 = mat.column1 - other.column1,
                column2 = mat.column2 - other.column2
            };
        }

        // Scalar multiplication
        public static PxMat34 operator *(PxMat34 mat, double scalar)
        {
            return new PxMat34()
            {
                column0 = mat.column0 * scalar,
                column1 = mat.column1 * scalar,
                column2 = mat.column2 * scalar,
            };
        }

        // Matrix vector multiplication (returns 'this->transform(vec)')
        public static VectorND operator *(PxMat34 mat, VectorND vec)
        {
            return transform(mat, vec);
        }

        // Matrix multiplication
        public static PxMat34 operator *(PxMat34 mat, PxMat34 other)
        {
            // Rows from this <dot> columns from other
            // column0 = transform(other.column0) etc
            return new PxMat34()
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
                VectorND vec;
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

                return vec[row];
            }
        }

        #region Private Methods

        // Transform vector by matrix, equal to v' = M*v
        private static VectorND transform(PxMat34 mat, VectorND other)
        {
            return (mat.column0 * other[0]) + (mat.column1 * other[1]) + (mat.column2 * other[2]);
        }

        #endregion
    }

    #endregion
}
