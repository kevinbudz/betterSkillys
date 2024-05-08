using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public sealed class AccountListMessage : OutgoingMessage
    {
        private readonly int AccountListId;
        private readonly string[] AccountIds;

        public override MessageId MessageId => MessageId.ACCOUNTLIST;

        public AccountListMessage(int accountListId, string[] accountIds)
        {
            AccountListId = accountListId;
            AccountIds = accountIds;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(AccountListId);
            wtr.Write((short)AccountIds.Length);
            foreach (var i in AccountIds)
                wtr.WriteUTF16(i);
        }
    }
}
