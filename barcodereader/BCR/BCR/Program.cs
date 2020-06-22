using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BCR {
    class Program {
        static void Main(string[] args) {
            Cognex ctrl = new Cognex();
            string address = args[0];
            int t = Convert.ToInt32(args[1]);
            int s = Convert.ToInt32(args[2]);
            String caught = ctrl.get(address,t,s);
            Console.WriteLine(caught);
        }
    }
}
