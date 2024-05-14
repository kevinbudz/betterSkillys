using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic.data;

namespace WorldServer.logic.transitions
{
    public sealed class HasLabelTransition : Transition
    {
        private readonly float _prob;
        private readonly LabelType _labelType;
        private readonly string _labelName;

        public HasLabelTransition(string labelName, LabelType labelType, params string[] targetState)
            : base(targetState)
        {
            _prob = 1.0f;
            _labelType = labelType;
            _labelName = labelName;
        }

        public HasLabelTransition(float prob, string labelName, LabelType labelType, params string[] targetState)
            : base(targetState)
        {
            _prob = prob;
            _labelType = labelType;
            _labelName = labelName;
        }

        protected override bool TickCore(Entity host, TickTime time, ref object state)
        {
            if (Random.Shared.NextDouble() < _prob)
                return false;

            return _labelType switch
            {
                LabelType.Entity => host.HasLabel(_labelName),
                LabelType.World => host.World.HasLabel(_labelName),
                _ => throw new Exception($"[HasEntityLabelTransition] Unknown Label Case: {_labelType}"),
            };
        }
    }
}
