using HandinTwo.Interfaces;
using System;
using HandinTwo.Classes;

class Program
{
    static void Main(string[] args)
    {
        // Assemble your system here from all the classes

        string logFile = "logfile.txt"; // Navnet på systemets log-fil
        IUsbCharger usb = new UsbChargerSimulator();
        IChargeControl charger = new ChargeControl(usb);
        IDoor door = new Door();
        IRfidReader reader = new RfidReader();
        IDisplay display = new Display();
        ILogFile log = new LogFile(logFile);
        StationControl stat = new StationControl(charger, door, reader, display, log);
         


    bool finish = false;
        do
        {
            string input;
            System.Console.WriteLine("Indtast E, O, C, R, A, S: ");
            input = Console.ReadLine();
            if (string.IsNullOrEmpty(input)) continue;

            switch (input[0])
            {
                case 'E':
                    finish = true;
                    break;

                case 'O':
                    door.OnDoorOpen();
                    break;

                case 'C':
                    door.OnDoorClosed();
                    break;

                case 'R':
                    System.Console.WriteLine("Indtast RFID id: ");
                    string idString = System.Console.ReadLine();

                    int id = Convert.ToInt32(idString);
                    reader.OnRfidRead(id);
                    break;
                case 'A':
                    if (stat.State == LadeskabState.DoorOpen)
                    {
                        usb.SimulateConnected(true);
                        Console.WriteLine("Telefon tilsluttet");
                    }

                    break;
                case 'S':
                    if (stat.State == LadeskabState.DoorOpen)
                    {
                        usb.SimulateConnected(false);
                        Console.WriteLine("Telefon frasluttet");
                    }

                    break;
                default:
                    break;
            }

        } while (!finish);
    }
}

