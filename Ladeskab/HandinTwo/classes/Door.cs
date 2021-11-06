using System;
using System.Collections.Generic;
using System.Text;
using HandinTwo.Interfaces;

namespace HandinTwo.Classes
{
    public class Door : IDoor
    {

        private bool _isLocked = false;

        public bool IsLocked { get => _isLocked; }

        public void DoorLock()
        {
            _isLocked = true;
        }

        public void DoorUnlock()
        {
            _isLocked = false;
        }

        public event EventHandler<EventArgs> OpenDoorEvent;

        public event EventHandler<EventArgs> CloseDoorEvent;

        public void OnDoorOpen()
        {
            EventHandler<EventArgs> handler = OpenDoorEvent;

            if (!_isLocked)
                handler?.Invoke(this, new EventArgs());

        }

        public void OnDoorClosed()
        {
            EventHandler<EventArgs> handler = CloseDoorEvent;

            handler?.Invoke(this, new EventArgs());

        }
    }
}
