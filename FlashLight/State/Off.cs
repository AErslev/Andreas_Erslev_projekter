using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StatePattern
{
    // Off state
    public class Off : FlashLightState
    {
        // Opsætter relevante værdier tilknyttet On/Off state
        private readonly bool _onOffState = false;
        private readonly string _activeState = "Off";

        // Retunere information om state er On eller Off
        public override bool OnOff()
        {
            return _onOffState;
        }
        // Fortæller hvilket state der er aktivt
        public override string ActiveState()
        {
            return _activeState;
        }
        // Handler der kaldes ved "Invoke" kald
        public override void HandlePower(object sender, IFlashLight context)
        {
            context.SetState(new On());
        }
    }
}
