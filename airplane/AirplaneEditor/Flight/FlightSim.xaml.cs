﻿using AirplaneEditor.Airplane;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Media.Media3D;
using System.Windows.Shapes;
using System.Windows.Threading;

using Game.Math_WPF.Mathematics;

namespace AirplaneEditor.Flight
{
    public partial class FlightSim : Window
    {
        #region Declaration Section

        private readonly Vector3D _gravity;

        private AircraftPhysics _aero_physics = null;
        private RigidBody _body = null;

        private Map _map = null;

        private DispatcherTimer _timer = null;

        #endregion

        #region Constructor

        public FlightSim()
        {
            InitializeComponent();

            _gravity = new Vector3D(0, 0, -AppSettings.Gravity);

            _timer = new DispatcherTimer();
            _timer.Interval = TimeSpan.FromMilliseconds(10);
            _timer.Tick += Timer_Tick;
            _timer.Start();
        }

        #endregion

        #region Public Methods

        public void LoadAirplane(string json)
        {
            var airplane_model = JsonSerializer.Deserialize<Models.Airplane>(json);

            _body = new RigidBody(airplane_model.Mass, airplane_model.CenterOfMass, airplane_model.InertiaTensor, airplane_model.InertiaTensorRotation);

            AeroSurface[] aeros = CreateAeroSurfaces(airplane_model.Wings, _body.Transform_ToWorld);

            //TODO: thrusters, other components

            _aero_physics = new AircraftPhysics(_body, aeros);


            _body.Position = new Point3D(0, 0, 144);
        }

        #endregion

        #region Event Listeners

        private void Timer_Tick(object sender, EventArgs e)
        {
            if (_body == null)
            {
                lblInfo.Text = "";
                return;
            }

            _aero_physics.Tick();

            _body.AddAccel(_gravity);

            _body.Tick(_timer.Interval.TotalSeconds);



            StringBuilder info = new StringBuilder();

            info.AppendLine($"position: {_body.Position.ToStringSignificantDigits(3)}");
            info.AppendLine($"rotation: {_body.Rotation.Axis.ToStringSignificantDigits(3)}  --|--  {_body.Rotation.Angle.ToStringSignificantDigits(1)}");
            info.AppendLine($"velocity: {_body.Velocity.ToStringSignificantDigits(3)}");
            info.AppendLine($"angular velocity: {_body.AngularVelocity.ToStringSignificantDigits(3)}");


            lblInfo.Text = info.ToString();
        }

        #endregion

        #region Private Methods

        private static AeroSurface[] CreateAeroSurfaces(Models.PlanePart_Wing[] wings, Transform3D body_toWorld)
        {
            if (wings == null || wings.Length == 0)
                return new AeroSurface[0];

            var retVal = new List<AeroSurface>();

            foreach (var wing in wings)
            {
                //TODO: AeroSurfaceConfig and PlanePart_Wing are nearly identical.  c# will keep them separate so it's closer to the
                //original code, but the lua version should probably just have one class
                var config = new AeroSurfaceConfig()
                {
                    liftSlope = wing.liftSlope,
                    skinFriction = wing.skinFriction,
                    zeroLiftAoA = wing.zeroLiftAoA,
                    stallAngleHigh = wing.stallAngleHigh,
                    stallAngleLow = wing.stallAngleLow,
                    chord = wing.chord,
                    flapFraction = wing.flapFraction,
                    span = wing.span,
                };

                var transforms = GetTransforms(body_toWorld, wing.Position, wing.Orientation);

                retVal.Add(new AeroSurface(config, wing.Position, transforms.to_world, transforms.to_local));
            }

            return retVal.ToArray();
        }

        private static (Transform3D to_world, Transform3D to_local) GetTransforms(Transform3D body_toWorld, Point3D position, Quaternion orientation)
        {
            var to_world = new Transform3DGroup();
            to_world.Children.Add(body_toWorld);

            if (!orientation.IsIdentity)
                to_world.Children.Add(new RotateTransform3D(new QuaternionRotation3D(orientation)));

            if (!position.IsNearZero())
                to_world.Children.Add(new TranslateTransform3D(position.ToVector()));

            Matrix3D matrix = to_world.Value;
            matrix.Invert();

            var to_local = new Transform3DGroup();
            to_local.Children.Add(new MatrixTransform3D(matrix));

            return (to_world, to_local);
        }

        #endregion

        private static void notes()
        {
            // take in json to also test the serialization/deserialization



            // make a map class that procedurally generates and garbage collects objects
            // it should raise events for object creation/destruction
            //  rings to fly through
            //  islands of ground and cube buildings


            // start the player at some altitude, let them gain speed naturally



            // make a separate folder for the plane physics classes.  These should be as close to 1:1 with
            // lua as possible

        }
    }
}
