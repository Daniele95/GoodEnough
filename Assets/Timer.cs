using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Utilities
{
    class Timer
    {

        private float startTime = 0.0f;
        private float time = 0.0f;

        public Timer()
        {
        }

        public float getTime()
        {
            if (startTime == 0.0f) { 
                startTime = Time.time;
                time = startTime;
            }
            else time = Time.time - startTime;

            return time;
        }

    }
}
