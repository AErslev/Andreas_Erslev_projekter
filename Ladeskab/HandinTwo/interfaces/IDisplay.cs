using System;
using System.Collections.Generic;
using System.Text;

namespace HandinTwo.Interfaces
{
    public interface IDisplay
    {
        void RFidRead();
        void RFidError();
        void PhoneConnect();
        void PhoneRemove();
        void ConnectionError();
        void IsOccupied(int id);
        void Available();

    }
}
