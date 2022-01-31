using AirplaneEditor.Airplane;
using AirplaneEditor.Models;
using Game.Math_WPF.Mathematics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor.Models_viewmodels
{
    public record PlanePart_Wing_VM : PlanePart_VM
    {
        public override PlanePartType PartType => PlanePartType.Wing;

        private double _span = 1;
        /// <summary>
        /// The part of the wing that runs perpendicular to the fuselage
        /// </summary>
        public double Span
        {
            get => _span;
            set
            {
                _span = value;
                OnSizeChanged();
            }
        }

        private double _chord = 1;
        /// <summary>
        /// The part of the wing that runs parallel to the fuselage
        /// </summary>
        public double Chord
        {
            get => _chord;
            set
            {
                _chord = value;
                OnSizeChanged();
            }
        }

        private double _thickness = 0.5;
        public double Thickness
        {
            get => _thickness;
            set
            {
                _thickness = value;
                OnSizeChanged();
            }
        }

        public double Lift => AeroSurfaceConfig.Convert_ThicknessToLift(Thickness);

        public override double[] ToSizesArr()
        {
            return new[]
            {
                Chord,
                Span,
                Thickness,
            };
        }
        public override void FromSizesArr(double[] sizes)
        {
            if (sizes == null)
                throw new ArgumentNullException(nameof(sizes));

            if (sizes.Length != 3)
                throw new ArgumentOutOfRangeException(nameof(sizes), $"Sizes array must be length three: {sizes.Length}");

            Chord = sizes[0];
            Span = sizes[1];
            Thickness = sizes[2];
        }
    }
}
