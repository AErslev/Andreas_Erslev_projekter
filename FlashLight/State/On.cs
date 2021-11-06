using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StatePattern
{
    // On state 
    public class On : FlashLightState
    {
        // Opsætter relevante værdier tilknyttet On/Off state
        private readonly bool _onOffState = true;
        private readonly string _activeState = "On";

        // Bestemmer _mode af typen On
        private IMode _mode;

        // Udfører event ud fra hvilket event der sendes
        public override void Mode(FlashLightState e, EventHandler<On> handler)
        {

            handler?.Invoke(this, (On)e);

        }
        // Bestemmer hvilket mode der er aktivt
        public void SetModeState(IMode mode)
        {
            _mode = mode;
        }
        // Retunere information om hvilket mode er aktivt
        public override bool ModeType()
        {
            return _mode.ModeType();
        }
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
            context.SetState(new Off());
        }
    }
}
