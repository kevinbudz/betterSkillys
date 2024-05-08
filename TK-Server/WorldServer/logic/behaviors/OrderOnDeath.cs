using System;
using System.Linq;
using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.core;
using WorldServer.utils;


namespace WorldServer.logic.behaviors
{
    class OrderOnDeath : Behavior
    {
        private readonly double _range;
        private readonly ushort _target;
        private readonly string _stateName;
        private readonly float _probability;

        private State _targetState;

        public OrderOnDeath(double range, string target, string state, double probability = 1)
        {
            _range = range;
            _target = GetObjType(target);
            _stateName = state;
            _probability = (float)probability;
        }

        private static State FindState(State state, string name)
        {
            if (state.Name == name)
                return state;

            return state.States
                .Select(i => FindState(i, name))
                .FirstOrDefault(s => s != null);
        }

        protected internal override void Resolve(State parent)
        {
            parent.Death += (sender, e) =>
            {
                if (_targetState == null)
                    _targetState = FindState(e.Host.GameServer.BehaviorDb.Definitions[_target].Item1, _stateName);

                if (e.Host.CurrentState.Is(parent) &&
                    Random.NextDouble() < _probability)
                {
                    foreach (var i in e.Host.GetNearestEntities(_range, _target))
                        if (!i.CurrentState.Is(_targetState))
                            i.SwitchTo(_targetState);
                }
            };
        }

        protected override void TickCore(Entity host, TickTime time, ref object state) { }
    }
}
