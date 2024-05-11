using Shared.resources;
using System;
using System.Linq;
using WorldServer.core.objects;
using WorldServer.utils;
using WorldServer.core.net.stats;

namespace WorldServer.core
{
    internal class BoostStatManager
    {
        public ActivateBoost[] ActivateBoost;
        private int[] _boost;
        private StatTypeValue<int>[] _boostSV;
        private StatsManager _parent;
        private Player _player;

        public BoostStatManager(StatsManager parent)
        {
            _parent = parent;
            _player = parent.Owner;
            _boost = new int[StatsManager.NumStatTypes];
            _boostSV = new StatTypeValue<int>[_boost.Length];

            for (var i = 0; i < _boostSV.Length; i++)
                _boostSV[i] = new StatTypeValue<int>(_player, StatsManager.GetBoostStatType(i), _boost[i], i != 0 && i != 1);

            ActivateBoost = new ActivateBoost[_boost.Length];
            for (var i = 0; i < ActivateBoost.Length; i++)
                ActivateBoost[i] = new ActivateBoost();

            ReCalculateValues();
        }

        public int this[int index] => _boost[index];

        protected internal void ReCalculateValues()
        {
            for (var i = 0; i < _boost.Length; i++)
                _boost[i] = 0;

            ApplyEquipBonus();
            ApplyActivateBonus();
            IncrementStatBoost();

            for (var i = 0; i < _boost.Length; i++)
                _boostSV[i].SetValue(_boost[i]);
        }

        private void ApplyActivateBonus()
        {
            for (var i = 0; i < ActivateBoost.Length; i++)
            {
                // set boost
                var b = ActivateBoost[i].GetBoost();
                _boost[i] += b;

                // set condition icon

                var effect = (ConditionEffectIndex)((int)ConditionEffectIndex.HpBoost + i);
                var haveCondition = _player.HasConditionEffect(effect);
                if (b > 0)
                {
                    if (!haveCondition)
                        _player.ApplyPermanentConditionEffect(effect);
                }
                else
                {
                    if (haveCondition)
                        _player.RemoveCondition(effect);
                }
            }
        }

        private void ApplyEquipBonus()
        {
            for (var i = 0; i < 4; i++)
            {
                if (_player.Inventory[i] == null)
                    continue;

                foreach (var b in _player.Inventory[i].ActivateOnEquips)
                    IncrementBoost((StatDataType)b.Key, b.Value);
            }

            for (var i = 20; i < 28; i++)
            {
                if (_player.Inventory[i] == null || _player.Inventory[i].SlotType != 26)
                    continue;
                foreach (var b in _player.Inventory[i].ActivateOnEquips)
                    IncrementBoost((StatDataType)b.Key, b.Value);
            }
        }

        private void FixedStat(StatDataType stat, int value)
        {
            var i = StatsManager.GetStatIndex(stat);
            _boost[i] = value - _parent.Base[i];
        }

        private int IncreasePercentage(int percentageToIncrease, int stat)
        {
            int percentage = percentageToIncrease;
            var result = percentage * _parent.Base[stat] / 100;
            return result;
        }

        public void IncrementBoost(StatDataType stat, int amount)
        {
            var i = StatsManager.GetStatIndex(stat);

            if (_parent.Base[i] + amount < 1)
                amount = i == 0 ? -_parent.Base[i] + 1 : -_parent.Base[i];

            _boost[i] += amount;
        }

        private void IncrementStatBoost()
        {
            if (_player == null || _player.Client == null || _player.Client.Account == null)
                return;

            for (var a = 0; a < 8; a++)
            {
                if (a >= 7)
                    a = 7;

                if (a >= 8)
                    return;
                if (_player.Client.Account.SetBaseStat > 0)
                    _boost[a] += a < 2 ? _player.Client.Account.SetBaseStat * 5 : _player.Client.Account.SetBaseStat;
            }
        }
    }
}
