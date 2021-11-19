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
using System.Windows.Shapes;

namespace AirplaneEditor
{
    public partial class Tester : Window
    {
        #region Declaration Section

        private Map _map = null;

        #endregion

        //NOTE: take in json to also test the serialization/deserialization
        public Tester()
        {
            InitializeComponent();
        }

        private static void notes()
        {

            // make a map class that procedurally generates and garbage collects objects
            // it should raise events for object creation/destruction
            //  rings to fly through
            //  islands of ground and cube buildings


            // start the player at some altitude, let them gain speed naturally



            // make a separate folder for the plane physics classes.  These should be as close to 1:1 with
            // lua as possible


        }
    }
}
