using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Airplane
{
    public static class TestTensorRotation
    {
        //NOTE: The code this is copied from has local inertia tensor stored as a matrix3x3
        //  This should eliminate the need to find a vector and quaternion

        public static PxMat33 TEST_GetTransform(Vector3D inverse_inertia_tensor)
        {
            return PxMat33.createDiagonal(inverse_inertia_tensor);
        }
        public static PxMat33 TEST_GetTransform1(Vector3D inverse_inertia_tensor, Quaternion inertia_tensor_rotation)
        {
            return PxMat33.from_rot(inertia_tensor_rotation) * PxMat33.createDiagonal(inverse_inertia_tensor);
        }
        public static PxMat33 TEST_GetTransform2(Vector3D inverse_inertia_tensor, Quaternion inertia_tensor_rotation)
        {
            return PxMat33.createDiagonal(inverse_inertia_tensor) * PxMat33.from_rot(inertia_tensor_rotation);
        }

        //http://allenchou.net/2013/12/game-physics-motion-dynamics-implementations/
        public static PxMat33 GetWorldInverseInertiaTensor(Vector3D inverse_inertia_tensor, Quaternion inertia_tensor_rotation, Quaternion rotation_world)
        {
            PxMat33 m_localInverseInertiaTensor = GetMatrixFromRotatedVector(inertia_tensor_rotation, inverse_inertia_tensor);





            //PxMat33 retVal = PxMat33.from_rot(rotation_world);




            //// orthonormalize orientation matrix
            //Quat q = m_orientation.ToQuat();
            //q.Normalize();
            //m_orientation = q.ToMatrix();

            //// compute inverse orientation matrix
            //m_inverseOrientation = m_orientation.Transposed();




            //m_globalInverseInertiaTensor =
            //  m_orientation
            //  * m_massData.localInertiaTensor
            //  * m_inverseOrientation;




            return null;
        }

        private static PxMat33 GetMatrixFromRotatedVector(Quaternion rotation, Vector3D vector)
        {
            // Hopefully it's this easy
            return PxMat33.from_rot(rotation) * PxMat33.createDiagonal(vector);
        }

    }
}
