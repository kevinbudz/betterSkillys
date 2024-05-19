using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.structures;

namespace WorldServer.logic.behaviors
{
    internal class ChangeGround : Behavior
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
        public ChangeGround(string[] GroundToChange, string[] ChangeTo, int dist)
        {
            groundToChange = GroundToChange;
            targetType = ChangeTo;

            this.dist = dist;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
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
    }
}
