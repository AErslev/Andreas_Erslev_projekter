using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObserverPatteren
{
    // Interface
    // Interfaces gør det muligt at have mange forskellige Subscribers, der alle følge samme struktur.
    public abstract class Observer
    {
        public virtual string Name() { return "Unknown"; }
        public virtual void AddSubscription(Mail subscription) { }
        public virtual void RemoveSubscription(Mail subscription) { }
        public abstract void Update();
    }
}
