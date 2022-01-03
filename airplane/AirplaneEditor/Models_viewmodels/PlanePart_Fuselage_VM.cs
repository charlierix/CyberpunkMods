using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor.Models_viewmodels
{
    public record PlanePart_Fuselage_VM : PlanePart_VM
    {
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
    }
}
