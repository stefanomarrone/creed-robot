using System;
using Cognex.DataMan.SDK;
using System.Net;

namespace BCR {
	class Cognex {
		public String get(String ipname, int trials, int pause) {
            String retval = "***";
            System.Net.IPAddress ipaddress = System.Net.IPAddress.Parse(ipname);
            EthSystemConnector conn = new EthSystemConnector(ipaddress);
            conn.UserName = "admin";
            DataManSystem dataman = new DataManSystem(conn);
            int counter = 0;
            Boolean found = false;
            while ((found == false) && (counter < trials)) {
                try {
                    dataman.Connect();
                    DmccResponse response = dataman.SendCommand("GET RESULT");
                    retval = response.PayLoad;
                    found = true;
                }
                catch (Exception) {
                    System.Threading.Thread.Sleep(pause * 1000);
                }
                finally {
                    dataman.Disconnect();
                    counter++;
                }
            }
            return retval;
        }
	}
}
