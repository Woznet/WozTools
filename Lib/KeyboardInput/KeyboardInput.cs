using System;
using System.Runtime.InteropServices;

namespace WozDev
{
    public static class KeyboardInput
    {
        [StructLayout(LayoutKind.Sequential)]
        struct INPUT
        {
            public uint type;
            public InputUnion u;
        }

        [StructLayout(LayoutKind.Explicit)]
        struct InputUnion
        {
            [FieldOffset(0)]
            public MOUSEINPUT mi;

            [FieldOffset(0)]
            public KEYBDINPUT ki;

            [FieldOffset(0)]
            public HARDWAREINPUT hi;
        }

        [StructLayout(LayoutKind.Sequential)]
        struct MOUSEINPUT
        {
            public int dx;
            public int dy;
            public uint mouseData;
            public uint dwFlags;
            public uint time;
            public IntPtr dwExtraInfo;
        }

        [StructLayout(LayoutKind.Sequential)]
        struct KEYBDINPUT
        {
            public ushort wVk;
            public ushort wScan;
            public uint dwFlags;
            public uint time;
            public IntPtr dwExtraInfo;
        }

        [StructLayout(LayoutKind.Sequential)]
        struct HARDWAREINPUT
        {
            public uint uMsg;
            public ushort wParamL;
            public ushort wParamH;
        }

        // Import the GetKeyState function from user32.dll
        [DllImport(
            "user32.dll",
            CharSet = CharSet.Auto,
            ExactSpelling = true,
            CallingConvention = CallingConvention.Winapi
        )]
        public static extern short GetKeyState(int keyCode);

        [DllImport("user32.dll", SetLastError = true)]
        static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

        private const uint INPUT_KEYBOARD = 1;
        private const ushort KEYEVENTF_KEYUP = 0x0002;
        private const ushort VK_NUMLOCK = 0x90;

        public static void PressNumLock()
        {
            INPUT[] inputs = new INPUT[2];

            // Num Lock key down
            inputs[0].type = INPUT_KEYBOARD;
            inputs[0].u.ki.wVk = VK_NUMLOCK;
            inputs[0].u.ki.wScan = 0;
            inputs[0].u.ki.dwFlags = 0;
            inputs[0].u.ki.time = 0;
            inputs[0].u.ki.dwExtraInfo = IntPtr.Zero;

            // Num Lock key up
            inputs[1].type = INPUT_KEYBOARD;
            inputs[1].u.ki.wVk = VK_NUMLOCK;
            inputs[1].u.ki.wScan = 0;
            inputs[1].u.ki.dwFlags = KEYEVENTF_KEYUP;
            inputs[1].u.ki.time = 0;
            inputs[1].u.ki.dwExtraInfo = IntPtr.Zero;

            SendInput((uint)inputs.Length, inputs, Marshal.SizeOf(typeof(INPUT)));
        }

        public static bool IsNumLockOn()
        {
            return (((ushort)GetKeyState(VK_NUMLOCK)) & 0xffff) != 0;
        }
    }
}
