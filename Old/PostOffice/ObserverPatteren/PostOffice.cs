using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObserverPatteren 
{

    public enum Mail
    {
        NoMail,
        Magazine,
        PostCard,
        Ad,
    }

    public class PostOffice : Subject
    {

        public void Play()
        {
            Notify();
        }
    }
}
