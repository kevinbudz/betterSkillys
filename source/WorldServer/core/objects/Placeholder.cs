using WorldServer.core;

namespace WorldServer.core.objects
{
    internal class Placeholder : StaticObject
    {
        public Placeholder(GameServer manager, int life) : base(manager, 0x070f, life, true, true, false) => Size = 0;
    }
}
