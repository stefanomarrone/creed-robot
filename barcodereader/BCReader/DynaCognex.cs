using System;
using System.Dynamic;

namespace BCReader
{
    public class DynaCognex: DynamicObject {
        Cognex device;

        public DynaCognex() {
            this.device = new Cognex();
        }

        public override bool TryGetMember(GetMemberBinder binder, out object result) {
            result = null;
            switch (binder.Name) {
                case "get":
                    result = (Func<string, int, int, string>)((string a, int t, int s) => device.get(a,t,s));
                    return true;
            }
            return false;
        }
    }
}
