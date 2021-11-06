using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExOne
{
    public interface IFlashSwitch
    {
        public int _state { get; set; }

        void OnOffSwitch();
    }
}
