using AirplaneEditor.Models_viewmodels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AirplaneEditor
{
    /// <summary>
    /// This is just a common place for information to be shared
    /// </summary>
    /// <remarks>
    /// It is intended to only be used by the main thread (it's not thread safe)
    /// 
    /// There is also the expectation that there will only be one instance of an editor per process
    /// (not editing multiple planes in the same process)
    /// </remarks>
    public class Blackboard
    {
        // Any editor that can select parts can set this and all editors should reflect that change
        public event EventHandler<PlanePart> SelectedPartChanged = null;
        public static void PartSelected(PlanePart part)
        {
            _instance.Value.SelectedPartChanged?.Invoke(_instance.Value, part);
        }

        private static Lazy<Blackboard> _instance = new Lazy<Blackboard>(() => new Blackboard());
        public static Blackboard Instance => _instance.Value;
    }
}
