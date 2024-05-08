using System;
using TKR.Shared.resources;
using TKR.WorldServer.core.objects;
using TKR.WorldServer.core.objects.connection;
using TKR.WorldServer.core.structures;
using TKR.WorldServer.core.worlds;

namespace TKR.WorldServer.core.setpieces
{
    internal class Crystal : ISetPiece
    {
        public override int Size => 5;

        public override void RenderSetPiece(World world, IntPoint pos)
        { 
            Entity Crystal = Entity.Resolve(world.GameServer, "Mysterious Crystal");
            Crystal.Move(pos.X + 2.5f, pos.Y + 2.5f);
            world.EnterWorld(Crystal);
        }
    }
}
