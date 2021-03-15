using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;

namespace StringReplace_VeryLargeFiles
{
    public partial class MainWindow : Window
    {
        #region Declaration Section

        private readonly KeyValuePair<string, Encoding>[] _comboEncodings;

        private readonly string _settingsFilename;

        #endregion

        #region Constructor

        public MainWindow()
        {
            InitializeComponent();

            Background = SystemColors.ControlBrush;

            #region combobox

            var encodings = Encoding.GetEncodings().
                Select(o =>
                {
                    var encoding = o.GetEncoding();

                    Match utf = Regex.Match(o.Name, @"utf-(?<digits>\d+)");

                    string displayName = o.DisplayName;
                    if (!o.Name.Equals(displayName, StringComparison.OrdinalIgnoreCase))
                        displayName = $"{o.Name.PadRight(16, ' ')} {displayName}";

                    return new
                    {
                        info = o,
                        encoding,
                        displayName,

                        isSingleByte = encoding.IsSingleByte ? 1 : 0,
                        isBigEndian = o.DisplayName.Contains("endian", StringComparison.OrdinalIgnoreCase) ? 1 : 0,
                        utf = utf.Success ? int.Parse(utf.Groups["digits"].Value) : -1,
                    };
                }).
                OrderByDescending(o => o.isSingleByte).     // single byte encodings should be on top
                ThenBy(o => o.isBigEndian).     // put the big endians at the bottom
                ThenBy(o => o.utf).     // the utf set should be together, and ordered by the number
                ThenBy(o => o.info.DisplayName).        // hopefully ascii always comes on top
                ToArray();

            _comboEncodings = encodings.
                Select(o => new KeyValuePair<string, Encoding>(o.displayName, o.encoding)).
                ToArray();

            foreach (var encoding in _comboEncodings)
            {
                cboEncodings.Items.Add(encoding);       // couldn't get it to bind to an observable.  This is crude, but it works
            }

            cboEncodings.SelectedIndex = 0;

            #endregion

            _settingsFilename = System.IO.Path.Combine(Environment.CurrentDirectory, "last run.json");
        }

        #endregion

        #region Event Listeners

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                LoadSettings();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void File_PreviewDragEnter(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
            {
                e.Effects = DragDropEffects.Copy;
            }
            else
            {
                e.Effects = DragDropEffects.None;
            }

            e.Handled = true;
        }
        private void txtInputFile_Drop(object sender, DragEventArgs e)
        {
            try
            {
                string[] filenames = e.Data.GetData(DataFormats.FileDrop) as string[];

                if (filenames == null || filenames.Length == 0)
                {
                    MessageBox.Show("No files selected", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (filenames.Length > 1)
                {
                    MessageBox.Show("Only one file allowed", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                txtInputFile.Text = filenames[0];

                if (txtBackupFolder.Text.Trim() == "")
                    txtBackupFolder.Text = System.IO.Path.GetDirectoryName(txtInputFile.Text);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }
        private void txtBackupFolder_Drop(object sender, DragEventArgs e)
        {
            try
            {
                string[] filenames = e.Data.GetData(DataFormats.FileDrop) as string[];

                if (filenames == null || filenames.Length == 0)
                {
                    MessageBox.Show("No folders selected", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (filenames.Length > 1)
                {
                    MessageBox.Show("Only one folder allowed", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                txtBackupFolder.Text = filenames[0];
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void txtInputFile_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (!File.Exists(txtInputFile.Text))
                {
                    lblStats.Text = "";
                    return;
                }

                var stats = GetFileStats(txtInputFile.Text);

                lblStats.Text = string.Format("possibly \"{0}\"      {1}",
                    stats.encoding.EncodingName,
                    GetSizeDisplay(stats.size, 3, true));
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void Find_TextChanged(object sender, TextChangedEventArgs e)
        {
            try
            {
                if (txtFind.Text == "" && txtReplace.Text == "")
                {
                    txtResults.Text = "";
                    return;
                }

                StringBuilder report = new StringBuilder();

                report.AppendLine("Each encoding's bytes for both find and replace");
                report.AppendLine();

                foreach (var encoding in _comboEncodings)
                {
                    report.AppendLine($"--- {encoding.Key} ---");
                    report.AppendLine(GetBytesDisplay(encoding.Value, txtFind.Text));
                    report.AppendLine(GetBytesDisplay(encoding.Value, txtReplace.Text));
                    report.AppendLine();
                    report.AppendLine();
                }

                txtResults.Text = report.ToString();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void PreviewFile_Click(object sender, RoutedEventArgs e)
        {
            const int SIZE = 1024 * 64;

            try
            {
                if (txtInputFile.Text == "")
                {
                    MessageBox.Show("Please select a file", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (!File.Exists(txtInputFile.Text))
                {
                    MessageBox.Show("Invalid Filename", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                using (StreamReader reader = new StreamReader(new FileStream(txtInputFile.Text, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)))
                {
                    char[] buffer = new char[SIZE];

                    int count = reader.ReadBlock(buffer, 0, SIZE);

                    string text = new string(buffer, 0, count);

                    txtResults.Text = text;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ShowHelp_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                StringBuilder content = new StringBuilder();

                content.AppendLine("This moves the file to the backup folder (with a datestamp tacked on)");
                content.AppendLine();
                content.AppendLine("Then copies the file one byte at a time from the backup to the original file location/name");
                content.AppendLine();
                content.AppendLine("The encoding is used to convert the search/replace strings into byte arrays");
                content.AppendLine();
                content.AppendLine("If a sequence of bytes in the source file matches the search, that sequence is replaced");
                content.AppendLine("with the bytes for the replace string");
                content.AppendLine();
                content.AppendLine("It doesn't matter if the search and replace are different sizes.  The block of bytes that");
                content.AppendLine("represents replace are simply written instead of the bytes that represents search");
                content.AppendLine();
                content.AppendLine("The encoding has nothing to do with the reading or creation of the files - the file is copied");
                content.AppendLine("byte by byte");
                content.AppendLine();
                content.AppendLine("The default encoding for (.net? / windows?) looks like UTF-8, which is a variable width");
                content.AppendLine("encoding.  1 byte per char for the simple characters, but multiple for the more exotic ones");
                content.AppendLine();
                content.AppendLine("So when in doubt, and you're only dealing with alpha/numeric, just choose ASCII");

                Window window = new Window()
                {
                    Title = "Info",
                    SizeToContent = SizeToContent.WidthAndHeight,
                    WindowStartupLocation = WindowStartupLocation.CenterScreen,
                    Background = Brushes.FloralWhite,

                    Content = new TextBlock()
                    {
                        Text = content.ToString(),
                        Margin = new Thickness(20),
                    },
                };

                window.Show();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private async void ReplaceBytes_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (txtInputFile.Text == "")
                {
                    MessageBox.Show("Please select a file", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (!File.Exists(txtInputFile.Text))
                {
                    MessageBox.Show("Invalid Filename", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (txtBackupFolder.Text == "")
                {
                    MessageBox.Show("Please select a backup folder", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (!Directory.Exists(txtBackupFolder.Text))
                {
                    MessageBox.Show("Invalid Backup Folder", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (txtFind.Text == "")
                {
                    MessageBox.Show("Find text can't be blank", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                SaveSettings();

                panel1.IsEnabled = false;
                panel2.IsEnabled = false;
                progressBar.Visibility = Visibility.Visible;
                Cursor = Cursors.Wait;

                // Encode search/replace as bytes
                var encoding = _comboEncodings[cboEncodings.SelectedIndex].Value;

                byte[] find = encoding.GetBytes(txtFind.Text);
                byte[] replace = encoding.GetBytes(txtReplace.Text);

                txtResults.Text = "Moving to backup...\r\n";

                // Move from original to backup
                string inputFile_Text = txtInputFile.Text;
                string backupFolder_Text = txtBackupFolder.Text;
                var filenames = await Task.Run(() => MoveFile(inputFile_Text, backupFolder_Text));

                txtResults.Text += "Copying/replacing from backup to the original filename...\r\n";

                // Create the new file where the old one used to be
                long count = await Task.Run(() => ReplaceInTextFile_Bytes(filenames.backup, filenames.orig, find, replace, UpdateProgressBar));

                txtResults.Text += $"Replaced {count} occurrence{(count == 1 ? "" : "s")}";
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
            finally
            {
                panel1.IsEnabled = true;
                panel2.IsEnabled = true;
                progressBar.Visibility = Visibility.Collapsed;
                Cursor = Cursors.Arrow;
            }
        }
        private void ReplaceChars_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (txtInputFile.Text == "")
                {
                    MessageBox.Show("Please select a file", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (!File.Exists(txtInputFile.Text))
                {
                    MessageBox.Show("Invalid Filename", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (txtBackupFolder.Text == "")
                {
                    MessageBox.Show("Please select a backup folder", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }
                else if (!Directory.Exists(txtBackupFolder.Text))
                {
                    MessageBox.Show("Invalid Backup Folder", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                if (txtFind.Text == "")
                {
                    MessageBox.Show("Find text can't be blank", Title, MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                string newFilename = System.IO.Path.GetFileName(txtInputFile.Text);
                newFilename += "_" + DateTime.Now.ToString("yyyyMMdd HHmmss");
                newFilename = System.IO.Path.Combine(txtBackupFolder.Text, newFilename);

                txtResults.Text = "Replacing text in new file...\r\n";

                //TODO: Task
                long count = ReplaceInTextFile_Chars(txtInputFile.Text, newFilename, txtFind.Text, txtReplace.Text);

                txtResults.Text += $"Replaced {count} occurrence{(count == 1 ? "" : "s")}";
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void FindDistinctStrings_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                new FindDistinctStrings().Show();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), Title, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        #endregion

        #region Private Methods

        private static (string orig, string backup) MoveFile(string filename, string backupFolder)
        {
            string newFilename = System.IO.Path.GetFileName(filename);
            newFilename += "_" + DateTime.Now.ToString("yyyyMMdd HHmmss");
            newFilename = System.IO.Path.Combine(backupFolder, newFilename);

            File.Move(filename, newFilename, false);

            return (filename, newFilename);
        }

        /// <summary>
        /// This copies the file byte by byte, replacing search with replace (see ShowHelp_Click for details)
        /// </summary>
        private static long ReplaceInTextFile_Bytes(string sourceFilename, string newFilename, byte[] search, byte[] replace, Action<double> updateProgressbar)
        {
            const long REPORT_INTERVAL = 1024 * 1024;

            if (search.Length == 0)
            {
                throw new ArgumentException("'search' cannot be an empty string", "search");
            }

            long retVal = 0;

            bool isEOF = false;

            byte[] writeBuffer = new byte[1];

            using (FileStream source = new FileStream(sourceFilename, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                double numBytes = source.Length;
                long currentByte = 0;

                using (FileStream destination = new FileStream(newFilename, FileMode.CreateNew))
                {
                    byte?[] buffer = new byte?[search.Length];
                    for (int i = 0; i < buffer.Length; i++)
                        buffer[i] = null;

                    while (!isEOF)
                    {
                        if (IsEqual(buffer, search))
                        {
                            // Write the replace bytes into destination
                            retVal++;
                            destination.Write(replace);

                            for (int i = 0; i < buffer.Length; i++)
                                buffer[i] = null;
                        }
                        else
                        {
                            // Write this byte into the destination
                            if (buffer[0] != null)
                            {
                                writeBuffer[0] = buffer[0].Value;       // this function requires a byte array, even though we're only writing a single byte
                                destination.Write(writeBuffer);
                            }

                            // Shift the bytes in the buffer left, filling with the next byte in the source file
                            for (int i = 0; i < buffer.Length; i++)
                            {
                                if (i < buffer.Length - 1)
                                {
                                    buffer[i] = buffer[i + 1];
                                }
                                else
                                {
                                    int nextByte = source.ReadByte();
                                    if (nextByte < 0)
                                    {
                                        buffer[i] = null;       // since everything is shifted left, this position needs to be cleared, or the destination will have the last byte twice
                                        isEOF = true;
                                        break;
                                    }

                                    currentByte++;
                                    buffer[i] = (byte)nextByte;

                                    if (currentByte % REPORT_INTERVAL == 0)
                                        updateProgressbar(currentByte / numBytes);
                                }
                            }
                        }
                    }

                    // Finish the last few bytes
                    if (IsEqual(buffer, search))
                    {
                        retVal++;
                        destination.Write(replace);
                    }
                    else
                    {
                        for (int i = 0; i < buffer.Length; i++)
                        {
                            if (buffer[i] != null)
                            {
                                writeBuffer[0] = buffer[i].Value;
                                destination.Write(writeBuffer);
                            }
                        }
                    }
                }
            }

            return retVal;
        }

        /// <summary>
        /// This brings everything into/out of char, instead of straight byte manipulation
        /// </summary>
        /// <remarks>
        /// NOTE: This failed when parsing the file I originally wrote this tool for -- it went from 8gb to 14gb.  My guess is that
        /// it's a binary file and the bytes were getting interpretted wrong, causing things to get mangled
        /// 
        /// Got this here
        /// https://forums.codeguru.com/showthread.php?474820-Replacing-strings-in-text-files-with-C
        /// </remarks>
        private static long ReplaceInTextFile_Chars(string sourceFilename, string newFilename, string search, string replace)
        {
            if (string.IsNullOrEmpty(search))
            {
                throw new ArgumentException("'search' cannot be null or an empty string", "search");
            }

            long retVal = 0;

            var stats = GetFileStats(sourceFilename);

            bool isEOF = false;

            using (StreamReader sr = new StreamReader(new FileStream(sourceFilename, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)))
            {
                var srIterator = IterateChars(sr).GetEnumerator();

                using (StreamWriter sw = new StreamWriter(newFilename, false, stats.encoding))
                {
                    char[] buffer = new char[search.Length];
                    for (int i = 0; i < buffer.Length; i++)
                    {
                        buffer[i] = (char)0;
                    }

                    //while (sr.Peek() != -1)
                    while (!isEOF)
                    {
                        if (new string(buffer) == search)
                        {
                            retVal++;
                            sw.Write(replace);
                            for (int i = 0; i < buffer.Length; i++)
                            {
                                buffer[i] = (char)0;
                            }
                        }
                        else
                        {
                            if (buffer[0] != (char)0)
                            {
                                sw.Write(buffer[0]);
                            }

                            for (int i = 0; i < buffer.Length; i++)
                            {
                                if (i < buffer.Length - 1)
                                {
                                    buffer[i] = buffer[i + 1];
                                }
                                else
                                {
                                    if (!srIterator.MoveNext())
                                    {
                                        isEOF = true;
                                        break;
                                    }

                                    //This appears to be the flaw.  Need to use a decoder
                                    //https://stackoverflow.com/questions/11671826/how-do-you-read-utf-8-characters-from-an-infinite-byte-stream-c-sharp
                                    buffer[i] = srIterator.Current;
                                }
                            }
                        }
                    }

                    if (new string(buffer) == search)
                    {
                        retVal++;
                        sw.Write(replace);
                    }
                    else
                    {
                        for (int i = 0; i < buffer.Length; i++)
                        {
                            if (buffer[i] != (char)0)
                            {
                                sw.Write(buffer[i]);
                            }
                        }
                    }
                }
            }

            return retVal;
        }

        private static bool IsEqual(byte?[] buffer1, byte[] buffer2)
        {
#if DEBUG
            if (buffer1.Length != buffer2.Length)
                throw new ArgumentException($"Buffers need to be the same size: {buffer1.Length}, {buffer2.Length}");
#endif

            for (int cntr = 0; cntr < buffer1.Length; cntr++)
            {
                if (buffer1[cntr] == null)
                    return false;

                if (buffer1[cntr].Value != buffer2[cntr])
                    return false;
            }

            return true;
        }

        private static string GetBytesDisplay(Encoding encoding, string text)
        {
            return encoding.GetBytes(text).
                Select(o => o.ToString().PadLeft(3, ' ')).
                ToJoin("  ");
        }

        private static (Encoding encoding, long size) GetFileStats(string filename)
        {
            // StreamReader.CurrentEncoding is documented as:
            //    The current character encoding used by the current reader. The value can be different after the first
            //    call to any Read method of StreamReader, since encoding autodetection is not done until the first call
            //    to a Read method.

            using (StreamReader reader = new StreamReader(new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)))
            {
                //reader.Read();

                char[] buffer = new char[1024];

                reader.Read(buffer, 0, buffer.Length);
                reader.Read(buffer, 0, buffer.Length);


                return (reader.CurrentEncoding, reader.BaseStream.Length);
            }
        }

        private static IEnumerable<char> IterateChars(StreamReader reader)
        {
            const int BUFFERSIZE = 1024 * 16;

            char[] buffer = new char[BUFFERSIZE];

            while (true)
            {
                int count = reader.Read(buffer, 0, BUFFERSIZE);
                if (count == 0)
                    yield break;

                for (int i = 0; i < count; i++)
                {
                    yield return buffer[i];
                }
            }
        }

        private static string[] _suffix = { " ", "K", "M", "G", "T", "P", "E", "Z", "Y" };  // longs run out around EB -- yotta is bigger than zetta :)
        private static string GetSizeDisplay(long size, int decimalPlaces = 0, bool includeB = false)
        {
            //http://stackoverflow.com/questions/281640/how-do-i-get-a-human-readable-file-size-in-bytes-abbreviation-using-net

            if (size == 0)
            {
                return "0 " + _suffix[0] + (includeB ? "B" : "");
            }

            long abs = Math.Abs(size);

            int place = Convert.ToInt32(Math.Floor(Math.Log(abs, 1024)));

            string numberText;
            if (decimalPlaces > 0)
            {
                double num = abs / Math.Pow(1024, place);
                numberText = (Math.Sign(size) * num).ToStringSignificantDigits(decimalPlaces);
            }
            else
            {
                double num = Math.Ceiling(abs / Math.Pow(1024, place));        //NOTE: windows uses ceiling, so doing the same (showing decimal places just clutters the view if looking at a list)
                numberText = (Math.Sign(size) * num).ToString("N0");
            }

            return numberText + " " + _suffix[place] + (includeB ? "B" : "");
        }

        private void UpdateProgressBar(double percent)
        {
            Dispatcher.BeginInvoke(new Action(() =>
            {
                progressBar.Value = progressBar.Minimum + ((progressBar.Maximum - progressBar.Minimum) * percent);
            }),
            DispatcherPriority.Background);
        }

        private void SaveSettings()
        {
            var settings = new SerializedLastRun()
            {
                InputFile = txtInputFile.Text,
                BackupFolder = txtBackupFolder.Text,
                Find = txtFind.Text,
                Replace = txtReplace.Text,
                Encoding = _comboEncodings[cboEncodings.SelectedIndex].Key,
            };

            var options = new JsonSerializerOptions()
            {
                WriteIndented = true,
            };

            string serialized = JsonSerializer.Serialize<SerializedLastRun>(settings, options);

            File.WriteAllText(_settingsFilename, serialized);
        }
        private void LoadSettings()
        {
            if (!File.Exists(_settingsFilename))
                return;

            try
            {
                string jsonString = System.IO.File.ReadAllText(_settingsFilename);

                SerializedLastRun settings = JsonSerializer.Deserialize<SerializedLastRun>(jsonString);

                txtInputFile.Text = settings.InputFile;
                txtBackupFolder.Text = settings.BackupFolder;
                txtFind.Text = settings.Find;
                txtReplace.Text = settings.Replace;

                for (int cntr = 0; cntr < _comboEncodings.Length; cntr++)
                {
                    if (_comboEncodings[cntr].Key.Equals(settings.Encoding, StringComparison.OrdinalIgnoreCase))
                    {
                        cboEncodings.SelectedIndex = cntr;
                        break;
                    }
                }
            }
            catch (Exception) { }       // ignore errors, just show the window
        }

        #endregion
    }
}
