using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace StatePattern
{
    public class Strobe : IMode
    {
        // Sætter værdien for hvilken mode er aktiv
        private readonly bool modeType = false;
        // Event handler for at bestemme mode
        public void HandleMode(object sender, On context)
        {
            context.SetModeState(new Solid());
        }
        // Retunere mode typen
        public bool ModeType()
        {
            return modeType;
        }
    }
}
