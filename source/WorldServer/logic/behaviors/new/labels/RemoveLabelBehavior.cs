using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.logic.data;

namespace WorldServer.logic.behaviors.@new.labels
{
    public sealed class RemoveLabelBehavior : Behavior
    {
        private readonly LabelType _labelType;
        private readonly string _labelName;

        public RemoveLabelBehavior(string labelName, LabelType labelType)
        {
            _labelName = labelName;
            _labelType = labelType;
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            switch (_labelType)
            {
                case LabelType.Entity:
                    host.RemoveLabel(_labelName);
                    break;
                case LabelType.World:
                    host.World.RemoveLabel(_labelName);
                    break;
                default:
                    throw new Exception($"[RemoveLabelBehavior] Unknown Label Case: {_labelType}");
            }
        }
    }
}
