using Shared.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WorldServer.core.worlds;
using WorldServer.core.net.stats;

namespace WorldServer.core.objects
{
    public sealed class ConditionEffectManager
    {
        public const byte CE_FIRST_BATCH = 0;
        public const byte CE_SECOND_BATCH = 1;
        public const byte NUMBER_CE_BATCHES = 2;
        public const byte NEW_CON_THREASHOLD = 32;

        private StatTypeValue<int> Batch1;
        private StatTypeValue<int> Batch2;

        private int[] Masks;
        private int[] Durations;

        private Entity Host;


        public ConditionEffectManager(Entity host)
        {
            Host = host;

            Masks = new int[NUMBER_CE_BATCHES];
            Durations = new int[(int)ConditionEffectIndex.UnstableImmune];

            Batch1 = new StatTypeValue<int>(host, StatDataType.ConditionBatch1, 0);
            Batch2 = new StatTypeValue<int>(host, StatDataType.ConditionBatch2, 0);
        }

        public void AddCondition(byte effect, int duration)
        {
            Durations[effect] = duration;// Math.Max(Durations[effect], duration);

            var batchType = GetBatch(effect);
            Masks[batchType] |= GetBit(effect);

            UpdateConditionStat(batchType);
        }

        public void AddPermanentCondition(byte effect)
        {
            Durations[effect] = -1;

            var batchType = GetBatch(effect);
            Masks[batchType] |= GetBit(effect);

            UpdateConditionStat(batchType);
        }

        public bool HasCondition(byte effect) => (Masks[GetBatch(effect)] & GetBit(effect)) != 0;

        public void Update(ref TickTime time)
        {
            var dt = time.ElapsedMsDelta;
            if (Masks[0] != 0 || Masks[1] != 0)
                for (byte effect = 0; effect < Durations.Length; effect++)
                {
                    var duration = Durations[effect];
                    if (duration == -1)
                        continue;

                    if (duration <= dt)
                    {
                        RemoveCondition(effect);
                        continue;
                    }

                    Durations[effect] -= dt;
                }
        }

        public void RemoveCondition(byte effect)
        {
            Durations[effect] = 0;

            var batchType = GetBatch(effect);
            Masks[batchType] &= ~GetBit(effect);
            UpdateConditionStat(batchType);
        }


        private void UpdateConditionStat(byte batchType)
        {
            switch (batchType)
            {
                case CE_FIRST_BATCH:
                    Batch1.SetValue(Masks[CE_FIRST_BATCH]);
                    break;
                case CE_SECOND_BATCH:
                    Batch2.SetValue(Masks[CE_SECOND_BATCH]);
                    break;
            }
        }

        public void ExportStats(IDictionary<StatDataType, object> stats)
        {
            stats[StatDataType.ConditionBatch1] = Batch1.GetValue();
            stats[StatDataType.ConditionBatch2] = Batch2.GetValue();
        }

        private static int GetBit(int effect) => 1 << effect - (IsNewCondThreshold(effect) ? NEW_CON_THREASHOLD : 1);
        private static bool IsNewCondThreshold(int effect) => effect >= NEW_CON_THREASHOLD;
        private static byte GetBatch(int effect) => IsNewCondThreshold(effect) ? CE_SECOND_BATCH : CE_FIRST_BATCH;
    }
}
