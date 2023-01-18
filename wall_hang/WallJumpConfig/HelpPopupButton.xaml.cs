using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WallJumpConfig
{
    public partial class HelpPopupButton : UserControl
    {
        public HelpPopupButton()
        {
            InitializeComponent();
        }

        private void Grid_MouseEnter(object sender, MouseEventArgs e)
        {
            popupHelp.IsOpen = true;
        }
        private void Grid_MouseLeave(object sender, MouseEventArgs e)
        {
            popupHelp.IsOpen = false;
        }
        private void Grid_MouseDown(object sender, MouseButtonEventArgs e)
        {
        }
    }
}
