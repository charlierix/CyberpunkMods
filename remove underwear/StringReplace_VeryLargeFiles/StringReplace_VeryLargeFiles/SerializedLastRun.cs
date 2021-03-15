using System;
using System.Collections.Generic;
using System.Text;

namespace StringReplace_VeryLargeFiles
{
    [Serializable]
    public class SerializedLastRun
    {
        public string InputFile { get; set; }
        public string BackupFolder { get; set; }
        public string Find { get; set; }
        public string Replace { get; set; }
        public string Encoding { get; set; }
    }
}
