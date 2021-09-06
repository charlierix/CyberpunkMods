using models;
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

namespace grapple_ui
{
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();

            var test = new Grapple
            {
                name = "hello",
            };

            var test2 = test with
            {
                name = "there"
            };

        }
    }
}
