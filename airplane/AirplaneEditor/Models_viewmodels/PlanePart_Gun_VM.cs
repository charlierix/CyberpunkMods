using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor.Models_viewmodels
{
    public record PlanePart_Gun_VM : PlanePart_VM
    {
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
    }
}
