using System;
using System.Collections.Generic;
using System.Linq;

namespace WorldServer.core.objects.player
{
    public sealed class UpdatedHashSet : HashSet<Entity>
    {
        public UpdatedHashSet(PlayerUpdate playerUpdate) => PlayerUpdate = playerUpdate;

        private PlayerUpdate PlayerUpdate { get; set; }

        public new bool Add(Entity e)
        {
            var added = base.Add(e);
            if (added)
                e.StatChanged += PlayerUpdate.HandleStatChanges;
            return added;
        }

        public new bool Remove(Entity e)
        {
            e.StatChanged -= PlayerUpdate.HandleStatChanges;
            return base.Remove(e);
        }

        public new void RemoveWhere(Predicate<Entity> match)
        {
            foreach (var e in this.Where(match.Invoke))
                e.StatChanged -= PlayerUpdate.HandleStatChanges;
            base.RemoveWhere(match);
        }

        public void Dispose() => RemoveWhere(e => true);
    }
}
