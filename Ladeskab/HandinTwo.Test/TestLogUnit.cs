using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.CompilerServices;
using System.Text;
using HandinTwo.Interfaces;
using NUnit.Framework;
using HandinTwo.Classes;
namespace HandinTwo.Test
{
    [TestFixture]
    public class TestLogUnit
    {
        private string _fp;
        private LogFile _uut;
        string _readback;

        [SetUp]
        public void Setup()
        {
            _fp = $"TestLogFile.txt";
            File.WriteAllText(_fp, String.Empty);
            _uut = new LogFile(_fp);

            _readback = String.Empty;
        }

        [TestCase(21)]
        [TestCase(182)]
        [TestCase(56)]
        public void LogLockedTestSingleEntry(int _id)
        {
           

            _uut.LogDoorLocked(_id);
            _readback = File.ReadAllText(_fp);
            Assert.That(_readback, Is.EqualTo($"Door locked with id:{_id}\r\n"));
        }

        [TestCase(22)]
        [TestCase(183)]
        [TestCase(57)]
        public void LogUnlockedTestSingleEntry(int _id)
        {
          

            _uut.LogDoorUnlocked(_id);
            _readback = File.ReadAllText(_fp);
            Assert.That(_readback, Is.EqualTo($"Door unlocked with id:{_id}\r\n"));
        }

        [TestCase(23, 84, 72, 48)]
        [TestCase(185, 182, 1, 92)]
        [TestCase(58, 75, 75, 2)]
        public void LogMultipleEntries(int _id1, int _id2, int _id3, int _id4)
        {

         
            _uut.LogDoorLocked(_id1);
            _uut.LogDoorLocked(_id2);
            _uut.LogDoorUnlocked(_id3);
            _uut.LogDoorUnlocked(_id4);
            _readback = File.ReadAllText(_fp);
            Assert.That(_readback, Is.EqualTo($"Door locked with id:{_id1}\r\nDoor locked with id:{_id2}\r\nDoor unlocked with id:{_id3}\r\nDoor unlocked with id:{_id4}\r\n"));
        }

    }
}
