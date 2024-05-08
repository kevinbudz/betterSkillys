using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
{
    internal class Avatar : ISetPiece
    {
        public override int Size => 32;
        public override string Map => "setpieces/avatar.jm";
    }
}
