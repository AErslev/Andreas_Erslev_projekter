using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using HandinTwo.Classes;
using HandinTwo.Interfaces;
using NUnit.Framework;

namespace HandinTwo.Test
{
    [TestFixture]
    public class TestDisplayUnit
    {

        public Display _uut;
        public StringWriter _text;


        [SetUp]
        public void Setup()
        {
            _uut = new Display();
            _text = new StringWriter();
            Console.SetOut(_text);

        }

        [Test]
        public void RFidReadTest()
        {
            _uut.RFidRead();
            Assert.That(_text.ToString(),Is.EqualTo("Indlæs RFID\r\n"));
        }
        
        [Test]
        public void RFidErrorTest()
        {
            _uut.RFidError();
            Assert.That(_text.ToString(), Is.EqualTo("RFID fejl\r\n"));
        }

        [Test]
        public void PhoneConnectTest()
        {
            _uut.PhoneConnect();
            Assert.That(_text.ToString(), Is.EqualTo("Tilslut telefon\r\n"));

        }
        [Test]
        public void PhoneRemoveTest()
        {
            _uut.PhoneRemove();
            Assert.That(_text.ToString(), Is.EqualTo("Fjern telefon\r\n"));

        }
        [Test]
        public void ConnectionErrorTest()
        {
            _uut.ConnectionError();
            Assert.That(_text.ToString(), Is.EqualTo("Tilslutningsfejl\r\n"));

        }

        [TestCase(0)]
        [TestCase(50)]
        public void IsOccupiedTest(int i)
        {
            _uut.IsOccupied(i);
            Assert.That(_text.ToString(), Is.EqualTo($"Ladeskab optaget af {i}\r\n"));
        }
        [Test]
        public void AvailableTest()
        {
            _uut.Available();
            Assert.That(_text.ToString(), Is.EqualTo($"Ladeskab er ledigt\r\n"));
        }

    }
}
