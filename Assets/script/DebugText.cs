using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Utilities { 

    public class DebugText : MonoBehaviour
    {
        String debug = "";
        String timeDependentPart = "";


        void OnGUI()
        {
            GUILayout.Label(GetDebugString());
        }

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