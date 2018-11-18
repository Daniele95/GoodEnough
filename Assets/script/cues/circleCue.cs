using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Assets { 
    public class circleCue : CueDynamic {

	    // Use this for initialization
	    void Start ()
        {
            keyTag = "circleKey";
            base.Start();

        }
	
	    // Update is called once per frame
	    void Update ()
        {

            myUpdate("_FrostTime", "_RingTime");
        }


    }
}