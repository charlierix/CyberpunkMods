using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;

namespace DebugRenderViewer
{
    public partial class App : Application
    {
        private void Application_Startup(object sender, StartupEventArgs e)
        {
            // The viewer in this project is an old version.  The version in the dll is what is maintained, so using that instead
            // https://github.com/charlierix/PartyPeople/tree/master/Math_WPF/WPF/DebugLogViewer
            new Game.Math_WPF.WPF.DebugLogViewer.DebugLogWindow().Show();
        }
    }
}
