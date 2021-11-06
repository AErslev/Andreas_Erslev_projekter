using System;
using System.Collections.Generic;
using System.Text;

namespace HandinTwo.Interfaces
{

    public interface IDoor
    {
        void DoorLock();
        void DoorUnlock();

        event EventHandler<EventArgs> OpenDoorEvent;

        event EventHandler<EventArgs> CloseDoorEvent;

        public void OnDoorOpen();

        public void OnDoorClosed();
    }
}
