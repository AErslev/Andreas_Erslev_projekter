using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StatePattern
{
    // Abstract klasse - kan udvides hvis der kræves samme metode i alle states
    public abstract class FlashLightState : EventArgs
    {
        public abstract bool OnOff();
        public abstract string ActiveState();
        public abstract void HandlePower(object sender, IFlashLight context);
        public virtual void HandleMode(object sender, On context) { }
        public virtual void Mode(FlashLightState e, EventHandler<On> handler) { }
        public virtual bool ModeType() { return false; }
    }
}
