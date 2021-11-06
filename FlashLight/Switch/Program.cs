using System;

namespace ExOne
{
    class Program
    {
        static void Main(string[] args)
        {
            IFlashSwitch _flashSwitch = new FlashSwitch();

            _flashSwitch._state = 0;

            _flashSwitch.OnOffSwitch();

            _flashSwitch._state = 1;

            _flashSwitch.OnOffSwitch();

        }
    }
}
