using AirplaneEditor.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Media3D;

namespace AirplaneEditor.Models_viewmodels
{
    //NOTE: the term viewmodel is used loosely.  The wpf controls are still very programmatically manipulated
    public record PlanePart_VM
    {
        public event EventHandler NameChanged = null;
        public event EventHandler IsCenterlineChanged = null;
        public event EventHandler PositionChanged = null;
        public event EventHandler RotationChanged = null;

        public PlanePartType PartType { get; init; }

        private string _name = "";
        public string Name
        {
            get => _name;
            set
            {
                _name = value;
                NameChanged?.Invoke(this, new EventArgs());
            }
        }

        private bool _isCenterline = false;
        public bool IsCenterline
        {
            get => _isCenterline;
            set
            {
                _isCenterline = value;
                IsCenterlineChanged?.Invoke(this, new EventArgs());
            }
        }

        //NOTE: Be sure to store new values when changing, or event won't fire
        private Point3D _position;
        public Point3D Position
        {
            get => _position;
            set
            {
                _position = value;
                PositionChanged?.Invoke(this, new EventArgs());
            }
        }

        private Quaternion _orientation;
        public Quaternion Orientation
        {
            get => _orientation;
            set
            {
                _orientation = value;
                RotationChanged?.Invoke(this, new EventArgs());
            }
        }

        public PlanePart_VM Parent { get; init; }
        public ObservableCollection<PlanePart_VM> Children { get; } = new ObservableCollection<PlanePart_VM>();
    }
}
