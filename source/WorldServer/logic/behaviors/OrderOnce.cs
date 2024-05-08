using System.Linq;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class OrderOnce : Behavior
    {
        private readonly ushort _children;
        private readonly double _range;
        private readonly string _targetStateName;
        private State _targetState;

        public OrderOnce(double range, string children, string targetState)
        {
            _range = range;
            _children = GetObjType(children);
            _targetStateName = targetState;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state)
        {
            if (_targetState == null)
                _targetState = FindState(host.GameServer.BehaviorDb.Definitions[_children].Item1, _targetStateName);

            foreach (var i in host.GetNearestEntities(_range, _children))
                if (!i.CurrentState.Is(_targetState))
                    i.SwitchTo(_targetState);
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        { }

        private static State FindState(State state, string name)
        {
            if (state.Name == name)
                return state;

            return state.States.Select(i => FindState(i, name)).FirstOrDefault(s => s != null);
        }
    }
}
