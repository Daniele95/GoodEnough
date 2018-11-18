using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Assets
{
    

    class Utilities
    {

        public static float GetTopPos(GameObject g)
        {
            return g.transform.position.y + g.transform.localScale.y / 2.0f;

        }

    }
}
