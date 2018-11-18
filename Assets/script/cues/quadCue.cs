using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Assets { 
    public class quadCue : CueDynamic {

        // Use this for initialization
        new void Start () {
            keyTag = "quadKey";
            base.Start();
        }
	
	    // Update is called once per frame
	    new void Update ()
        {
            myUpdate("_FrostLeadingInTime", "_FrostRiseTime");

        }
        
}
}
