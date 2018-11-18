using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class quad : MonoBehaviour {


    Material m;

    // Use this for initialization
    void Start () {
        m = GetComponent<Renderer>().material;

    }
	
	// Update is called once per frame
	void Update () {

        m.SetFloat("time", Time.time);
    }




}
