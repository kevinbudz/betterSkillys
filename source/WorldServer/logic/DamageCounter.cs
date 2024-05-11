using System;
using System.Collections.Generic;
using Shared;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds.impl;

namespace WorldServer.logic
{
    public class DamageCounter
    {
        private WeakDictionary<Player, int> Hitters;

        public Enemy Host;

        public DamageCounter(Enemy enemy) => Host = enemy;

        public DamageCounter Corpse { get; set; }
        public Player LastHitter { get; private set; }
        public DamageCounter Parent { get; set; }
        public int TotalDamage { get; private set; }

        public WeakDictionary<Player, int> GetHitters()
        {
            if (Hitters == null)
                Hitters = new WeakDictionary<Player, int>();
            return Hitters;
        }

        private bool Dead;
        public void Death()
        {
            if (Dead)
                return;
            Dead = true;

            if (Corpse != null)
            {
                Corpse.Parent = this;
                return;
            }

            var enemy = (Parent ?? this).Host;

            if (enemy.World is RealmWorld)
                (enemy.World as RealmWorld).EnemyKilled(enemy, (Parent ?? this).LastHitter);

            var levelUpAssists = 0;
            foreach (var player in enemy.World.Players.Values)
            {
                if (player.DistTo(enemy) > 25)
                    continue;

                var level = player.Level;
                if (player.HasConditionEffect(ConditionEffectIndex.Paused))
                    continue;

                var xp = enemy.ObjectDesc.MaxHP / 10.0f * enemy.ObjectDesc.ExpMultiplier;
                var upperLimit = player.ExperienceGoal * 0.1f;
                if (player.Quest == enemy)
                    upperLimit = player.ExperienceGoal * 0.5f;

                float playerXp;
                if (upperLimit < xp)
                    playerXp = upperLimit;
                else
                    playerXp = xp;

                if (player.Level < 20 && player.XPBoostTime != 0)
                    playerXp *= 1.5f;

                if (enemy.GivesNoXp)
                    playerXp = 0;

                var killer = (Parent ?? this).LastHitter == player;
                if (player.EnemyKilled(enemy, (int)playerXp, killer) && !killer)
                    levelUpAssists++;
            }

            if ((Parent ?? this).LastHitter != null)
                (Parent ?? this).LastHitter.FameCounter.LevelUpAssist(levelUpAssists);
        }

        public Tuple<Player, int>[] GetPlayerData()
        {
            if (Parent != null)
                return Parent.GetPlayerData();
            List<Tuple<Player, int>> dat = new List<Tuple<Player, int>>();

            var hitters = GetHitters();
            foreach (var i in hitters)
            {
                if (i.Key == null || i.Key.World == null || i.Key.World.GetEntity(i.Key.Id) == null) continue;

                dat.Add(new Tuple<Player, int>(i.Key, i.Value));
            }
            return dat.ToArray();
        }

        public void HitBy(Player player, int dmg)
        {
            var hitters = GetHitters();
            if (!hitters.TryGetValue(player, out int totalDmg))
                totalDmg = 0;

            int trueDmg = Math.Min(dmg, Host.MaxHealth);
            TotalDamage += trueDmg;
            hitters[player] = totalDmg + trueDmg;

            LastHitter = player;

            player.FameCounter.Hit();
        }

        public void TransferData(DamageCounter dc)
        {
            dc.LastHitter = LastHitter;
            dc.TotalDamage = TotalDamage;

            var hitters = GetHitters();
            foreach (var plr in hitters.Keys)
            {
                if (!hitters.TryGetValue(plr, out var totalDmg))
                    totalDmg = 0;

                var dch = dc.GetHitters();
                if (!dch.TryGetValue(plr, out int totalExistingDmg))
                    totalExistingDmg = 0;
                dch[plr] = totalDmg + totalExistingDmg;
            }
        }
    }
}
