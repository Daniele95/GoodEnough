using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;
using Assets;
using Utilities;
using UnityEngine.Events;

namespace Assets
{
    class CueDynamic : MonoBehaviour
    {
        DebugText debugger;
        float cueStartPos;

        float t0; // cue starts going down
        float t1; // cue touches hitLine
        float t2; // frost reaches top
        float t3; // cue disappears completely into hitLine

        bool pressedGoodEnough = false;
        bool pressedBest = false;
        
        bool releasedGoodEnough = true; //( we give players the benefit of doubt)
        bool releasedBest = true;

        void Start()
        {
            // EventManager
            ClickableKey PianoKey = GameObject.FindGameObjectsWithTag("clickableKey")[0].GetComponent<ClickableKey>();
            PianoKey.Event += funzione;

            debugger = Camera.main.GetComponent<DebugText>();

            // we already know those times, as the successive positions of cue tail
            cueStartPos = Utilities.GetTailPos(gameObject);
            float hitLinePos = GameObject.FindGameObjectsWithTag("hitLine")[0].transform.position.y;
            float cueHeight = transform.localScale.y;

            t0 = 0;
            t1 = Mathf.Abs(hitLinePos - cueStartPos);
            t2 = t1 + cueHeight / 2.0f;
            t3 = t1 + cueHeight;
        }

        void funzione(object o, string s) {

            float timePast = evolveInTime(); // the effect of this method depends only on time
            // not on how many times you call it

            if(s.Equals("down"))
            {
                float delta = Mathf.Abs(timePast - t1);
                if (delta<0.4) { 
                    pressedGoodEnough = true;
                    if (delta < 0.2)
                        pressedBest = true;
                }
            }
            if (s.Equals("up"))
            {
                float delta = Mathf.Abs(timePast - t2);
                if (delta > 0.2)
                {
                    releasedBest = false;
                    if (delta > 0.4)
                        releasedGoodEnough = false;
                }
            }

        }

        void Update()
        {
            float timePast = evolveInTime();

            float time1 = clamp01(timePast / t1);
            float time2 = clamp01((timePast - t1) / (t2 - t1));

            setProperty("_FrostLeadingInTime", time1 );
            if(pressedGoodEnough)
            {
                debugger.addOnce(time2.ToString());
                setProperty("_FrostRiseTime",time2 );
                setProperty("_ShowResonance", 1.0f);
            }

            if (!releasedGoodEnough)
                pressedGoodEnough = false;

            // if (timePast>t1) debugger.addOnce("t1!");
            //  if (timePast > t2) debugger.addOnce("t2!");
            //  if (timePast > t3) debugger.addOnce("t3!");

        }

        void setProperty(string variable, float value)
        {
            Material m = GetComponent<Renderer>().material;
            m.SetFloat(variable, value);
        }

        float clamp01(float a)
        {
            return Mathf.Clamp(a, 0.0f, 1.0f);
        }

        float evolveInTime()
        {
            float t = Time.time;
            float speed = 1.0f;
            float p = cueStartPos - t * speed; //position at time t
            SetTailPos(p);
            return Mathf.Abs(cueStartPos-p);
        }


        void SetTailPos( float newP)
        {
            Vector3 newPos = new Vector3(0.0f, newP + transform.localScale.y / 2.0f, 0.0f);
            transform.position = newPos;
        }

    }
}
