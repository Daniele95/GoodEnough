using UnityEngine;
using System.Collections;
using UnityEditor;

// ASSIGN THIS EDITOR SCRIPT TO AN OBJECT
// then you have a clickable button in that object's menu


namespace shaderGen
{

    [CustomEditor(typeof(ShaderGen))]
    public class ShaderGenEditor : Editor
    {
        public override void OnInspectorGUI()
        {
            DrawDefaultInspector();

            ShaderGen myScript = (ShaderGen)target;

            if (GUILayout.Button("Generate Shader"))
            {
                myScript.GenerateShaders();
            }
        }
    }
}