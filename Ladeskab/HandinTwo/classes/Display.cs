using System;
using System.Collections.Generic;
using System.Text;
using HandinTwo.Interfaces;
using Console = System.Console;

namespace HandinTwo.Classes
{
    public class Display : IDisplay
    {

        public void RFidRead()
        {
            Console.WriteLine("Indlæs RFID");
        }
        public void RFidError()
        {
            Console.WriteLine("RFID fejl");
        }
        public void PhoneConnect()
        {
            Console.WriteLine("Tilslut telefon");
        }
        public void PhoneRemove()
        {
            Console.WriteLine("Fjern telefon");
        }
        public void ConnectionError()
        {
            Console.WriteLine("Tilslutningsfejl");
        }
        public void IsOccupied(int id)
        {
            Console.WriteLine($"Ladeskab optaget af {id}");
        }

        public void Available()
        {
            Console.WriteLine("Ladeskab er ledigt");
        }
    }
}
