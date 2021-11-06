using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExOne
{
    public class FlashSwitch : IFlashSwitch
    {
        public int _state { get; set; }

        public void OnOffSwitch()
        {
            switch (_state) {
                case 1:
                    Console.WriteLine("Flashlight On");
                    break;
                case 0:
                    Console.WriteLine("Flashlight Off");
                    break;
            }
        }
    }
}
