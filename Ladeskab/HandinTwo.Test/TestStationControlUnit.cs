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
    class TestStationControlUnit
    {
        private StationControl _uut;
        private IChargeControl _chargerSub;
        private IDoor _doorSub;
        private IRfidReader _readerSub;
        private IDisplay _displaySub;
        private ILogFile _logSub;

        [SetUp]
        public void Setup()
        {
            _chargerSub = Substitute.For<IChargeControl>();
            _doorSub = Substitute.For<IDoor>();
            _readerSub = Substitute.For<IRfidReader>();
            _displaySub = Substitute.For<IDisplay>();
            _logSub = Substitute.For<ILogFile>();
            _uut = new StationControl(_chargerSub, _doorSub, _readerSub, _displaySub, _logSub);
        }

        [Test]
        public void TestInitState()
        {
            Assert.That(_uut.State, Is.EqualTo(LadeskabState.Available));
            _displaySub.Received().Available();

        }

        [Test]
        public void TestOpenDoor_WhenAvailable()
        {
            // Raising event that signifies Door opening
            _doorSub.OpenDoorEvent += Raise.Event();

            Assert.That(_uut.State, Is.EqualTo(LadeskabState.DoorOpen));
            _displaySub.Received().PhoneConnect();
        }

        [Test]
        public void TestOpenDoor_WhenDoorOpen()
        {
            // Raising event that signifies Door opening
            _doorSub.OpenDoorEvent += Raise.Event();
            // State is now DoorOpen
            _displaySub.ClearReceivedCalls();
            // Raising event that signifies Door opening
            _doorSub.OpenDoorEvent += Raise.Event();
            //IDisplay.PhoneConnect() should not have been called again. State should remain DoorOpen

            _displaySub.DidNotReceive().PhoneConnect();
            Assert.That(_uut.State, Is.EqualTo(LadeskabState.DoorOpen));
        }

        [Test]
        public void TestOpenDoor_WhenLocked()
        {
            _chargerSub.Connected().Returns(true);
            _readerSub.ReadRfidEvent += Raise.EventWith(new object(), new RfidEventArgs(0));
            //State is now Locked
            _displaySub.ClearReceivedCalls();
            // Raising event that signifies Door opening
            _doorSub.OpenDoorEvent += Raise.Event();
            //IDisplay.PhoneConnect() should not have been called. State should remain Locked
            _displaySub.DidNotReceive().PhoneConnect();
            Assert.That(_uut.State, Is.EqualTo(LadeskabState.Locked));
        }

        [Test]
        public void TestCloseDoor_WhenDoorOpen()
        {
            _doorSub.OpenDoorEvent += Raise.Event();
            // State is now DoorOpen
            _displaySub.ClearReceivedCalls();
            // Raising event that signifies Door closing
            _doorSub.CloseDoorEvent += Raise.Event();

            Assert.That(_uut.State, Is.EqualTo(LadeskabState.Available));
            _displaySub.Received().RFidRead();

        }

        [Test]
        public void TestCloseDoor_WhenAvailable()
        {
            // Raising event that signifies Door closing
            _doorSub.CloseDoorEvent += Raise.Event();

            //State should remain unchanged (Available)
            // IDisplay.RFidRead() should not have been called
            Assert.That(_uut.State, Is.EqualTo(LadeskabState.Available));
            _displaySub.DidNotReceive().RFidRead();

        }

        [Test]
        public void TestCloseDoor_WhenLocked()
        {
            _chargerSub.Connected().Returns(true);
            _readerSub.ReadRfidEvent += Raise.EventWith(new object(), new RfidEventArgs(0));
            //State is now Locked
            _displaySub.ClearReceivedCalls();
            //State should remain unchanged (Locked)
            // IDisplay.RFidRead() should not have been called
            Assert.That(_uut.State, Is.EqualTo(LadeskabState.Locked));
            _displaySub.DidNotReceive().RFidRead();

        }

        [TestCase(123)]
        [TestCase(0)]
        [TestCase(10)]
        public void TestReadRFID_WhenAvailable_AndConnected(int id)
        {
            _chargerSub.Connected().Returns(true);
            _readerSub.ReadRfidEvent += Raise.EventWith(new object(), new RfidEventArgs(id));

            // State should be Locked
            // IDisplay.IsOccupied(id) should have been called
            // IDoor.DoorLock should have been called
            // ILog.LogDoorLocked(id) should have been called
            // ICharger.StartCharge() should have been called

            Assert.That(_uut.State, Is.EqualTo(LadeskabState.Locked));
            _displaySub.Received().IsOccupied(id);
            _doorSub.Received().DoorLock();
            _logSub.Received().LogDoorLocked(id);
            _chargerSub.Received().StartCharge();
        }

        [Test]
        public void TestReadRFID_WhenAvailable_AndNotConnected()
        {
            _chargerSub.Connected().Returns(false);
            _readerSub.ReadRfidEvent += Raise.EventWith(new object(), new RfidEventArgs(0));

            Assert.That(_uut.State, Is.EqualTo(LadeskabState.Available));
            _displaySub.DidNotReceiveWithAnyArgs().IsOccupied(default);
            _doorSub.DidNotReceive().DoorLock();
            _logSub.DidNotReceiveWithAnyArgs().LogDoorLocked(default);
            _chargerSub.DidNotReceive().StartCharge();

            _displaySub.Received().ConnectionError();
        }

        [Test]
        public void TestReadRFID_WhenDoorOpen()
        {
            _doorSub.OpenDoorEvent += Raise.Event();
            // State is now DoorOpen
            _displaySub.ClearReceivedCalls();

            _readerSub.ReadRfidEvent += Raise.EventWith(new object(), new RfidEventArgs(0));

            //State should remain unchanged (DoorOpen)
            Assert.That(_uut.State, Is.EqualTo(LadeskabState.DoorOpen));
            // None of the calls associated with door locking should have been made. 
            // See TestReadRFID_WhenAvailable_AndConnected(int id) for more details.
            _displaySub.DidNotReceiveWithAnyArgs().IsOccupied(default);
            _doorSub.DidNotReceive().DoorLock();
            _logSub.DidNotReceiveWithAnyArgs().LogDoorLocked(default);
            _chargerSub.DidNotReceive().StartCharge();



        }

        [TestCase(1)]
        [TestCase(20)]
        [TestCase(Int32.MaxValue)]

    public void TestReadRFID_WhenLocked_WithSameID(int id)
        {
            _chargerSub.Connected().Returns(true);
            _readerSub.ReadRfidEvent += Raise.EventWith(new object(), new RfidEventArgs(id));
            //State is now Locked.
            _displaySub.ClearReceivedCalls();

            _readerSub.ReadRfidEvent += Raise.EventWith(new object(), new RfidEventArgs(id));

            //State should now be Available.
            //ICharger.StopCharge() should have been called
            //IDoor.DoorUnlock() should have been called
            //ILog.LogDoorUnlocked(id) should have been called
            //IDisplay.PhoneRemove() should have been called
            _chargerSub.Received().StopCharge();
            _doorSub.Received().DoorUnlock();
            _logSub.Received().LogDoorUnlocked(id);
            _displaySub.Received().PhoneRemove();
            Assert.That(_uut.State,Is.EqualTo(LadeskabState.Available));
        }

    [TestCase(1,10)]
    [TestCase(10,1)]
    [TestCase(Int32.MaxValue,0)]
    public void TestReadRFID_WhenLocked_WithDifferentId(int id1, int id2)
    {
        _chargerSub.Connected().Returns(true);
        _readerSub.ReadRfidEvent += Raise.EventWith(new object(), new RfidEventArgs(id1));
        //State is now Locked.
        _displaySub.ClearReceivedCalls();

        _readerSub.ReadRfidEvent += Raise.EventWith(new object(), new RfidEventArgs(id2));

            //State should now be unchanged (Locked)
            //ICharger.StopCharge() should not have been called
            //IDoor.DoorUnlock() should not have been called
            //ILog.LogDoorUnlocked(id) should not have been called
            //IDisplay.PhoneRemove() should not have been called
            //IDisplay.RFidError() should have been
            //
            _chargerSub.DidNotReceive().StopCharge();
            _doorSub.DidNotReceive().DoorUnlock();
            _logSub.DidNotReceiveWithAnyArgs().LogDoorUnlocked(default);
            _displaySub.DidNotReceive().PhoneRemove();
            _displaySub.Received().RFidError();
            Assert.That(_uut.State, Is.EqualTo(LadeskabState.Locked));


        }




    }
}
