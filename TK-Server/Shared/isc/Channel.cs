using System.ComponentModel;

namespace Shared.isc
{
    public enum Channel
    {
        [Description("Network")]
        Network,

        [Description("Control")]
        Control,

        [Description("Chat")]
        Chat,

        [Description("Restart")]
        Restart,

        [Description("Announce")]
        Announce
    }
}
