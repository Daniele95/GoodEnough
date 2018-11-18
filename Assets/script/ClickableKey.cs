using UnityEngine;
using UnityEngine.Events;
using Utilities;

class ClickableKey : MonoBehaviour
{
    public delegate void EventHandler(object publisher, string s);
    public event EventHandler Event;

    DebugText debugger;

    void Start()
    {
        debugger = Camera.main.GetComponent<DebugText>();
    }



    void Update()
    {
        if (Input.GetMouseButtonDown(0) && onKey())
            Event(this, "down");

        if (Input.GetMouseButtonUp(0) && onKey())
            Event(this, "up");

        // clear debug text with left key
        if (Input.GetMouseButtonDown(1))
            debugger.addOnce("");
    }


    bool onKey()
    {
        bool ret = false;
        Vector3 mousePos = Input.mousePosition; // coordinate di schermo
        mousePos = Camera.main.ScreenToViewportPoint(mousePos); // coordinate di schermo normalizzate

        Vector3 keyPos = Camera.main.WorldToScreenPoint(gameObject.transform.position); // in coordinate schermo
        keyPos = Camera.main.ScreenToViewportPoint(keyPos); // normalizzate

        if (Mathf.Abs(mousePos.x - keyPos.x) < 0.02f)
            ret = true;
        return ret;
    }

}