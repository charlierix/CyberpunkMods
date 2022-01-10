using AirplaneEditor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor.Models_viewmodels
{
    public record PlanePart_Fuselage_VM : PlanePart_VM
    {
        public override PlanePartType PartType => PlanePartType.Fuselage;

        private double _length = 1;
        public double Length
        {
            get => _length;
            set
            {
                _length = value;
                OnSizeChanged();
            }
        }

        private double _diameter = 1;
        public double Diameter
        {
            get => _diameter;
            set
            {
                _diameter = value;
                OnSizeChanged();
            }
        }

        public override double[] ToSizesArr()
        {
            return new[]
            {
                Length,
                Diameter,
            };
        }
        public override void FromSizesArr(double[] sizes)
        {
            if (sizes == null)
                throw new ArgumentNullException(nameof(sizes));

            if (sizes.Length != 2)
                throw new ArgumentOutOfRangeException(nameof(sizes), $"Sizes array muse be length two: {sizes.Length}");

            Length = sizes[0];
            Diameter = sizes[1];
        }
    }
}
