using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObserverPatteren
{
    public class Subject
    {
        readonly List<IObserver> _observers = new List<IObserver>();
        public void Attach(IObserver observer)
        {
            _observers.Add(observer);
        }
        public void Unattach(string observerName)
        {
            foreach (var observer in _observers.ToList())
            {
                if (observer.Name() == observerName)
                    _observers.Remove(observer);
            }
        }
        protected void Notify()
        {
            foreach (var observer in _observers)
            {
                observer.Update();
            }
        }
    }
}
