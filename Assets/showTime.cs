using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace Utilities
{
    public class showTime
    {

        GameObject timeQuad;

        public void ShowTime()
        {
            
        }

        public void getObject()
        {
            timeQuad = GameObject.Find("timeQuadParent");
        }
        public void set(float time, float speed)
        {
            timeQuad.transform.localScale.Set(0, time*speed, 0);
        }
        
        public String get()
        {
            return timeQuad.ToString();
        }
      
    }
}