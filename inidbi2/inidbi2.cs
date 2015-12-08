﻿using System;
using System.IO;
using System.Text;
using System.Runtime.InteropServices;
using RGiesecke.DllExport;
using System.Reflection;

namespace inidbi2
{
    public class inidbi2
    {
        [DllExport("_RVExtension@12", CallingConvention = CallingConvention.Winapi)]
        public static void RVExtension(StringBuilder output, int outputSize, [MarshalAs(UnmanagedType.LPStr)] string function)
        {
            if (_instance == null)
                _instance = new inidbi2();

            string ret = _instance.Invoke(function);
            output.Append(ret);
            return;
        }

        static inidbi2 _instance;

        [DllImport("kernel32")]
        private static extern int WritePrivateProfileString(string section, string key, string val, string filePath);
        [DllImport("kernel32")]
        private static extern int GetPrivateProfileString(string section, string key, string def, StringBuilder retVal, int size, string filePath);
        [DllImport("kernel32")]
        private static extern int GetPrivateProfileStruct(string section, string key, string struc, int size, string filepath);
        [DllImport("kernel32")]
        private static extern int WritePrivateProfileStruct(string section, string key, string struc, int size, string filepath);

        public string Invoke(string parameters) {
            string[] stringSeparators = new string[] { ";" };
            var lines = parameters.Split(stringSeparators, StringSplitOptions.None);
            
            string function = lines[0];
            string result = "";

            string mypath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + "\\db\\";

            switch (function)
            {
                case "version":
                    result = this.Version();
                    break;
                case "write":
                    result = this.Write(mypath + lines[1], lines[2], lines[3], lines[4]);
                    break;
                case "read":
                    result = this.Read(mypath + lines[1], lines[2], lines[3]);
                    break;
                case "deletesection":
                    result = this.DeleteSection(mypath + lines[1], lines[2]);
                    break;
                case "deletekey":
                    result = this.DeleteKey(mypath + lines[1], lines[2], lines[3]);
                    break;
                case "delete":
                    result = this.Delete(mypath + lines[1]);
                    break;
                case "exists":
                    result = this.Exists(mypath + lines[1]);
                    break;
                case "timestamp":
                    result = this.TimeStamp();
                    break;
                case "decodebase64":
                    result = this.DecodeBase64(lines[1]);
                    break;
                case "encodebase64":
                    result = this.EncodeBase64(lines[1]);
                    break;
                default:
                    break;
            }
            return result;
        }

        public string Version()
        {
            string version = "2.01";
            return version;
        }

        public string Delete(string File)
        {
            string result = "true";
            try
            {
                System.IO.File.Delete(File);
            }
            catch (Exception e)
            {
                result = "false";
            }
            return result;
        }

        public string Exists(string File)
        {
            return (System.IO.File.Exists(File)).ToString();
        }

        public string Write(string File, string Section, string Key, string Value)
        {
            if(WritePrivateProfileString(Section, Key, Value, File) == 0) {return "false";}else{return "true";}
        }
        
        public string Read(string File, string Section, string Key)
        {
            StringBuilder temp = new StringBuilder(10230);
            if(GetPrivateProfileString(Section, Key, "", temp, 10230, File) == 0) { return "[false, \"\"]"; } else { return "[true," + temp.ToString() + "]"; }
        }

        public string DeleteSection(string File, string Section)
        {
            if(WritePrivateProfileStruct(Section, null, null, 0, File) == 0) { return "false"; } else { return "true";}
        }


        public string DeleteKey(string File, string Section, string key)
        {
            if(WritePrivateProfileStruct(Section, key, null, 0, File) == 0) { return "false"; } else { return "true"; }
        }

        public string TimeStamp()
        {
            return ((int)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds).ToString();
        }

        public string EncodeBase64(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }

        public string DecodeBase64(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }
    }
}

