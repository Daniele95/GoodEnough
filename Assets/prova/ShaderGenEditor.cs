using UnityEngine;
using System.Collections;
using UnityEditor;

[CustomEditor(typeof(ShaderGen))]
public class ShaderGenEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();

        ShaderGen myScript = (ShaderGen)target;

        if (GUILayout.Button("Generate Shader"))
        {
            myScript.GenerateShader();
        }
    }
}