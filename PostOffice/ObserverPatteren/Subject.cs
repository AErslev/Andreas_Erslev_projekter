using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObserverPatteren
{
    // Abstrakt klasse 
    // Fordelen ved den abstrakte klasse her, er hvis der er flere klasser som posthus,
    // skal der ikke implimenteres den samme kode flere gange.
    public abstract class Subject
    {
        // Laver en liste af alle de forskellige brugere (En forsimplet "database" af brugere)
        // Der bruges IObserver, da der i teorien kunne være mange forskelige observers (Som f.eks. Subscriber)
        readonly List<Observer> _observers = new List<Observer>();
        // Tilføjer brugere til liste, som gør det muligt at opdatere alle de brugere der er tilknyttet
        public void Attach(Observer observer)
        {
            _observers.Add(observer);
        }
        // Fjerner en bruger fra listen - bruger findes nu ikke længere i posthusets database
        public void Unattach(string observerName)
        {
            foreach (var observer in _observers.ToList())
            {
                if (observer.Name() == observerName)
                    _observers.Remove(observer);
            }
        }
        // Bruges til at kalde Update på alle IObservers tilknyttet
        // I dette program aktiveres da Update funktionen for IObserver. Her er listen tilegnet Subscribers, og der vil derfor kaldes funktionen ReadMail()
        protected void Notify()
        {
            foreach (var observer in _observers)
            {
                observer.Update();
            }
        }
    }
}
