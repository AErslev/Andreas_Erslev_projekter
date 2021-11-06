using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using HandinTwo.Interfaces;

namespace HandinTwo.Classes
{
    public class LogFile : ILogFile
    {
        private string _filepath;
        public LogFile(string fp)
        {
            _filepath = fp;
            
        }
        public void LogDoorLocked(int Id)
        {
            using (StreamWriter sw = File.AppendText(_filepath))
            {
                sw.WriteLine($"Door locked with id:{Id}");
            }
            
        }
        public void LogDoorUnlocked(int Id)
        {
            using (StreamWriter sw = File.AppendText(_filepath))
            {
                sw.WriteLine($"Door unlocked with id:{Id}");
            }
        }
    }
}
