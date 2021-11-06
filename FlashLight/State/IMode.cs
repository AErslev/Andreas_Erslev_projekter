using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StatePattern
{
    public interface IMode
    {
        public void HandleMode(object sender, On context);
        public bool ModeType();

    }
}
