using System.IO;
using System;
using System.Collections.Generic;
using UnityEngine;

namespace shaderGen
{

    [ExecuteInEditMode]
    public class ShaderGen : MonoBehaviour
    {

        // GIVE A FOLDER OF SHADERS
        // AND A FOLDER OF INCLUDES
        // WHERE THE FIRST LINES OF THE INCLUDES GO LIKE
        // 'fixed _FrostWidth; // 0 1 1' (i.e. contain properties)

        // THIS SCRIPT IS THEN GONNA CREATE SHADERS
        // WITH THE RIGHT MATERIAL PROPERTIES
        // BASED ON THOSE INCLUDES


        public string shaderHome;
        public string includesHome;

        string shader;

        void Update()
        {
            GenerateShaders();
        }

        public void GenerateShaders()
        {
            shaderHome = @"C:/Users/daniele/Documents/Unity Projects/GoodEnough/Assets/prova/shaders/";
            includesHome = @"C:/Users/daniele/Documents/Unity Projects/GoodEnough/Assets/prova/shaders/ingredients/";

            foreach (string shaderName in getShaders(shaderHome)) { 

                compileShaderWithIncludes(stringOps.removeExtension(shaderName));
                Debug.Log("generato lo shader per " + shaderName);
            }

        }

        List<string> getShaders(string dir)
        {
            string[] files = Directory.GetFiles(dir , "*.shader");
            List<string> ret = new List<string>();
            foreach (string file in files) { 
                if (! file.Contains("Generated"))
                {
                    ret.Add(Path.GetFileName(file));
                }
            }
            return ret;
        }

        void compileShaderWithIncludes(string shaderShortName)
        {
            // write shader with properties block based on includes
            shader = "";
            string shaderName = "Unlit/" + shaderShortName + "Generated";
            shader += "Shader \"" + shaderName + "\"\n{\n    Properties\n    {"; breakLine(2);

            // cycle on includes
            List<string> includes = findIncludesInShader(shaderHome + shaderShortName + ".shader");
            foreach (string include in includes)
            {
                addMaterialPropertiesBlock(include);
            }
            addShaderFromFile(shaderHome + shaderShortName + ".shader");

            System.IO.File.WriteAllText(shaderHome + shaderShortName + "Generated.shader", shader);

        }



        List<string> findIncludesInShader(string shader)
        {
            string line;
            List<string> ret = new List<string>();
            StreamReader read = File.OpenText(shader);
            while (!read.EndOfStream)
            {
                if ((line = read.ReadLine()).Contains("#include"))
                {
                    if (!line.Contains("UnityCG.cginc") && !line.Contains("vertexShader.cginc"))
                    {
                        string[] words = line.Split('/');
                        string include = words[words.Length - 1];
                        include = stringOps.cutLastChar(include, 7);// cut off '.cginc'
                        ret.Add(include);
                    }
                }
            }
            read.Close();
            return ret;
        }

        void addMaterialPropertiesBlock(string includedLibraryName)
        {
            // includedLibraryName = resonance, quadFrost,..

            shader += "        [Header(" + includedLibraryName + ")]"; breakLine(2);

            // supposes that block properties starts with '// props' and ends with '""' lines
            // supposes that lines are like 'float4 WaveCenter; // 1 1 1 1'
            //  where '1 1 1 1' are values (float4) or range+value (float)

            List<string> shaderProperties = readProperties(includesHome + includedLibraryName + ".cginc");
            foreach (string line in shaderProperties)
            {
                // for instance
                // float4 WaveCenter; // 1 1 1 1

                if (line.Split(' ').Length.Equals(2))
                    Debug.LogError("Don't forget to set initial values for properties in cginc," +
                        " like 'fixed _FrostWidth; // 0 1 1'");

                string type = stringOps.getNthWordOfString(line, 0); // float4
                string name = stringOps.getNthWordOfString(line, 1); // WaveCenter;
                name = name.Remove(name.Length - 1); // WaveCenter


                if (line.Split(' ').Length.Equals(4))
                    addToggleProperty(line, name);
                else if (type.Equals("float4") || type.Equals("half4") || type.Equals("fixed4"))
                    addVectorProperty(line, name);
                else if (type.Equals("float") || type.Equals("half") || type.Equals("fixed"))
                    addRangeProperty(line, name);
                else if (type.Equals("float3") || type.Equals("half3") || type.Equals("fixed3"))
                    addColorProperty(line, name);

                breakLine(1);
            }
            breakLine(1);

        }


        void addShaderFromFile(string file)
        {
            StreamReader sr = new StreamReader(file);
            string prova = sr.ReadToEnd();
            shader += stringOps.deleteFirstLine(prova, 5);
            sr.Close();
        }

        List<string> readProperties(string shaderSource)
        {
            List<string> ret = new List<string>();
            string line = "";
            using (StreamReader sr = new StreamReader(shaderSource))
            {
                while (!(line = sr.ReadLine()).Equals(""))
                    ret.Add(line);
                sr.Close();
            }
            return ret;
        }


        void addColorProperty(string line, string name)
        {
            string[] values;
            values = stringOps.getLastWordsOfString(line, 3);
            // _BaseColor("Base color", Color) = (1, 1, 1)
            shader += "        " + name + "(\"" + name + "\", Color ) = (" + values[0]+", "+values[1]+", "+values[2]+")";
        }

        void addToggleProperty(string line, string name)
        {
            string[] values;
            values = stringOps.getLastWordsOfString(line, 1);
            // [Toggle] _ShowResonance( "Show resonance", Float ) = 1
            shader += "        [Toggle] " + name + "(\"" + name + "\", Float ) = " + values[0];
        }

        void addRangeProperty(string line, string name)
        {
            // _ResonanceWaveFront("Wave front", Range(0, 1)) = 1
            
                string[] values;
                values = stringOps.getLastWordsOfString(line, 3);
                string range = "Range(" + values[0] + ", " + values[1] + ")";
                shader += "        " + name + "(\"" + name + "\", " + range + ") = " + values[2];
         
        }

        void addVectorProperty(string line, string name)
        {
            //  _BaseColor("Base color", Color) = (1, 1, 1)
            string[] values;
            values = stringOps.getLastWordsOfString(line, 4);
            string formattedValues = values[0];
            for (int k = 1; k < values.Length; k++)
                formattedValues += ", " + values[k];
            shader += "        " + name + "(\"" + name + "\", " + "Vector" + ") =" +
                " (" + formattedValues + ")";
        }


        void breakLine(int n)
        {
            for (int i = 0; i < n; i++)
                shader += Environment.NewLine;
        }


    }

}