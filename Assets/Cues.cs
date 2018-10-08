using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cues : MonoBehaviour {

    public GameObject cue;
    public Renderer rend;
    public GameObject hitLine;

    private float debug;
    private float s; //startPos

    void Start()
    {
        rend = cue.GetComponent<Renderer>();
        Shader shader = Shader.Find("Cues/QuadBody");
        rend.material.shader = shader;

        s = GetTailPos(cue);
    }

    void Update()
    {
        float speed = 1.0f;

        float p = s - Time.time * speed; //position at time t
        SetTailPos(cue, p);
        float e = GetTopPos(hitLine); //hitline


        float frostTime = 1.0f - (p - e) / (s - e);
        float riseTime = Mathf.Max(0.0f, frostTime - 1.0f)*4.0f;
        frostTime = Mathf.Min(frostTime, 1.0f);
        riseTime = Mathf.Min(riseTime, 1.0f);

        rend.material.SetFloat("_FrostLeadingInTime", Mathf.Min(frostTime, 1.0f));
        rend.material.SetFloat("_FrostRiseTime", riseTime);


        float invisibleBelow = (GetTopPos(hitLine) - GetTailPos(cue)) / cue.transform.localScale.y;

        rend.material.SetFloat("_InvisibleBelow", invisibleBelow);
    }


    void Debug(float f)
    {
        debug = f;
    }

    void OnGUI()
    {
        GUILayout.Label(debug.ToString());
    }

    float GetTailPos(GameObject g)
    {
        return g.transform.position.y - g.transform.localScale.y / 2.0f;
    }
    void SetTailPos(GameObject g, float newP)
    {
        Vector3 newPos = new Vector3(0.0f, newP + g.transform.localScale.y/2.0f, 0.0f);
        cue.transform.position = newPos;
    }
    float GetTopPos(GameObject g)
    {
        return g.transform.position.y + g.transform.localScale.y / 2.0f;
    }

}
