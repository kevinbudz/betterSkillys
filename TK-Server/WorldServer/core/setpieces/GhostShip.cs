using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
{
    internal class GhostShip : ISetPiece
    {
        public override int Size => 40;
        public override string Map => "setpieces/ghost_ship.jm";
    }
}
