using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using HandinTwo.Interfaces;

namespace HandinTwo.Classes
{
    public enum LadeskabState
    {
        Available,
        Locked,
        DoorOpen
    };
    public class StationControl
    {
        // Enum med tilstande ("states") svarende til tilstandsdiagrammet for klassen
       

        // Her mangler flere member variable
        private LadeskabState _state;
        private IChargeControl _charger;
        private int _oldId;
        private IDoor _door;
        private IRfidReader _reader;
        private IDisplay _display;
        private ILogFile _log;

        public LadeskabState State
        {
            get => _state;
        }
        public StationControl(IChargeControl c, IDoor d, IRfidReader r, IDisplay dp, ILogFile l)
        {
            _state = LadeskabState.Available;
            _charger = c;
            _door = d;
            _reader = r;
            _display = dp;
            _log = l;

            
            _reader.ReadRfidEvent += OnRfidDetected;
            _door.OpenDoorEvent += DoorOpenedHandler;
            _door.CloseDoorEvent += DoorClosedHandler;

            _display.Available();

        }

        private void OnRfidDetected(object sender, RfidEventArgs e)
        {
               
            RfidDetected(e.Id);
        }

        private void DoorOpenedHandler(object sender, EventArgs e)
        {
            OnDoorOpened();
        }

        private void DoorClosedHandler(object sender, EventArgs e)
        {
            OnDoorClosed();
        }

        private void OnDoorOpened()
        {
            switch (_state)
            {
                case LadeskabState.Available:
                    _state = LadeskabState.DoorOpen;
                    _display.PhoneConnect();
                    break;
                default:
                    break;
            }
        }

        private void OnDoorClosed()
        {
            switch (_state)
            {
                case LadeskabState.DoorOpen:
                    _state = LadeskabState.Available;
                    _display.RFidRead();
                    break;
                default:
                    break;
            }
        }

        

       
        private void RfidDetected(int id)
        {
            switch (_state)
            {
                case LadeskabState.Available:
                    // Check for ladeforbindelse
                    if (_charger.Connected())
                    {
                        _door.DoorLock();
                        _charger.StartCharge();
                        _oldId = id;
                        _log.LogDoorLocked(id);

                        _display.IsOccupied(id);
                        _state = LadeskabState.Locked;
                    }
                    else
                    {
                        _display.ConnectionError();
                    }

                    break;

                case LadeskabState.DoorOpen:
                    // Ignore
                    break;

                case LadeskabState.Locked:
                    // Check for correct ID
                    if (id == _oldId)
                    {
                        _charger.StopCharge();
                        _door.DoorUnlock();
                        _log.LogDoorUnlocked(id);

                        _display.PhoneRemove();
                        _state = LadeskabState.Available;
                    }
                    else
                    {
                        _display.RFidError();
                    }

                    break;
            }
        }

      
    }
}
