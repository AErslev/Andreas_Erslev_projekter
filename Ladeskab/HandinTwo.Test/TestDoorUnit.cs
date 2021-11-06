using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using HandinTwo;
using HandinTwo.Classes;

namespace HandinTwo.Test
{
    [TestFixture]
    public class TestDoorUnit
    {
        private Door _uut;

        [SetUp]
        public void Setup()
        {
            _uut = new Door();
        }

        [Test]
        public void Test_Init_IsLocked()
        {

            Assert.IsFalse(_uut.IsLocked);
        }

        [Test] 
        public void Test_DoorLock()
        {
            _uut.DoorLock();

            Assert.IsTrue(_uut.IsLocked);
        }

        [Test]
        public void Test_DoorUnlock()
        {
            _uut.DoorUnlock();

            Assert.IsTrue(!_uut.IsLocked);
        }

        [Test]
        public void Test_OpenDoorEvent_Unlocked()
        {

            int eventCount = 0;

            _uut.OpenDoorEvent += (sender, args) => eventCount++;

            _uut.OnDoorOpen();

            Assert.That(eventCount, Is.EqualTo(1));

        }

        [Test]
        public void Test_OpenDoorEvent_Locked()
        {

            int eventCount = 0;

            _uut.OpenDoorEvent += (sender, args) => eventCount++;

            _uut.DoorLock();

            _uut.OnDoorOpen();

            Assert.That(eventCount, Is.EqualTo(0));

        }

        [Test]
        public void Test_CloseDoorEvent()
        {

            int eventCount = 0;

            _uut.CloseDoorEvent += (sender, args) => eventCount++;

            _uut.OnDoorClosed();

            Assert.That(eventCount, Is.EqualTo(1));

        }

    }

}
