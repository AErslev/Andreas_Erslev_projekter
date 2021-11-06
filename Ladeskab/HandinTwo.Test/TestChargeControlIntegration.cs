using System;
using System.Collections.Generic;
using System.Text;
using HandinTwo.Classes;
using HandinTwo.Interfaces;
using NSubstitute;
using NUnit.Framework;

namespace HandinTwo.Test
{
    [TestFixture]
    class TestChargeControlIntegration
    {

        private ChargeControl _uut;
        private IUsbCharger _usb;

        [SetUp]
        public void Setup()
        {
            _usb = new UsbChargerSimulator();
            _uut = new ChargeControl(_usb);
        }

        [Test]
        public void StartChargeTest()
        {
            Assert.That(_usb.CurrentValue, Is.EqualTo(0));
            
            _uut.StartCharge();

            Assert.That(_usb.CurrentValue, Is.Not.EqualTo(0));
        }

        [Test]
        public void StopChargeTest()
        {
            _uut.StartCharge();

            Assert.That(_usb.CurrentValue, Is.Not.EqualTo(0));
            
            _uut.StopCharge();

            Assert.That(_usb.CurrentValue, Is.EqualTo(0));
        }

        [TestCase(true)]
        [TestCase(false)]
        public void ConnectedTest(bool v)
        {
            bool res;
            _usb.SimulateConnected(v);
            res = _uut.Connected();
            Assert.That(res, Is.EqualTo(v));
        }

    }
}
