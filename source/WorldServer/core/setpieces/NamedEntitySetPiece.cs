using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.core.setpieces
{
    public sealed class NamedEntitySetPiece : ISetPiece
    {
        private string EntityName;

        public NamedEntitySetPiece(string entityName) => EntityName = entityName;

        public override int Size => 5;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var entity = Entity.Resolve(world.GameServer, EntityName);

            if (entity == null)
                return;

            entity.Move(pos.X + Size / 2f, pos.Y + Size / 2f);
            world.EnterWorld(entity);
        }
    }
}
