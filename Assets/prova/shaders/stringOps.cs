using System.Collections.Generic;
using System.Linq;

namespace shaderGen
{
    class stringOps
    {

        public static string removeExtension(string fileName)
        {
            return fileName.Split('.')[0];
        }

        public static string cutLastChar(string a, int n)
        {
            string ret = "";
            if (a.Length > n) ret = a.Substring(0, a.Length - n);
            else ret = a;
            return ret;
        }

        public static string breakLines(string a)
        {
            return a.Replace("/n", System.Environment.NewLine);
        }

        public static string toString(List<string> lista)
        {
            string sumOfResults = "";
            foreach (string result in lista)
            {
                sumOfResults += result + "\n";
            }
            return breakLines(sumOfResults);
        }

        public static string[] getLastWordsOfString(string input, int numWords)
        {
            // ex. input= "float4 WaveCenter; // 1 1 1 1"
            // output = { 1, 1, 1, 1 }
            string[] parts = input.Split(' ');
            var values = parts.Skip(parts.Length - numWords).Take(parts.Length - 1).ToArray();
            return values;
        }

        public static string getNthWordOfString(string input, int n)
        {
            return input.Split(' ')[n];
        }

        public static string deleteFirstLine(string input, int n)
        {
            for (int i = 0; i < n; i++)
            {
                int index = input.IndexOf(System.Environment.NewLine);
                input = input.Substring(index + System.Environment.NewLine.Length);
            }
            return input;
        }

        public static string[] delFirstWord(string word)
        {
            string ret = "";
            if (word.Length > 0)
            {
                int i = word.IndexOf(" ") + 1;
                ret = word.Substring(i);
            }
            return ret.Split(' ');
        }

    }
}
