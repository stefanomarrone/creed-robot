using System;

namespace BCReader {
    class Program {
        static void Main(string[] args) {
            Cognex ctrl = new Cognex();
            String caught = ctrl.get("192.168.1.5", 3, 5);
            Console.WriteLine(caught);
        }
    }
}
