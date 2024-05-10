using Shared.resources;
using System.Collections.Generic;
using WorldServer.core.net.stats;
using WorldServer.core.worlds;

namespace WorldServer.core.objects
{
    public sealed class ConditionEffectManager
    {
        public const byte CE_FIRST_BATCH = 0;
        public const byte CE_SECOND_BATCH = 1;
        public const byte NUMBER_CE_BATCHES = 2;
        public const byte NEW_CON_THREASHOLD = 32;

        private readonly StatTypeValue<int> _batch1;
        private readonly StatTypeValue<int> _batch2;

        private readonly Entity _host;
        private readonly int[] _masks;
        private readonly int[] _durations;

        public ConditionEffectManager(Entity host)
        {
            _host = host;

            _masks = new int[NUMBER_CE_BATCHES];
            _durations = new int[(int)ConditionEffectIndex.UnstableImmune];

            _batch1 = new StatTypeValue<int>(host, StatDataType.ConditionBatch1, 0);
            _batch2 = new StatTypeValue<int>(host, StatDataType.ConditionBatch2, 0);
        }

        public void AddCondition(byte effect, int duration)
        {
            _durations[effect] = duration; // Math.Max(Durations[effect], duration);

            var batchType = GetBatch(effect);
            _masks[batchType] |= GetBit(effect);

            UpdateConditionStat(batchType);
        }

        public void AddPermanentCondition(byte effect)
        {
            _durations[effect] = -1;

            var batchType = GetBatch(effect);
            _masks[batchType] |= GetBit(effect);

            UpdateConditionStat(batchType);
        }

        public bool HasCondition(byte effect) => (_masks[GetBatch(effect)] & GetBit(effect)) != 0;

        public void Update(ref TickTime time)
        {
            var dt = time.ElapsedMsDelta;
            if (_masks[CE_FIRST_BATCH] != 0 || _masks[CE_SECOND_BATCH] != 0)
                for (byte effect = 0; effect < _durations.Length; effect++)
                {
                    var duration = _durations[effect];
                    if (duration == -1)
                        continue;

                    if (duration <= dt)
                    {
                        RemoveCondition(effect);
                        continue;
                    }

                    _durations[effect] -= dt;
                }
        }

        public void RemoveCondition(byte effect)
        {
            _durations[effect] = 0;

            var batchType = GetBatch(effect);
            _masks[batchType] &= ~GetBit(effect);
            UpdateConditionStat(batchType);
        }


        private void UpdateConditionStat(byte batchType)
        {
            switch (batchType)
            {
                case CE_FIRST_BATCH:
                    _batch1.SetValue(_masks[CE_FIRST_BATCH]);
                    break;
                case CE_SECOND_BATCH:
                    _batch2.SetValue(_masks[CE_SECOND_BATCH]);
                    break;
            }
        }

        public void ExportStats(IDictionary<StatDataType, object> stats)
        {
            stats[StatDataType.ConditionBatch1] = _batch1.GetValue();
            stats[StatDataType.ConditionBatch2] = _batch2.GetValue();
        }

        private static int GetBit(int effect) => 1 << effect - (IsNewCondThreshold(effect) ? NEW_CON_THREASHOLD : 1);
        private static bool IsNewCondThreshold(int effect) => effect >= NEW_CON_THREASHOLD;
        private static byte GetBatch(int effect) => IsNewCondThreshold(effect) ? CE_SECOND_BATCH : CE_FIRST_BATCH;
    }
}
