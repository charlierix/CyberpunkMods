using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Effects;
using System.Windows.Media;
using System.Windows;
using WallJumpConfig.Models.wpf;
using Game.Math_WPF.WPF;
using System.Reflection.Metadata;

namespace WallJumpConfig.Models.viewmodels
{
    public class VM_PropsAtAngle : DependencyObject
    {
        public string Name
        {
            get { return (string)GetValue(NameProperty); }
            set { SetValue(NameProperty, value); }
        }
        public static readonly DependencyProperty NameProperty = DependencyProperty.Register("Name", typeof(string), typeof(VM_PropsAtAngle), new PropertyMetadata(""));

        public Brush Color
        {
            get { return (Brush)GetValue(ColorProperty); }
            set { SetValue(ColorProperty, value); }
        }
        public static readonly DependencyProperty ColorProperty = DependencyProperty.Register("Color", typeof(Brush), typeof(VM_PropsAtAngle), new PropertyMetadata(Brushes.Transparent));

        public static VM_PropsAtAngle FromModel(PropsAtAngle props, string name, string color)
        {
            return new VM_PropsAtAngle()
            {
                Name = name,

                Color = string.IsNullOrWhiteSpace(color) ?
                    Brushes.Transparent :
                    UtilityWPF.BrushFromHex(color),
            };
        }
    }
}
