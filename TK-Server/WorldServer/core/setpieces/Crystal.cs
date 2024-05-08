using System;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.objects.connection;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
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
