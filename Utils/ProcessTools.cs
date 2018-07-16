/* 
C# Source File
===============================================================================
Created on:   	6/13/2018 @ 6:39 PM
Created by:   	Alcha
Organization: 	HassleFree Solutions, LLC
Filename:     	Tools.cs
===============================================================================
Comments: Built largely with the two following links, a StackOverflow answer and
    a blog post: https://stackoverflow.com/a/97517 and
    https://vizible.wordpress.com/2009/07/11/c-how-to-get-foreground-window/
*/

using System;
using System.Runtime.InteropServices;

namespace Alcha {
    public static class ProcessTools {
        // The GetForegroundWindow function returns a handle to the foreground window
        // (the window  with which the user is currently working).
        [DllImport ("user32.dll")]
        static extern IntPtr GetForegroundWindow ();

        // The GetWindowThreadProcessId function retrieves the identifier of the thread
        // that created the specified window and, optionally, the identifier of the
        // process that created the window.
        [DllImport ("user32.dll")]
        static extern Int32 GetWindowThreadProcessId (IntPtr hWnd, out uint lpdwProcessId);

        // Returns the name of the process owning the foreground window.
        public static string GetForegroundProcessName () {
            IntPtr hwnd = GetForegroundWindow ();

            // The foreground window can be NULL in certain circumstances, 
            // such as when a window is losing activation.
            if (hwnd == null)
                return "Unknown";

            uint pid;
            GetWindowThreadProcessId (hwnd, out pid);

            foreach (System.Diagnostics.Process p in System.Diagnostics.Process.GetProcesses ()) {
                if (p.Id == pid)
                    return p.ProcessName;
            }

            return "Unknown";
        }
    }
}