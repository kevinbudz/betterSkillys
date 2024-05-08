using System;
using TKR.Shared.resources;
using TKR.WorldServer.core.objects;
using TKR.WorldServer.core.objects.connection;
using TKR.WorldServer.core.structures;
using TKR.WorldServer.core.worlds;

namespace TKR.WorldServer.core.setpieces
{
    internal class GarnetJade : ISetPiece
    {
        private static readonly string Gate3 = "Japanese Temple Gate 3";

        private static byte[,] SetPiece //[Y, X]
        {
            get
            {
                return new byte[,]
                {
                    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 15, 15, 15, 8, 8, 8, 8, 8, 8, 8, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 15, 15, 15, 8, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 15, 15, 15, 14, 14, 14, 14, 14, 14, 14, 14, 15, 15, 15, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0},
                    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 8, 8, 11, 12, 13, 13, 16, 16, 12, 11, 8, 8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
                    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
                    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 2, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 4, 4, 4, 3, 3, 3, 2, 3, 3, 3, 4, 4, 4, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 5, 4, 3, 1, 1, 2, 1, 1, 3, 4, 5, 4, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 4, 4, 4, 3, 1, 1, 1, 2, 1, 3, 4, 4, 4, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 1, 2, 1, 1, 2, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {2, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {2, 2, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 1, 2, 2, 2, 6, 6, 6, 2, 2, 2, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2},
                    {2, 2, 2, 1, 1, 2, 2, 1, 1, 3, 3, 3, 1, 2, 10, 2, 6, 7, 6, 2, 9, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2},
                    {2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 3, 2, 2, 2, 2, 6, 6, 6, 2, 2, 2, 1, 3, 3, 3, 2, 1, 1, 2, 1, 1, 1, 2, 2},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 1, 1, 2, 2, 2, 2, 2, 2, 1, 1, 1, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 2},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 1, 2, 2, 1, 2, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 4, 4, 4, 3, 1, 1, 1, 2, 1, 1, 4, 4, 4, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 4, 5, 4, 3, 1, 1, 1, 2, 1, 1, 4, 5, 4, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 3, 3, 3, 3, 3, 1, 3, 3, 3, 3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
                    {0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
                    {0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
                    {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
                    {0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0},
                };
            }
        }

        public override int Size => 35;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            XmlData dat = world.GameServer.Resources.GameData;
            for (int x = 0; x < Size; x++)
            {
                for (int y = 0; y < Size; y++)
                {
                    if (SetPiece[y, x] == 1)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Hanami Grass 1 Light"];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 2)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Japanese Stone Path"];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 3)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Hanami Grass 2 Dark"];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 4)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Hanami Grass 3 Dark"];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 5)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Dirt"];
                        tile.ObjType = dat.IdToObjectType["Japanese Prayer Tree"];
                        if (tile.ObjId == 0) tile.ObjId = world.GetNextEntityId();
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 6)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Hanami Grass 3 Dark"];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 7)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Hanami Grass 3 Dark"];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                        Entity statue = Entity.Resolve(world.GameServer, "Encounter Altar");
                        statue.Move(pos.X + x + .5f, pos.Y + y + .5f);
                        world.EnterWorld(statue);
                    }
                    else if (SetPiece[y, x] == 8)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Hanami Grass 1 Light"];
                        tile.ObjType = dat.IdToObjectType["Japanese Trees Pink"];
                        if (tile.ObjId == 0) tile.ObjId = world.GetNextEntityId();
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 9)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Japanese Rock"];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                        Entity statue = Entity.Resolve(world.GameServer, "Jade Statue");
                        statue.Move(pos.X + x + .5f, pos.Y + y + .5f);
                        world.EnterWorld(statue);
                    }
                    else if (SetPiece[y, x] == 10)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Japanese Rock"];
                        tile.ObjType = 0;
                        world.Map[x + pos.X, y + pos.Y] = tile;
                        Entity statue = Entity.Resolve(world.GameServer, "Garnet Statue");
                        statue.Move(pos.X + x + .5f, pos.Y + y + .5f);
                        world.EnterWorld(statue);
                    }
                    else if (SetPiece[y, x] == 11)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Japanese Rock"];
                        tile.ObjType = dat.IdToObjectType["Japanese Temple Gate 1"];
                        if (tile.ObjId == 0) tile.ObjId = world.GetNextEntityId();
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 12)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Japanese Rock"];
                        tile.ObjType = dat.IdToObjectType["Japanese Temple Gate 5"];
                        if (tile.ObjId == 0) tile.ObjId = world.GetNextEntityId();
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 13)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Japanese Rock"];
                        tile.ObjType = dat.IdToObjectType["Japanese Temple Gate 4"];
                        if (tile.ObjId == 0) tile.ObjId = world.GetNextEntityId();
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 14)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Japanese Rock"];
                        tile.ObjType = dat.IdToObjectType["Japanese Wall Outside 2"];
                        if (tile.ObjId == 0) tile.ObjId = world.GetNextEntityId();
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 15)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Hanami Grass 1 Light"];
                        tile.ObjType = dat.IdToObjectType["Japanese Tree Mini Red"];
                        if (tile.ObjId == 0) tile.ObjId = world.GetNextEntityId();
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                    else if (SetPiece[y, x] == 16)
                    {
                        var tile = world.Map[x + pos.X, y + pos.Y].Clone();
                        tile.TileId = dat.IdToTileType["Japanese Rock"];
                        tile.ObjType = dat.IdToObjectType[Gate3];
                        if (tile.ObjId == 0) tile.ObjId = world.GetNextEntityId();
                        world.Map[x + pos.X, y + pos.Y] = tile;
                    }
                }
            }
        }
    }
}