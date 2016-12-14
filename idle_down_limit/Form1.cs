using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;

using System.Runtime.InteropServices;

namespace idle_down_limit
{
   
    public partial class Form1 : Form
    {

        bool limitRemoved;
        public Form1()
        {
            InitializeComponent();
        }
        private void checkIfIdle(){
            while (true)
            {
                TimeSpan period = TimeSpan.FromMinutes(int.Parse(timeBox.Text));
                var lastInputInfo = new NativeMethods.LASTINPUTINFO();
                lastInputInfo.cbSize = (uint)Marshal.SizeOf(lastInputInfo);
                NativeMethods.GetLastInputInfo(ref lastInputInfo);

                TimeSpan lastInput = TimeSpan.FromMilliseconds((Environment.TickCount - lastInputInfo.dwTime));

                if (!limitRemoved &&  lastInput >= period)
                    removeLimit();
                else
                    if (limitRemoved)
                        setLimit();
            }
        }
        private void executeCommand (string cmd , bool hideWindow = true){
            System.Diagnostics.Process process = new System.Diagnostics.Process();
            System.Diagnostics.ProcessStartInfo startInfo = new System.Diagnostics.ProcessStartInfo();
            startInfo.Arguments = cmd;
            startInfo.FileName = "cmd.exe";
            process.StartInfo = startInfo;
            if (hideWindow)
                startInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
            process.Start();
         }

        private void setLimit(){
                string projDir = getParentDirectory();
                string utspeed_dir = projDir + "\\utspeed";
                string cmd = "/c cd " + utspeed_dir + " & " + "utspeed.exe /max_dl_rate " + limBox.Text;
                executeCommand(cmd);
                limitRemoved = false;
        }

        private void removeLimit(){
            string projDir = getParentDirectory();
            string utspeed_dir = projDir + "\\utspeed";
            string cmd = "/c cd " + utspeed_dir +
                " & " + "utspeed.exe /max_dl_rate 0";
            executeCommand(cmd);
            limitRemoved = true;
        }
        private Thread startCheckingThread()
        {
            var t = new Thread(() => checkIfIdle());
            t.IsBackground = true;
            t.Start();
            return t;
        }
        private string getParentDirectory()
        {
            string debugDir = System.IO.Directory.GetCurrentDirectory();
            return System.IO.Directory.GetParent(debugDir).Parent.Parent.FullName;
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            limitRemoved = true;
            Thread checkIfIdleThread = startCheckingThread();

            
        }

        private void limBox_TextChanged(object sender, EventArgs e)
        {
            if (!limitRemoved)
                limitRemoved = true;
        }

        private void timeBox_TextChanged(object sender, EventArgs e)
        {
            if (!limitRemoved)
             limitRemoved = true;
        }

        private void notifyIcon1_MouseDoubleClick(object sender, MouseEventArgs e)
        {

        }

       /* private void Form1_Resize(object sender, EventArgs e)
        {
            if (FormWindowState.Minimized == this.WindowState)
            {
                mynotifyicon.Visible = true;
                mynotifyicon.ShowBalloonTip(500);
                this.Hide();
            }
            else if (FormWindowState.Normal == this.WindowState)
            {
                mynotifyicon.Visible = false;
            }
        }
		*/
    }

    internal static class NativeMethods
    {
        [StructLayout(LayoutKind.Sequential)]
        public struct LASTINPUTINFO
        {
            public static readonly int SizeOf = Marshal.SizeOf(typeof(LASTINPUTINFO));

            public UInt32 cbSize;
            public UInt32 dwTime;
        }
        [DllImport("User32.dll")]
        public static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);
    }
}
