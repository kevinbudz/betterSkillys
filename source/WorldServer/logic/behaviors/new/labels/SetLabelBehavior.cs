using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic.data;

namespace WorldServer.logic.behaviors.@new.labels
{
    public sealed class SetLabelBehavior : Behavior
    {
        private readonly LabelType _labelType;
        private readonly string _labelName;

        public SetLabelBehavior(string labelName, LabelType labelType)
        {
            _labelName = labelName;
            _labelType = labelType;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            switch (_labelType)
            {
                case LabelType.Entity:
                    host.SetLabel(_labelName);
                    break;
                case LabelType.World:
                    host.World.SetLabel(_labelName);
                    break;
                default:
                    throw new Exception($"[SetLabelBehavior] Unknown Label Case: {_labelType}");
            }
        }
    }
}
