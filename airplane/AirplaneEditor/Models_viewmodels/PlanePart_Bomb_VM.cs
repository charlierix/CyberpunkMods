using AirplaneEditor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor.Models_viewmodels
{
    public record PlanePart_Bomb_VM : PlanePart_VM
    {
        public override PlanePartType PartType => PlanePartType.Bomb;

        private double _size = 1;
        public double Size
        {
            get => _size;
            set
            {
                _size = value;
                OnSizeChanged();
            }
        }

        public override double[] ToSizesArr()
        {
            return new[] { Size };
        }
        public override void FromSizesArr(double[] sizes)
        {
            if (sizes == null)
                throw new ArgumentNullException(nameof(sizes));

            if (sizes.Length != 1)
                throw new ArgumentOutOfRangeException(nameof(sizes), $"Sizes array muse be length one: {sizes.Length}");

            Size = sizes[0];
        }
    }
}
