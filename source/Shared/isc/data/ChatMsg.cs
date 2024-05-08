using Shared.isc;

namespace Shared.isc.data
{
    public struct ChatMsg
    {
        public int Admin;
        public int From;
        public bool Hidden;
        public string Instance;
        public string Name;
        public int ObjectId;
        public string SrcIP;
        public int Stars;
        public string Text;
        public int To;
        public ChatType Type;
    }
}
