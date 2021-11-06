using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ObserverPatteren 
{
    public class PostOffice : Subject
    {
        // Kalder blot Notify funktionen, Da Subject er en abstrakt klasse,
        // som betyder den ikke kan eksistere alene, og derfor ikke kan kalde den selv.
        // Det er mulig at lave Subjet til et interface, og der ville derfor være mere kode heri.
        public void Play()
        {
            Notify();
        }
    }
}