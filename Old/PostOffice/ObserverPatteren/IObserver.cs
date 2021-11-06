using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObserverPatteren
{
    public interface IObserver
    {
        public void Update();
        public string Name();
    }
}
