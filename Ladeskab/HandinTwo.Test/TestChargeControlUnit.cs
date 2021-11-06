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
    class TestChargeControlUnit
    {
        private ChargeControl _uut;
        private IUsbCharger _usbSub;

        [SetUp]
        public void Setup()
        {
            _usbSub = Substitute.For<IUsbCharger>();
            _uut = new ChargeControl(_usbSub);

        }

        [Test]
        public void StartChargeTest()
        {
            _uut.StartCharge();
            _usbSub.Received().StartCharge();
        }

        [Test]
        public void StopChargeTest()
        {
            _uut.StopCharge();
            _usbSub.Received().StopCharge();
        }

        [TestCase(true)]
        [TestCase(false)]

        public void ConnectedTest(bool v)
        {
            bool res;
            _usbSub.Connected.Returns(v);
            res = _uut.Connected();
            Assert.That(res, Is.EqualTo(v));


        }
    }
}
