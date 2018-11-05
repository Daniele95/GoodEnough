using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Utilities
{
    class Debug
    {
        String debug = "";
        String timeDependentPart = "";

        public void add(String a)
        {
            debug += a;
        }

        public void addOnce(String a)
        {
            timeDependentPart = a;
        }


        public String GetDebugString()
        {
            return debug + timeDependentPart;
        }
    }
}
