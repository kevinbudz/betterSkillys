using System;
using WorldServer.core.objects;
using WorldServer.core.setpieces;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    public class ApplySetpiece : Behavior
    {
        private readonly string name;

        public ApplySetpiece(string name) => this.name = name;

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            var piece = (ISetPiece)Activator.CreateInstance(Type.GetType("WorldServer.core.setpieces." + name, true, true));
            piece.RenderSetPiece(host.World, new IntPoint((int)host.X, (int)host.Y));
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }
    }
}
