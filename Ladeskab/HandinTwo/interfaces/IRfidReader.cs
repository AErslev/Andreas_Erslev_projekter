using System;
using System.Collections.Generic;
using System.Text;

namespace HandinTwo.Interfaces
{

    public class RfidEventArgs : EventArgs
    {
        public RfidEventArgs(int id)
        {
            Id = id;
        }
        public int Id { get; set; }
    }

    public interface IRfidReader
    {
        event EventHandler<RfidEventArgs> ReadRfidEvent;

        public void OnRfidRead(int id);
    }
}
