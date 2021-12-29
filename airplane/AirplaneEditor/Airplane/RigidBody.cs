using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Airplane
{
    public class RigidBody
    {
        #region Declaration Section

        private readonly double _inverse_mass;

        // The inverse inertia tensor is stored as a simple diagonal, and there are rotate transforms to rotate the
        // torque/ang_accel from/to local coords and inertia coords.  Attempts to store rotations combined with the
        // inertia just made the matrix into a mess.  Someone with better knowledge of matrix math could probably
        // figure it out, but this is what makes sense to me
        private readonly PxMat33 _inverse_inertia_tensor;
        private readonly RotateTransform3D _transform_toinertia_rotate;
        private readonly RotateTransform3D _transform_frominertia_rotate;

        // These help with tranforming from/to local and world
        private readonly TranslateTransform3D _transform_toworld_translate;
        private readonly QuaternionRotation3D _transform_toworld_rotate_quat;
        private readonly QuaternionRotation3D _transform_tolocal_rotate_quat;

        private readonly RotateTransform3D _transform_toworld_rotate;
        private readonly RotateTransform3D _transform_tolocal_rotate;

        // These build up between ticks.  They are in world coords
        private readonly List<Vector3D> _forces = new List<Vector3D>();
        private readonly List<Vector3D> _torques = new List<Vector3D>();

        #endregion

        #region Constructor

        public RigidBody(double mass, Point3D center_of_mass, Vector3D inertia_tensor, Quaternion inertia_tensor_rotation)
        {
            // For now, just have these be static for the life of this class
            Mass = mass;
            CenterOfMass = center_of_mass;
            InertiaTensor = inertia_tensor;
            InertiaTensorRotation = inertia_tensor_rotation;

            _inverse_mass = mass.IsNearZero() ? 0d : 1d / mass;
            _inverse_inertia_tensor = PxMat33.createDiagonal(new Vector3D(
                inertia_tensor.X.IsNearZero() ? 0d : 1d / inertia_tensor.X,
                inertia_tensor.Y.IsNearZero() ? 0d : 1d / inertia_tensor.Y,
                inertia_tensor.Z.IsNearZero() ? 0d : 1d / inertia_tensor.Z));

            _transform_toworld_translate = new TranslateTransform3D();
            _transform_toworld_rotate_quat = new QuaternionRotation3D();        // this one is used in two different transforms
            _transform_tolocal_rotate_quat = new QuaternionRotation3D();

            // these rotate transforms are for rotating torque and ang_accel from world to inertia, back to world
            _transform_toinertia_rotate = new RotateTransform3D(new QuaternionRotation3D(inertia_tensor_rotation.ToReverse()));
            _transform_frominertia_rotate = new RotateTransform3D(new QuaternionRotation3D(inertia_tensor_rotation));

            _transform_toworld_rotate = new RotateTransform3D(_transform_toworld_rotate_quat);
            _transform_tolocal_rotate = new RotateTransform3D(_transform_tolocal_rotate_quat);

            Transform3DGroup transform = new Transform3DGroup();
            transform.Children.Add(new RotateTransform3D(_transform_toworld_rotate_quat));
            transform.Children.Add(_transform_toworld_translate);

            Transform_ToWorld = transform;
        }

        #endregion

        #region Public Properties

        public double Mass { get; private set; }

        // -------------------------------- Local Coords --------------------------------

        public Point3D CenterOfMass { get; private set; }

        //https://answers.unity.com/questions/1484654/how-to-calculate-inertia-tensor-and-tensor-rotatio.html
        public Vector3D InertiaTensor { get; private set; }

        public Quaternion InertiaTensorRotation { get; private set; }

        // -------------------------------- Global Coords -------------------------------

        private Point3D _position = new Point3D();
        public Point3D Position
        {
            get => _position;
            set
            {
                _position = value;

                _transform_toworld_translate.OffsetX = value.X;
                _transform_toworld_translate.OffsetY = value.Y;
                _transform_toworld_translate.OffsetZ = value.Z;
            }
        }

        private Quaternion _rotation = Quaternion.Identity;
        public Quaternion Roation
        {
            get => _rotation;
            set
            {
                _rotation = value;
                _transform_toworld_rotate_quat.Quaternion = _rotation;
                _transform_tolocal_rotate_quat.Quaternion = _rotation.ToReverse();       // this extention function pulls out the axis,angle and creates a new with -angle (unless it's identity)
            }
        }

        public Vector3D Velocity { get; set; }
        public Vector3D AngularVelocity { get; set; }

        // ------------------------------------------------------------------------------
        public Point3D CenterOfMass_world => new Point3D(CenterOfMass.X + Position.X, CenterOfMass.Y + Position.Y, CenterOfMass.Z + Position.Z);

        public Transform3D Transform_ToWorld { get; private set; }

        #endregion

        #region Public Methods

        public void Tick(double delta_time)
        {
            // Update inverse inertia tensor according to current orientation


            // Add up forces/torques, calculate as accelerations



            // Convert accelerations into velocites



            // Update position/orientation

        }

        // Implementation seems to be here
        //https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Source/PhysX/src/NpRigidDynamic.cpp
        public void AddForce(Vector3D force_world)
        {
            //Scb::Body & b = getScbBodyFast();

            //PX_CHECK_AND_RETURN(force.isFinite(), "PxRigidDynamic::addForce: force is not valid.");
            //NP_WRITE_CHECK(NpActor::getOwnerScene(*this));
            //PX_CHECK_AND_RETURN(NpActor::getAPIScene(*this), "PxRigidDynamic::addForce: Body must be in a scene!");
            //PX_CHECK_AND_RETURN(!(b.getFlags() & PxRigidBodyFlag::eKINEMATIC), "PxRigidDynamic::addForce: Body must be non-kinematic!");
            //PX_CHECK_AND_RETURN(!(b.getActorFlags() & PxActorFlag::eDISABLE_SIMULATION), "PxRigidDynamic::addForce: Not allowed if PxActorFlag::eDISABLE_SIMULATION is set!");

            //addSpatialForce(&force, NULL, mode);
            _forces.Add(force_world);

            //wakeUpInternalNoKinematicTest(b, (!force.isZero()), autowake);
        }
        public void AddTorque(Vector3D torque_world)
        {
            //Scb::Body & b = getScbBodyFast();

            //PX_CHECK_AND_RETURN(torque.isFinite(), "PxRigidDynamic::addTorque: torque is not valid.");
            //NP_WRITE_CHECK(NpActor::getOwnerScene(*this));
            //PX_CHECK_AND_RETURN(NpActor::getAPIScene(*this), "PxRigidDynamic::addTorque: Body must be in a scene!");
            //PX_CHECK_AND_RETURN(!(b.getFlags() & PxRigidBodyFlag::eKINEMATIC), "PxRigidDynamic::addTorque: Body must be non-kinematic!");
            //PX_CHECK_AND_RETURN(!(b.getActorFlags() & PxActorFlag::eDISABLE_SIMULATION), "PxRigidDynamic::addTorque: Not allowed if PxActorFlag::eDISABLE_SIMULATION is set!");

            //addSpatialForce(NULL, &torque, mode);
            _torques.Add(torque_world);

            //wakeUpInternalNoKinematicTest(b, (!torque.isZero()), autowake);
        }

        public void Add_Force_At_Pos(Vector3D force_world, Point3D pos_world)
        {
            //const PxTransform globalPose = body.getGlobalPose();
            //const PxVec3 centerOfMass = globalPose.transform(body.getCMassLocalPose().p);

            Vector3D torque = Vector3D.CrossProduct(pos_world - CenterOfMass_world, force_world);

            AddForce(force_world);
            AddTorque(torque);
        }
        public void Add_Force_At_LocalPos(Vector3D force_world, Point3D pos_local)
        {
            Add_Force_At_Pos(force_world, Transform_ToWorld.Transform(pos_local));
        }
        public void Add_LocalForce_At_Pos(Vector3D force_local, Point3D pos_world)
        {
            Add_Force_At_Pos(Transform_ToWorld.Transform(force_local), pos_world);
        }
        public void Add_LocalForce_At_LocalPos(Vector3D force_local, Point3D pos_local)
        {
            Add_Force_At_Pos(Transform_ToWorld.Transform(force_local), Transform_ToWorld.Transform(pos_local));
        }

        #endregion

        #region Private Methods

        private (Vector3D straight, Vector3D angular) GetAccumulatedAccelerations()
        {
            // Straight
            Vector3D accel = new Vector3D();

            foreach (Vector3D force in _forces)
                accel += force * _inverse_mass;

            _forces.Clear();

            if (_torques.Count == 0)
            {
                return (accel, new Vector3D());
            }

            // Angular
            Vector3D ang_accel = new Vector3D();

            foreach (Vector3D torque in _torques)
            {
                Vector3D torque_working = _transform_tolocal_rotate.Transform(torque);              // torque rotated into local coords
                torque_working = _transform_toinertia_rotate.Transform(torque_working);             // torque rotated into inertia coords

                Vector3D ang_accel_working = _inverse_inertia_tensor * torque_working;              // dividing by inertia creates angular acceleration in inertia coords (F=MA)

                ang_accel_working = _transform_frominertia_rotate.Transform(ang_accel_working);     // ang_accel into local coords
                ang_accel_working = _transform_toworld_rotate.Transform(ang_accel_working);         // ang_accel into world coords

                ang_accel += ang_accel_working;
            }

            _torques.Clear();

            return (accel, ang_accel);
        }

        #endregion

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
