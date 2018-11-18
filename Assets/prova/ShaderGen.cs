using UnityEngine;
using System.Collections;
using System.IO;
using System.Linq;
using System;
using System.Collections.Generic;

public class ShaderGen : MonoBehaviour
{
    public Vector3 spawnPoint;
    public float property;

    public string shaderHome = "Assets/prova/";

    string shader = "";

    public void GenerateShader()
    {
        shader = "";
        // write shader with properties block based on includes
        string shaderName = "Unlit/quadGenerated";
        shader += "Shader \"" + shaderName + "\"\n{\n    Properties\n    {"; breakLine(2);
        
        addMaterialPropertiesBlock("resonance");
        addMaterialPropertiesBlock("quadFrost");


        addShaderFromFile(shaderHome+"quad.shader");

        System.IO.File.WriteAllText(shaderHome+"quadGenerated.shader", shader);

    }

    void addMaterialPropertiesBlock(string includedLibraryName)
    {
        // includedLibraryName = resonance, quadFrost,..

        shader += "    [Header("+ includedLibraryName + ")]"; breakLine(2);

        // supposes that block properties starts with '// props' and ends with '""' lines
        // supposes that lines are like 'float4 WaveCenter; // 1 1 1 1'
        //  where '1 1 1 1' are values (float4) or range+value (float)

        List<string> shaderProperties = readProperties(shaderHome+"ingredients/" + includedLibraryName + ".cginc");
        foreach (string line in shaderProperties)
        {
            // for instance
            // float4 WaveCenter; // 1 1 1 1
            string type = getNthWordOfString(line, 0); // float4
            string name = getNthWordOfString(line, 1); // WaveCenter;
            name = name.Remove(name.Length - 1); // WaveCenter

            if (type.Equals("float4") || type.Equals("half4") || type.Equals("fixed4"))
            {
                addVectorProperty(line, name);
            }
            if (type.Equals("float") || type.Equals("half") || type.Equals("fixed"))
            {
                addRangeProperty(line, name);
            }
            breakLine(1);
        }
        breakLine(1);

    }


    void addShaderFromFile(string file)
    {        
        StreamReader sr = new StreamReader(file);
        string prova = sr.ReadToEnd();
        shader += deleteFirstLine(prova, 4);
        Debug.Log(shader);

        sr.Close();
    }

    List<string> readProperties(string shaderSource)
    {
        List<string> ret = new List<string>();
        string line = "";
        using (StreamReader sr = new StreamReader(shaderSource))
        {
            if (!(line = sr.ReadLine()).Equals("// props"))
                sr.Close();
            else
            {
                while (!(line = sr.ReadLine()).Equals("//"))
                    ret.Add(line);
                sr.Close();
            }
        }
        return ret;
    }

    void addRangeProperty(string line,string name)
    {
        // _ResonanceWaveFront("Wave front", Range(0, 1)) = 1
        string[] values;
        values = getLastWordsOfString(line, 3);
        string range = "Range(" + values[0] + ", " + values[1] + ")";
        shader += "    " + name + "(\"" + name + "\", " + range + ") = " + values[2];
    }

    void addVectorProperty(string line,string name)
    {
        //  _BaseColor("Base color", Color) = (1, 1, 1)
        string[] values;
        values = getLastWordsOfString(line, 4);
        string formattedValues = values[0];
        for (int k = 1; k < values.Length; k++)
            formattedValues += ", " + values[k];
        shader += "    " + name + "(\"" + name + "\", " + "Vector" + ") =" +
            " (" + formattedValues + ")";
    }

    void breakLine(int n)
    {
        for (int i = 0; i < n; i++)
            shader += Environment.NewLine;
    }

    string[] getLastWordsOfString(string input, int numWords)
    {
        // ex. input= "float4 WaveCenter; // 1 1 1 1"
        // output = { 1, 1, 1, 1 }
        string[] parts = input.Split(' ');
        var values = parts.Skip(parts.Length - numWords).Take(parts.Length - 1).ToArray();
        return values;
    }

    string getNthWordOfString(string input, int n)
    {
        return input.Split(' ')[n];
    }

    string deleteFirstLine(string input, int n)
    {
        for (int i=0; i<n; i++) { 
            int index = input.IndexOf(System.Environment.NewLine);
            input = input.Substring(index + System.Environment.NewLine.Length);
        }
        return input;
    }

}