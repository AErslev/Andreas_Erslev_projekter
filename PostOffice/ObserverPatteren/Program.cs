using System;
using System.Threading;

namespace ObserverPatteren
{
    // Oprettelse af enum til identifisering af Mail
    public enum Mail
    {
        NoMail,
        Magazine,
        PostCard,
        Ad,
    }

    class Program
    {
        // Bruges til at bestemme typen af mail
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
            // Oprettelse af posthus med init data
            Console.WriteLine("Post Office is open!");

            PostOffice postOffice = new PostOffice();
            Observer Allan = new Subscriber("Allan", Mail.Magazine);
            postOffice.Attach(Allan);

            Observer Karsten = new Subscriber("Karsten", Mail.Ad);
            Karsten.AddSubscription(Mail.Magazine);
            Karsten.AddSubscription(Mail.PostCard);
            postOffice.Attach(Karsten);

            string exit = "false";
            string done = "false";

            string name;
            string MailId;
            Mail mailSubscription;

            do
            {
                // Sættes til "false" så der kan tilføjes flere subscibers - skifter hvis done == "0"
                done = "false";

                // Opretter brugernavn
                Console.WriteLine("Enter your name:");
                name = Console.ReadLine();

                // Opretter subscriber med nyt brugernavn - tildeler ikke noget start mail
                Subscriber newSubscriber = new Subscriber(name, Mail.NoMail);

                for (; done != "0";)
                {
                    // Giver mulighed for bestemmelse af hvilken mail er ønsket
                    Console.WriteLine("Enter what type of mail you want:");

                    Console.WriteLine("1: Magazine");
                    Console.WriteLine("2: PostCard");
                    Console.WriteLine("3: Ad");

                    MailId = Console.ReadLine();

                    // Tilføjer type af mail til bruger
                    mailSubscription = SetMailType(MailId);
                    
                    // Tilføjer nyt Subscription af mail til bruger
                    newSubscriber.AddSubscription(mailSubscription);

                    // Giver mulighed for at tilknyttet en bruger flere typer af mails
                    Console.WriteLine("Do you want to add more subscriptions");
                    Console.Write("Press 0 if you are done | Press 1 if you want to add more subscriptions: ");

                    // Hvis done skiftes til "0" vil for-løkken stoppe og der vil ikke kunne tilføjes flere typer af mails til den givende bruger
                    done = Console.ReadLine(); 

                }
                
                // Der tilføjes den nye bruger til listen, der er istand til at lave en Notify
                postOffice.Attach(newSubscriber);

                // Giver mulighed for at tilføje flere nye brugere
                Console.WriteLine("Do you want to add more subscriptibers?");
                Console.Write("Press 0 if you are done | Press 1 if you want to add more subscriptibers: ");
                
                // Hvis exit != 1 vil while-løkken stoppe og der kan ikke tilføjes flere brugere
                exit = Console.ReadLine();

            } while (exit == "1");

            // Indikere at mails er ved at blive sendt ud + loading simulator
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

            // Sender en besked ud til alle bruger - symbolisere at mails er nået frem
            postOffice.Play();

            // Sletter "Allan" fra listen over brugere
            postOffice.Unattach("Allan");

            // Fjerner en type mail fra Karstens subscriptions
            Karsten.RemoveSubscription(Mail.Ad);

            // Indikere at mails er ved at blive sendt ud + loading simulator
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

            // Sender en besked ud til alle bruger - symbolisere at mails er nået frem
            postOffice.Play();

        }
    }
}
