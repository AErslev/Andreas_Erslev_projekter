using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObserverPatteren
{
    public class Subscriber : Observer
    {
        // Oprettelse af posthus init data
        private readonly PostOffice _postOffice = new PostOffice();
        private readonly string _name;
        private readonly List<Mail> _subscriptions;
        // Oprettelse af posthus init data -Construtor
        public Subscriber(string name, Mail subscription)
        {
            _subscriptions = new List<Mail>();

            _name = name;
            _subscriptions.Add(subscription);
        }
        public override string Name()
        {
            return _name;
        }
        // Giver mulighed for at tilføje ny mail subscribion til bruger
        public override void AddSubscription(Mail subscription)
        {
            _subscriptions.Add(subscription);
        }
        // Giver mulighed for at fjerne en subscription til bruger
        public override void RemoveSubscription(Mail subscription)
        {
            foreach (var mailType in _subscriptions.ToList())
            {
                _subscriptions.Remove(subscription);
            }
        }
        // Laver en Update, som gør at brugere modtager mail - kaldes fra IObserver der bliver aktiveret fra Subject
        public override void Update()
        {
            ReadMail();
        }
        // Udskriver alt information omkring modtaget mail for diverse brugere
        private void ReadMail()
        {

            foreach (var mailType in _subscriptions)
            {

                if (mailType != Mail.NoMail)
                {
                    switch (mailType)
                    {
                        case Mail.Magazine:
                            Console.WriteLine("{0}, You received mail: A Magazine", _name);
                            break;
                        case Mail.PostCard:
                            Console.WriteLine("{0}, You received mail: A PostCard", _name);
                            break;
                        case Mail.Ad:
                            Console.WriteLine("{0}, You received mail: An Ad", _name);
                            break;
                        default:
                            Console.WriteLine("{0}, You did not receive any mail today!", _name);
                            break;
                    }
                }
            }
        }
    }
}
