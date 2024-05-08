using Shared;

namespace WorldServer.networking.packets.outgoing
{
    public class DeathMessage : OutgoingMessage
    {
        private int AccountId;
        private int CharId;
        private string KilledBy;

        public override MessageId MessageId => MessageId.DEATH;

        public DeathMessage(int accountId, int charId, string killedBy)
        {
            AccountId = accountId;
            CharId = charId;
            KilledBy = killedBy;
        }

        public override void Write(NetworkWriter wtr)
        {
            wtr.Write(AccountId);
            wtr.Write(CharId);
            wtr.WriteUTF16(KilledBy);
        }
    }
}
