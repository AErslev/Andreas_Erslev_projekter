using System;
using System.Collections.Generic;
using System.Text;
using HandinTwo.Interfaces;

namespace HandinTwo.Classes
{
    public class ChargeControl : IChargeControl
    {
        private IUsbCharger _charger;

        public ChargeControl(IUsbCharger charger)
        {
            _charger = charger;
        }

        public void StartCharge()
        {
            _charger.StartCharge();

            

        }
        public void StopCharge()
        {


            _charger.StopCharge();

        }

        public bool Connected() { return _charger.Connected; }

    }
}
