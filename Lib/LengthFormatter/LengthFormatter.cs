using System.Runtime.InteropServices;
using System.Text;

namespace WozDev
{
    public static class FormatLength
    {
        [DllImport("Shlwapi.dll", CharSet = CharSet.Auto)]
        public static extern long StrFormatByteSize(long fileSize, StringBuilder buffer, int bufferSize);
    }
}
