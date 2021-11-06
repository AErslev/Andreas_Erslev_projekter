using System;
using System.Collections.Generic;
using System.Text;
using HandinTwo.Interfaces;

namespace HandinTwo.Classes
{

    public class RfidReader : IRfidReader
    {

        public event EventHandler<RfidEventArgs> ReadRfidEvent;

        public void OnRfidRead(int id)
        {
            EventHandler<RfidEventArgs> handler = ReadRfidEvent;
            handler?.Invoke(this, new RfidEventArgs(id));
        }
        
    }
}
