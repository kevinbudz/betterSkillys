using System;
using System.Collections.Generic;
using System.Linq;

namespace WorldServer.core.objects.player.data.container
{
    public sealed class UpdatedHashSet : HashSet<Entity>
    {
        private readonly Player _player;

        public UpdatedHashSet(Player player) => _player = player;

        public new bool Add(Entity e)
        {
            var added = base.Add(e);
            if (added)
                e.StatChanged += _player.HandleStatChanges;
            return added;
        }

        public new bool Remove(Entity e)
        {
            e.StatChanged -= _player.HandleStatChanges;
            return base.Remove(e);
        }

        public new void RemoveWhere(Predicate<Entity> match)
        {
            foreach (var e in this.Where(match.Invoke))
                e.StatChanged -= _player.HandleStatChanges;
            base.RemoveWhere(match);
        }

        public void Dispose() => RemoveWhere(e => true);
    }
}
