using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor.Models_viewmodels
{
    public record PlanePart_Wing_VM : PlanePart_VM
    {
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
    }
}
