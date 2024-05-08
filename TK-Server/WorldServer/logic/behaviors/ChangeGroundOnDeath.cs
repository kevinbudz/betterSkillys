using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    public class ChangeGroundOnDeath : Behavior
    {
        private readonly int dist;
        private readonly string[] groundToChange;
        private readonly string[] targetType;

        /// <summary>
        ///     Changes the ground if the monster dies
        /// </summary>
        /// <param name="GroundToChange">The tiles you want to change (null for every tile)</param>
        /// <param name="ChangeTo">The tiles who will replace the old once</param>
        /// <param name="dist">The distance around the monster</param>
        public ChangeGroundOnDeath(string[] GroundToChange, string[] ChangeTo, int dist)
        {
            groundToChange = GroundToChange;
            targetType = ChangeTo;

            this.dist = dist;
        }

        public override void OnDeath(Entity host, ref TickTime time)
        {
            var dat = host.GameServer.Resources.GameData;
            var w = host.World;
            var pos = new IntPoint((int)host.X - dist / 2, (int)host.Y - dist / 2);

            if (w == null)
                return;

            for (var x = 0; x < dist; x++)
                for (var y = 0; y < dist; y++)
                {
                    var tile = w.Map[x + pos.X, y + pos.Y];

                    var r = Random.Next(targetType.Length);
                    if (groundToChange != null)
                    {
                        foreach (string type in groundToChange)
                        {
                            if (tile.TileId == dat.IdToTileType[type])
                            {
                                tile.TileId = dat.IdToTileType[targetType[r]];
                            }
                        }
                    }
                    else
                    {
                        tile.TileId = dat.IdToTileType[targetType[r]];
                    }

                    tile.UpdateCount++;
                }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }
    }
}
