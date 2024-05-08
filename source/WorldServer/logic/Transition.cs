using System;
using System.Collections.Generic;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic
{
    public abstract class Transition : IStateChildren
    {
        protected readonly string[] TargetStates;
        protected int SelectedState;

        [ThreadStatic]
        private static Random _rand;
        protected static Random Random => _rand ??= new Random();

        public Transition(params string[] targetStates)
        {
            TargetStates = targetStates;
        }

        public State[] TargetState { get; private set; }

        public bool Tick(Entity host, TickTime time)
        {
            if (host == null) return false;

            host.StateStorage.TryGetValue(this, out object state);

            var ret = TickCore(host, time, ref state);

            if (ret)
                host.SwitchTo(TargetState[SelectedState]);

            if (state == null)
                host.StateStorage.Remove(this);
            else
                host.StateStorage[this] = state;
            return ret;
        }

        internal void Resolve(IDictionary<string, State> states)
        {
            var numStates = TargetStates.Length;
            TargetState = new State[numStates];
            for (var i = 0; i < numStates; i++)
                TargetState[i] = states[TargetStates[i]];
        }

        public virtual void OnDeath(Entity host, ref TickTime time) { }

        protected abstract bool TickCore(Entity host, TickTime time, ref object state);
    }
}
