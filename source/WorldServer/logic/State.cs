using System;
using System.Collections.Generic;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.logic
{
    public interface IStateChildren { }

    public class BehaviorEventArgs : EventArgs
    {
        public BehaviorEventArgs(Entity host, TickTime time)
        {
            Host = host;
            Time = time;
        }

        public Entity Host { get; private set; }
        public TickTime Time { get; private set; }
    }

    public class State : IStateChildren
    {
        public static readonly State NullState = new State();

        public State(params IStateChildren[] children) : this("", children)
        { }

        public State(string name, params IStateChildren[] children)
        {
            Name = name;
            States = new List<State>();
            Behaviors = new List<Behavior>();
            Transitions = new List<Transition>();

            foreach (var i in children)
            {
                if (i is State)
                {
                    State state = i as State;
                    state.Parent = this;
                    States.Add(state);
                }
                else if (i is Behavior)
                    Behaviors.Add(i as Behavior);
                else if (i is Transition)
                    Transitions.Add(i as Transition);
                else
                    throw new NotSupportedException("Unknown children type.");
            }
        }

        public IList<Behavior> Behaviors { get; private set; }
        public string Name { get; private set; }
        public State Parent { get; private set; }
        public IList<State> States { get; private set; }
        public IList<Transition> Transitions { get; private set; }

        public static State CommonParent(State a, State b)
        {
            if (a == null || b == null) return null;
            else return _CommonParent(a, a, b);
        }

        //child is parent
        //parent is not child
        public bool Is(State state)
        {
            if (this == state) return true;
            else if (Parent != null) return Parent.Is(state);
            else return false;
        }

        public event EventHandler<BehaviorEventArgs> Death;

        internal void OnDeath(BehaviorEventArgs e)
        {
            if (Death != null)
                Death(this, e);
            if (Parent != null)
                Parent.OnDeath(e);
        }

        public override string ToString()
        {
            return Name;
        }

        internal void OnDeath(Entity host, ref TickTime time)
        {
            //if(host.CurrentState.Is(parent)) ???
            //{

            //}
            //foreach (var i in States) stack overflow
            //    i.OnDeath(host, ref time);
            foreach (var j in Transitions)
                j.OnDeath(host, ref time);
            foreach (var j in Behaviors)
                j.OnDeath(host, ref time);
            if (Parent != null)
                Parent.OnDeath(host, ref time);
        }

        internal void Resolve(Dictionary<string, State> states)
        {
            states[Name] = this;
            foreach (var i in States)
                i.Resolve(states);
        }

        internal void ResolveChildren(Dictionary<string, State> states)
        {
            foreach (var i in States)
                i.ResolveChildren(states);
            foreach (var j in Transitions)
                j.Resolve(states);
            foreach (var j in Behaviors)
                j.Resolve(this);
        }

        private static State _CommonParent(State current, State a, State b)
        {
            if (b.Is(current)) return current;
            else if (a.Parent == null) return null;
            else return _CommonParent(current.Parent, a, b);
        }

        private void ResolveTransition(Dictionary<string, State> states)
        {
            foreach (var i in Transitions)
                i.Resolve(states);
        }
    }
}
