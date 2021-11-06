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
    public class TestRfidReaderUnit
    {

        public RfidReader _uut;

        [SetUp]
        public void Setup()
        {
            _uut = new RfidReader();

        }

        [TestCase(123, 123)]
        [TestCase(555, 555)]
        [TestCase(111, 111)]
        public void RfidEventRaised(int _num1, int _num2)
        {
            int TestId = 0;
            _uut.ReadRfidEvent += (sender, args) => TestId = args.Id;

            _uut.OnRfidRead(_num1);

            Assert.That(TestId, Is.EqualTo(_num2));
        }

    }
}
