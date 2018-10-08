using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Cues : MonoBehaviour {

    GameObject plane;

    // Use this for initialization

    public Renderer rend;
    void Start () {
        
        plane = GameObject.CreatePrimitive(PrimitiveType.Quad);
        
        rend = plane.GetComponent<Renderer>();
        Shader shader = Shader.Find("Cues/QuadBody");
        rend.material.shader = shader;
        rend.material.SetFloat("_InvisibleBelow", 0.0f);
        rend.material.SetColor("_BaseColor",new Color(1.0f, 0.0f, 0.0f) );
        rend.material.SetColor("_ResonanceColor", new Color(0.0f, 1.0f, 0.0f));
        rend.material.SetColor("_FrostColor", new Color(0.0f, 0.0f, 1.0f));

        // per sicurezza tutti i param del frost
        rend.material.SetFloat("_FrostTailCap", 0.06f);
        rend.material.SetFloat("_FrostTailSlope", 1.15f);
        rend.material.SetFloat("_FrostTailSmoothness", 0.59f);
        rend.material.SetFloat("_FrostStartTime", 1.0f);
        rend.material.SetFloat("_FrostT1", 0.25f);
        rend.material.SetFloat("_FrostT2", 0.26f);
        rend.material.SetFloat("_FrostT3", 0.68f);
        rend.material.SetFloat("_FrostTailHeight", 0.14f);
        rend.material.SetFloat("_FrostTailHeightOffset", 0.31f);
        rend.material.SetFloat("_FrostTailFalloff", 1.7f);



    }   
	
	// Update is called once per frame
	void Update ()
    {
        float distance = 6.0f - Time.time * 3.0f;        
        plane.transform.position = new Vector3(0.0f, 3.0f, 0.0f);

        float shaderTime = -(distance - 6.0f) / 6.0f;
        rend.material.SetFloat("_FrostLeadingInTime", Time.time / 5.0f);
        rend.material.SetFloat("_FrostRiseTime", Time.time / 5.0f-1.0f);
    }
    void OnGUI ()
    {
        GUILayout.Label((Time.time / 3.0f).ToString());
    }
}
