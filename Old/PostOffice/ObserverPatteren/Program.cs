using System;
using System.Threading;

namespace ObserverPatteren
{
    class Program
    {

        public static Mail SetMailType(string type)
        {
            return type switch
            {
                "1" => Mail.Magazine,
                "2" => Mail.PostCard,
                "3" => Mail.Ad,
                _ => Mail.NoMail
            };
        }

        static void Main(string[] args)
        {
            Console.WriteLine("Post Office is open!");

            PostOffice postOffice = new PostOffice();
            Subscriber Allan = new Subscriber("Allan", Mail.Magazine);

            string exit = "false";
            string done = "false";

            string name;
            string MailId;
            Mail mailSubscription;
            

            do
            {

                done = "false";

                Console.WriteLine("Enter your name:");
                name = Console.ReadLine();

                Subscriber newSubscriber = new Subscriber(name, Mail.NoMail);

                for (; done != "0";)
                {
                    Console.WriteLine("Enter what type of mail you want:");

                    Console.WriteLine("1: Magazine");
                    Console.WriteLine("2: PostCard");
                    Console.WriteLine("3: Ad");

                    MailId = Console.ReadLine();

                    mailSubscription = SetMailType(MailId);
                    
                    newSubscriber.AddSubscription(mailSubscription);

                    Console.WriteLine("Do you want to add more subscriptions");
                    Console.WriteLine("Press 0 if you are done | Press 1 if you want to add more subscriptions");

                    done = Console.ReadLine();

                }
                
                postOffice.Attach(newSubscriber);

                Console.WriteLine("Do you want to add more subscriptibers?");
                Console.WriteLine("Press 0 if you are done | Press 1 if you want to add more subscriptibers");
                
                exit = Console.ReadLine();

            } while (exit == "1");

            Console.WriteLine("Mail is being delivered!");

            for (int i = 0; i < 3; i++)
            {
                Console.Write(". ");
                Thread.Sleep(500);
                Console.Write(". ");
                Thread.Sleep(500);
                Console.WriteLine(". ");
                Thread.Sleep(500);
            }

            postOffice.Play();

        }
    }
}
