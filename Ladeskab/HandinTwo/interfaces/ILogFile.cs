using System;
using System.Collections.Generic;
using System.Text;

namespace HandinTwo.Interfaces
{
    public interface ILogFile
    {
        void LogDoorLocked(int Id);
        void LogDoorUnlocked(int Id);
    }
}
