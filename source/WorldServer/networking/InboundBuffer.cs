using WorldServer.networking.packets;

namespace WorldServer.networking
{
    public readonly struct InboundBuffer
    {
        public readonly Client Client;
        public readonly MessageId MessageId;
        public readonly byte[] Payload;

        public InboundBuffer(Client client, MessageId id, byte[] payload)
        {
            Client = client;
            MessageId = id;
            Payload = payload;
        }
    }
}
