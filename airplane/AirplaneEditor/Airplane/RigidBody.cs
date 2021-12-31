using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Airplane
{
    /// <summary>
    /// This only implements forces/inertia, velocity, position/rotation.  No collision detection/handling
    /// </summary>
    /// <remarks>
    /// https://answers.unity.com/questions/1484654/how-to-calculate-inertia-tensor-and-tensor-rotatio.html
    /// https://github.com/NVIDIAGameWorks/PhysX-3.4/blob/5e42a5f112351a223c19c17bb331e6c55037b8eb/PhysX_3.4/Source/PhysX/src/NpRigidDynamic.cpp
    /// </remarks>
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
        private readonly List<Vector3D> _accels = new List<Vector3D>();
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
        public Quaternion Rotation
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

        /// <summary>
        /// This is a safety to avoid large gaps of time
        /// </summary>
        public double MaxDeltaTime { get; set; } = 0.15;

        #endregion

        #region Public Methods

        public void Tick(double delta_time)
        {
            delta_time = Math.Min(delta_time, MaxDeltaTime);

            // Add up forces/torques, calculate as accelerations
            var accel = GetAccumulatedAccelerations();

            // Convert accelerations into velocites
            Velocity += accel.straight * delta_time;
            AngularVelocity += accel.angular * delta_time;

            // Update position/orientation
            Position += Velocity * delta_time;

            if (!AngularVelocity.IsNearZero())
            {
                double len = AngularVelocity.Length;
                Rotation = Rotation.RotateBy(new Quaternion(AngularVelocity / len, len * delta_time));
            }
        }

        public void AddAccel(Vector3D accel_world)
        {
            _accels.Add(accel_world);
        }

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

        // force to accel
        private (Vector3D straight, Vector3D angular) GetAccumulatedAccelerations()
        {
            // Straight
            Vector3D accel = new Vector3D();

            foreach (Vector3D acc in _accels)
                accel += acc;

            _accels.Clear();

            foreach (Vector3D force in _forces)
                accel += force * _inverse_mass;

            _forces.Clear();

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
    }
}
