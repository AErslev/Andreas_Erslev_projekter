using System;

namespace StatePattern
{
    class Program
    {

        static void Main(string[] args)
        {
            // Opsætning af Flashligt fra interface
            IFlashLight flashLight = new FlashLight();

            // Opsætning af abstract klasse til at styre state
            FlashLightState _state;

            // Bestemmer hvilket state der er aktivt
            bool active = false;

            // Sætter handler for "On" state
            _state = new On();
            flashLight.PowerEventOn += _state.HandlePower;

            // Sætter handler for "On" state
            _state = new Off();
            flashLight.PowerEventOff += _state.HandlePower;

            // Kalder events 4 gange - 2 pr. state
            // active skifter på kald og bestemmer da hvilket event der aktiveres
            for (int n = 0, i = 0; n < 4; n++, active = !active)
            {
                if (active)
                {
                    // Viser at hvis samme state kaldes 2 gange vil der ignoreres for at sætte nyt state
                    flashLight.Power(flashLight, false);
                    flashLight.Power(flashLight, false);
                }
                else if (!active)
                {
                    flashLight.Power(flashLight, true);
                }

                flashLight.LightSwitch();

            }
        }
    }
}
