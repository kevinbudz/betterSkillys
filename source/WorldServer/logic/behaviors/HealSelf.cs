using Shared.resources;
using WorldServer.core.net.datas;
using WorldServer.core.objects;
using WorldServer.core.structures;
using WorldServer.core.worlds;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.logic.behaviors
{
    internal class HealSelf : Behavior
    {
        private readonly int? _amount;
        private readonly bool _percentage;
        private Cooldown _coolDown;

        public HealSelf(Cooldown coolDown = new Cooldown(), int? amount = null, bool percentage = false)
        {
            _coolDown = coolDown.Normalize();
            _amount = amount;
            _percentage = percentage;
        }

        protected override void OnStateEntry(Entity host, TickTime time, ref object state) => state = 0;

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            var cool = (int)state;

            if (cool <= 0)
            {
                if (host.HasConditionEffect(ConditionEffectIndex.Stunned))
                    return;

                if (!(host is Character entity))
                    return;

                var newHp = 0;

                if (_amount != null)
                {
                    var newHealth = (int)_amount;
                    if (_percentage)
                    {
                        newHealth = (int)_amount * entity.HP / 100;
                    }
                    newHp = newHealth;
                }

                if (newHp > entity.MaximumHP)
                    newHp = entity.MaximumHP;

                if (newHp != entity.HP)
                {
                    entity.HP += newHp;

                    if (entity.HP > entity.MaximumHP)
                        entity.HP = entity.MaximumHP;

                    entity.World.BroadcastIfVisible(new ShowEffect() { EffectType = EffectType.Potion, TargetObjectId = entity.Id, Color = new ARGB(0xffffffff) }, entity);
                    entity.World.BroadcastIfVisible(new ShowEffect()
                    {
                        EffectType = EffectType.Trail,
                        TargetObjectId = host.Id,
                        Pos1 = new Position() { X = entity.X, Y = entity.Y },
                        Color = new ARGB(0xffffffff)
                    }, host);
                    entity.World.BroadcastIfVisible(new Notification() { ObjectId = entity.Id, Message = "+" + newHp, Color = new ARGB(0xff00ff00) }, entity);
                }

                cool = _coolDown.Next(Random);
            }
            else
                cool -= time.ElapsedMsDelta;

            state = cool;
        }
    }
}
