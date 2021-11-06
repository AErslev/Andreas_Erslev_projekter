using System;
using System.Collections.Generic;
using System.Text;

namespace HandinTwo.Interfaces
{
    public interface IChargeControl
    {
        void StartCharge();
        void StopCharge();
        bool Connected();

    }
}
