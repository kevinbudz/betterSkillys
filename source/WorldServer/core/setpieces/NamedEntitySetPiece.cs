using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
{
    public sealed class NamedEntitySetPiece : ISetPiece
    {
        private readonly string _entityName;

        public NamedEntitySetPiece(string entityName) => _entityName = entityName;

        public override int Size => 5;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var entity = Entity.Resolve(world.GameServer, _entityName);
            if (entity == null)
                return;

            entity.Move(pos.X + Size / 2f, pos.Y + Size / 2f);
            world.EnterWorld(entity);
        }
    }
}
