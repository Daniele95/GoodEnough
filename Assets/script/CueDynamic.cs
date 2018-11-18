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
    public abstract class CueDynamic : MonoBehaviour
    {
        public DebugText debugger;
        float cueStartPos;

        public float t0; // cue starts going down
        public float t1; // cue touches hitLine
        public float t2; // frost reaches top
        public float t3; // cue disappears completely into hitLine

        public bool pressedGoodEnough = false;
        public bool pressedBest = false;

        public bool releasedGoodEnough = true; //( we give players the benefit of doubt)
        public bool releasedBest = true;

        public string keyTag;

        public void Start()
        {
            // EventManager
            ClickableKey PianoKey = GameObject.FindGameObjectsWithTag(keyTag)[0].GetComponent<ClickableKey>();
            PianoKey.Event += onKeyClicked;

            debugger = Camera.main.GetComponent<DebugText>();

            // we already know those times, as the successive positions of cue tail
            cueStartPos = gameObject.transform.position.y;
            float hitLinePos = GameObject.FindGameObjectsWithTag("hitLine")[0].transform.position.y;
            float cueHeight = transform.localScale.y;

            t0 = 0;
            t1 = Mathf.Abs(hitLinePos - cueStartPos);
            t2 = t1 + cueHeight / 2.0f;
            t3 = t1 + cueHeight;
        }

        void onKeyClicked(object o, string s) {

            float timePast = evolveInTime(); // the effect of this method depends only on time
            // not on how many times you call it

            if(s.Equals("down"))
            {
                float delta = Mathf.Abs(timePast - t1);
                debugger.addOnce(delta.ToString());
                if (delta<0.4)
                {
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

        public void Update()
        {          

        }
        public void myUpdate(string frostTimeName, string riseTimeName)
        {
            float timePast = evolveInTime();

            float time1 = clamp01(timePast / t1);
            float time2 = clamp01((timePast - t1) / (t2 - t1));

            setProperty(frostTimeName, time1);
            if (pressedGoodEnough)
            {
                setProperty(riseTimeName, time2 * 1.3f);
                setProperty("_ShowResonance", 1.0f);
            }

            if (!releasedGoodEnough)
                pressedGoodEnough = false;

        }

        public void setProperty(string variable, float value)
        {
            Material m = GetComponent<Renderer>().material;
            m.SetFloat(variable, value);
        }

        public float clamp01(float a)
        {
            return Mathf.Clamp(a, 0.0f, 1.0f);
        }

        public float evolveInTime()
        {
            float t = Time.time;
            float speed = 1.0f;
            float p = cueStartPos - t * speed; //position at time t
            SetTailPos(p);
            return Mathf.Abs(cueStartPos-p);
        }


        void SetTailPos( float newP)
        {
            transform.position = new Vector3(transform.position.x, newP, 0.0f); ;
        }

    }
}
