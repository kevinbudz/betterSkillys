using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.behaviors
{
    internal class SetAltTexture : Behavior
    {
        private readonly int _indexMax;
        private readonly int _indexMin;
        private readonly bool _loop;
        private Cooldown _cooldown;

        public SetAltTexture(int minValue, int maxValue = -1, Cooldown cooldown = new Cooldown(), bool loop = false)
        {
            _indexMin = minValue;
            _indexMax = maxValue;
            _cooldown = cooldown.Normalize(0);
            _loop = loop;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            state = new TextureState() { currentTexture = host.AltTextureIndex, remainingTime = _cooldown.Next(Random) };

            if (host.AltTextureIndex != _indexMin)
            {
                host.AltTextureIndex = _indexMin;
                (state as TextureState).currentTexture = _indexMin;
            }
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var textState = state as TextureState;

            if (_indexMax == -1 || textState.currentTexture == _indexMax && !_loop)
                return;

            if (textState.remainingTime <= 0)
            {
                var newTexture = textState.currentTexture >= _indexMax ? _indexMin : textState.currentTexture + 1;

                host.AltTextureIndex = newTexture;
                textState.currentTexture = newTexture;
                textState.remainingTime = _cooldown.Next(Random);
            }
            else
                textState.remainingTime -= time.ElapsedMsDelta;
        }

        private class TextureState
        {
            public int currentTexture;
            public int remainingTime;
        }
    }
}
