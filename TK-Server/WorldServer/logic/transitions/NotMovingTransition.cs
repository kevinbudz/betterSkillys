using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic.transitions
{
    internal class NotMovingTransition : Transition
    {
        //State storage: NotMovingState

        private class NotMovingState
        {
            public Vector2 Position;
            public int Delay;
        }

        private readonly int _delay;

        public NotMovingTransition(string targetState, int delay = 250)
            : base(targetState)
        {
            _delay = delay;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            if (state == null)
            {
                state = new NotMovingState()
                {
                    Position = new Vector2(host.X, host.Y),
                    Delay = _delay
                };
                return false;
            }

            var s = (NotMovingState)state;
            if (s.Delay <= 0)
            {
                var hostPos = new Vector2(host.X, host.Y);
                if (hostPos == s.Position)
                {
                    state = null;
                    return true;
                }

                s.Position = hostPos;
                s.Delay = _delay;
                return false;
            }

            s.Delay -= time.ElapsedMsDelta;
            return false;
        }
    }
}
