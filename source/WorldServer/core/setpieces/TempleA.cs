using System;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.objects;
using WorldServer.core.objects.containers;
using WorldServer.core.structures;

namespace WorldServer.core.setpieces
{
    internal class TempleA : Temple
    {
        private const int bas = 17;


        public override int Size => 60;

        public override void RenderSetPiece(World world, IntPoint pos)
        {
            var t = new int[Size, Size];
            var o = new int[Size, Size];

            for (var x = 0; x < 60; x++)                    //Flooring
                for (var y = 0; y < 60; y++)
                    if (Math.Abs(x - Size / 2) / (Size / 2.0) + Random.Shared.NextDouble() * 0.3 < 0.9 && Math.Abs(y - Size / 2) / (Size / 2.0) + Random.Shared.NextDouble() * 0.3 < 0.9)
                    {
                        var dist = Math.Sqrt(((x - Size / 2) * (x - Size / 2) + (y - Size / 2) * (y - Size / 2)) / (Size / 2.0 * (Size / 2.0)));

                        t[x, y] = Random.Shared.NextDouble() < (1 - dist) * (1 - dist) ? 2 : 1;
                    }

            for (var x = 0; x < Size; x++)                  //Corruption
                for (var y = 0; y < Size; y++)
                    if (Random.Shared.Next() % 50 == 0)
                        t[x, y] = 0;

            for (var x = 0; x < 20; x++)
            {
                o[bas + x, bas] = x == 19 ? 2 : 1;
                o[bas + x, bas + 1] = 2;
            }

            for (var y = 0; y < 20; y++)
            {
                o[bas, bas + y] = y == 19 ? 2 : 1;

                if (y != 0)
                    o[bas + 1, bas + y] = 2;
            }

            for (var x = 0; x < 19; x++)
            {
                o[bas + 8 + x, bas + 25] = 2;
                o[bas + 8 + x, bas + 26] = x == 0 ? 2 : 1;
            }

            for (var y = 0; y < 19; y++)
            {
                if (y != 18)
                    o[bas + 25, bas + 8 + y] = 2;

                o[bas + 26, bas + 8 + y] = y == 0 ? 2 : 1;
            }

            o[bas + 5, bas + 5] = 3;                        //Columns
            o[bas + 21, bas + 5] = 3;
            o[bas + 5, bas + 21] = 3;
            o[bas + 21, bas + 21] = 3;
            o[bas + 9, bas + 9] = 3;
            o[bas + 17, bas + 9] = 3;
            o[bas + 9, bas + 17] = 3;
            o[bas + 17, bas + 17] = 3;

            for (var x = 0; x < Size; x++)                  //Plants
                for (var y = 0; y < Size; y++)
                {
                    if ((x > 5 && x < bas || x < Size - 5 && x > Size - bas || y > 5 && y < bas || y < Size - 5 && y > Size - bas) && o[x, y] == 0 && t[x, y] == 1)
                    {
                        var r = Random.Shared.NextDouble();

                        if (r > 0.6)        //0.4
                            o[x, y] = 4;
                        else if (r > 0.35)  //0.25
                            o[x, y] = 5;
                        else if (r > 0.33)  //0.02
                            o[x, y] = 6;
                    }
                }

            var rotation = Random.Shared.Next(0, 4);               //Rotation

            for (var i = 0; i < rotation; i++)
            {
                t = SetPieces.RotateCW(t);
                o = SetPieces.RotateCW(o);
            }

            Render(this, world, pos, t, o);

            //Boss & Chest

            var container = new Container(world.GameServer, 0x0501, null, false);
            var items = chest.CalculateItems(world.GameServer, Random.Shared, 3, 8).ToArray();

            for (var i = 0; i < items.Length; i++)
                container.Inventory[i] = items[i];

            container.Move(pos.X + Size / 2, pos.Y + Size / 2);
            world.EnterWorld(container);

            var snake = Entity.Resolve(world.GameServer, 0x0dc2);
            snake.Move(pos.X + Size / 2, pos.Y + Size / 2);
            world.EnterWorld(snake);
        }
    }
}
