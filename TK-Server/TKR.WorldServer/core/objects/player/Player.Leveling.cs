using System;
using TKR.Shared.resources;
using TKR.WorldServer.core.net.datas;
using TKR.WorldServer.core.net.stats;
using TKR.WorldServer.core.worlds;
using TKR.WorldServer.core.worlds.impl;
using TKR.WorldServer.networking;
using TKR.WorldServer.networking.packets.outgoing;

namespace TKR.WorldServer.core.objects
{
    public partial class Player
    {
        public Entity Quest { get; private set; }

        public static int GetExpGoal(int level) => 50 + (level - 1) * 100;
        public static int GetFameGoal(int fame)
        {
            if (fame >= 2000) return 0;
            if (fame >= 800) return 2000;
            if (fame >= 400) return 800;
            if (fame >= 150) return 400;
            if (fame >= 20) return 150;
            return 20;
        }

        public static int GetLevelExp(int level)
        {
            if (level == 1)
                return 0;
            return 50 * (level - 1) + (level - 2) * (level - 1) * 50;
        }

        public void CalculateFame()
        {
            var newFame = (Experience < 200 * 1000) ? Experience / 1000 : 200 + (Experience - 200 * 1000) / 1000;

            if (newFame == Fame)
                return;

            var Stats = FameCounter.ClassStats[ObjectType];
            var newGoal = GetFameGoal(Stats.BestFame > newFame ? Stats.BestFame : newFame);

            if (newGoal > FameGoal)
            {
                World.BroadcastIfVisible(new Notification()
                {
                    ObjectId = Id,
                    Color = new ARGB(0xFF00FF00),
                    Message = "Quest Complete!"
                }, this);
                var prevStars = Stars;
                Stars = GetStars();
            }
            else if (newFame != Fame)
            {
                var delta = (newFame - Fame);
                if (delta > 0)
                {
                    World.BroadcastIfVisible(new Notification()
                    {
                        ObjectId = Id,
                        Color = new ARGB(0xFFE25F00),
                        Message = $"+{delta} Fame"
                    }, this);
                }
            }

            Fame = newFame;
            FameGoal = newGoal;
        }

        public bool EnemyKilled(Enemy enemy, int exp, bool killer)
        {
            if (enemy == Quest)
            {
                World.BroadcastIfVisible(new Notification()
                {
                    ObjectId = Id,
                    Color = new ARGB(0xFF00FF00),
                    Message = "Quest Complete!"
                }, this);
                Quest = null;
            }

            if (exp != 0)
            {
                Experience += exp;
            }

            FameCounter.Killed(enemy, killer);
            return CheckLevelUp();
        }

        public int GetStars()
        {
            int ret = 0;
            foreach (var i in FameCounter.ClassStats.AllKeys)
            {
                var entry = FameCounter.ClassStats[ushort.Parse(i)];
                if (entry.BestFame >= 2000) ret += 5;
                else if (entry.BestFame >= 800) ret += 4;
                else if (entry.BestFame >= 400) ret += 3;
                else if (entry.BestFame >= 150) ret += 2;
                else if (entry.BestFame >= 20) ret += 1;
            }
            return ret;
        }

        public void HandleQuest(TickTime time)
        {
            if (Quest != null && Quest.Dead)
                Quest = null;

            if (Quest == null || time.TickCount % 10 == 0)
            {
                var newQuest = FindQuest();
                if (newQuest != null && newQuest != Quest)
                {
                    Client.SendPacket(new QuestObjId()
                    {
                        ObjectId = newQuest.Id
                    });
                    Quest = newQuest;
                }
            }
        }

        private bool CheckLevelUp()
        {
            var statInfo = GameServer.Resources.GameData.Classes[ObjectType].Stats;
            if (Experience - GetLevelExp(Level) >= ExperienceGoal && Level < 20)
            {
                Level++;
                ExperienceGoal = GetExpGoal(Level);
                for (var i = 0; i < statInfo.Length; i++)
                {
                    if (Level < 20)
                    {
                        switch (UpgradeEnabled)
                        {
                            case true:
                                if (i == 0 || i == 1 ? Stats.Base[i] >= statInfo[i].MaxValue + 50 : Stats.Base[i] >= statInfo[i].MaxValue + 10)
                                    Stats.Base[i] = (i == 0 || i == 1) ? statInfo[i].MaxValue + 50 : statInfo[i].MaxValue + 10;
                                break;

                            case false:
                                if (Stats.Base[i] >= statInfo[i].MaxValue)
                                    Stats.Base[i] = statInfo[i].MaxValue;
                                break;
                        }
                    }
                    var min = statInfo[i].MinIncrease;
                    var max = statInfo[i].MaxIncrease + 1;
                    Stats.Base[i] += Random.Shared.Next(min, max);
                    if (Stats.Base[i] > statInfo[i].MaxValue && !UpgradeEnabled)
                        Stats.Base[i] = statInfo[i].MaxValue;
                }
                HP = Stats[0];
                MP = Stats[1];

                if (Level == 20)
                    World.ForeachPlayer(_ => _.SendInfo($"{Name} achieved level 20"));
                else
                    // to get exp scaled to new exp goal
                    InvokeStatChange(StatDataType.Experience, Experience - GetLevelExp(Level), true);

                Quest = null;
                return true;
            }

            for (var i = 0; i < statInfo.Length; i++)
            {
                if (Level >= 20)
                {
                    switch (UpgradeEnabled)
                    {
                        case true:
                            if (i == 0 || i == 1 ? Stats.Base[i] >= statInfo[i].MaxValue + 50 : Stats.Base[i] >= statInfo[i].MaxValue + 10)
                                Stats.Base[i] = (i == 0 || i == 1) ? statInfo[i].MaxValue + 50 : statInfo[i].MaxValue + 10;
                            break;

                        case false:
                            if (Stats.Base[i] >= statInfo[i].MaxValue)
                                Stats.Base[i] = statInfo[i].MaxValue;
                            break;
                    }
                }
            }

            CalculateFame();
            return false;
        }

        private Entity FindQuest()
        {
            Entity ret = null;
            double bestScore = 0.0;
            foreach (var entry in World.Quests)
            {
                var quest = entry.Value;
                if (quest.ObjectDesc == null || !quest.ObjectDesc.Quest)
                    continue;

                var maxVisibleLevel = Math.Min(quest.ObjectDesc.Level + 5, 20);
                var minVisibleLevel = Math.Max(quest.ObjectDesc.Level - 5, 1);
                var force = false;
                if (!(quest.World is RealmWorld) && quest.ObjectDesc.Quest && !quest.ObjectDesc.Hero)
                    force = true;

                if (Level >= minVisibleLevel && Level <= maxVisibleLevel || force)
                {
                    var priority = quest.ObjectDesc.Encounter ? 3 : quest.ObjectDesc.Hero ? 2 : 1;
                    var score =
                        //priority * level diff
                        (20 - Math.Abs(quest.ObjectDesc.Level - Level)) * priority -
                        //minus 1 for every 100 tile distance
                        this.DistTo(quest) / 100;

                    if (score > bestScore)
                    {
                        bestScore = score;
                        ret = quest;
                    }
                }
            }
            return ret;
        }
    }
}
