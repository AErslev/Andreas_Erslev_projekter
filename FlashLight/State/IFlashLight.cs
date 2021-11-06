using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StatePattern
{
    // Interface for FlashLight
    public interface IFlashLight
    {
        public event EventHandler<IFlashLight> PowerEventOn;
        public event EventHandler<IFlashLight> PowerEventOff;
        public void Power(IFlashLight e, bool _eventActive);
        public void SetState(FlashLightState s);
        public void LightSwitch();


    }
}
