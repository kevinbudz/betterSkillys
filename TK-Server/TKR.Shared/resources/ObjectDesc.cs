using System;
using System.Collections.Generic;
using System.Xml.Linq;

namespace TKR.Shared.resources
{
    public class ObjectDesc
    {
        public readonly bool ArmorBreakImmune;
        public readonly bool BlocksSight;
        public readonly bool CanPutNormalObjects;
        public readonly bool CanPutSoulboundObjects;
        public readonly bool Character;
        public readonly bool Connects;
        public readonly bool Container;
        public readonly bool Cube;
        public readonly bool CurseImmune;
        public readonly bool DazedImmune;
        public readonly int Defense;
        public readonly bool Encounter;
        public readonly bool Enemy;
        public readonly bool EnemyOccupySquare;
        public readonly bool Event;
        public readonly float ExpMultiplier;
        public readonly bool FullOccupy;
        public readonly bool God;
        public readonly bool Hero;
        public readonly bool Invincible;
        public readonly bool isChest;
        public readonly bool KeepDamageRecord;
        public readonly int Level;
        public readonly bool Loot;
        public readonly int MaxHP;
        public readonly int MaxSize;
        public readonly int MinSize;
        public readonly bool NoArticle;
        public readonly ushort ObjectType;
        public readonly bool OccupySquare;
        public readonly bool Oryx;
        public readonly bool ParalyzeImmune;
        public readonly int PerRealmMax;
        public readonly bool PetrifyImmune;
        public readonly bool Player;
        public readonly bool ProtectFromGroundDamage;
        public readonly bool ProtectFromSink;
        public readonly bool Quest;
        public readonly int Size;
        public readonly int SizeStep;
        public readonly int[] SlotTypes;
        public readonly int[] Equipment;
        public readonly bool SlowedImmune;
        public readonly bool SpawnPoint;
        public readonly float SpawnProb;
        public readonly bool StasisImmune;
        public readonly bool Static;
        public readonly bool StunImmune;
        public readonly bool HealthBarBoss;
        public readonly TerrainType Terrain;

        public string Class;
        public string DisplayId;
        public string DisplayName;
        public string Group;
        public string IdName;
        public Dictionary<int, ProjectileDesc> Projectiles = new Dictionary<int, ProjectileDesc>();
        public SpawnCount Spawn;

        public ObjectDesc(ushort type, XElement e)
        {
            ObjectType = type;
            IdName = e.GetAttribute<string>("id");
            DisplayId = e.GetValue<string>("DisplayId");
            DisplayName = string.IsNullOrWhiteSpace(DisplayId) ? IdName : DisplayId;
            Class = e.GetValue<string>("Class");
            Static = e.HasElement("Static");
            Event = e.HasElement("Event");
            OccupySquare = e.HasElement("OccupySquare");
            FullOccupy = e.HasElement("FullOccupy");
            EnemyOccupySquare = e.HasElement("EnemyOccupySquare");
            BlocksSight = e.HasElement("BlocksSight");
            Container = e.HasElement("Container");
            isChest = e.HasElement("Chest");

            if (e.HasElement("SlotTypes"))
                SlotTypes = e.GetValue<string>("SlotTypes").CommaToArray<int>();

            if (e.HasElement("Equipment"))
                Equipment = e.GetValue<string>("Equipment").CommaToArray<int>();

            CanPutNormalObjects = e.HasElement("CanPutNormalObjects");
            CanPutSoulboundObjects = e.HasElement("CanPutSoulboundObjects");
            Loot = e.HasElement("Loot");
            HealthBarBoss = e.HasElement("HealthBarBoss");
            Size = e.GetValue("Size", 100);
            Enemy = e.HasElement("Enemy");
            MaxHP = e.GetValue<int>("MaxHitPoints");
            Defense = e.GetValue<int>("Defense");
            ExpMultiplier = e.GetValue("XpMult", 1.0f);

            if (e.HasElement("MinSize") && e.HasElement("MaxSize"))
            {
                MinSize = e.GetValue<int>("MinSize");
                MaxSize = e.GetValue<int>("MaxSize");
                SizeStep = e.GetValue("SizeStep", 1);
            }
            else
            {
                MinSize = MaxSize = Size;
                SizeStep = 0;
            }

            Character = Class.Equals("Character");
            SpawnPoint = e.HasElement("SpawnPoint");
            Group = e.GetValue<string>("Group");
            Quest = e.HasElement("Quest");
            Level = e.GetValue("Level", 1);
            God = e.HasElement("God");
            NoArticle = e.HasElement("NoArticle");
            Invincible = e.HasElement("Invincible");
            ArmorBreakImmune = e.HasElement("ArmorBreakImmune");
            CurseImmune = e.HasElement("CurseImmune");
            DazedImmune = e.HasElement("DazedImmune");
            ParalyzeImmune = e.HasElement("ParalyzeImmune");
            PetrifyImmune = e.HasElement("PetrifyImmune");
            SlowedImmune = e.HasElement("SlowedImmune");
            StasisImmune = e.HasElement("StasisImmune");
            StunImmune = e.HasElement("StunImmune");
            SpawnProb = e.GetValue<float>("SpawnProb");

            if (e.HasElement("Spawn"))
                Spawn = new SpawnCount(e.Element("Spawn"));

            Terrain = (TerrainType)Enum.Parse(typeof(TerrainType), e.GetValue("Terrain", "None"));
            Encounter = e.HasElement("Encounter");
            PerRealmMax = e.GetValue<int>("PerRealmMax");
            Hero = e.HasElement("Hero");
            Cube = e.HasElement("Cube");
            Oryx = e.HasElement("Oryx");
            Player = e.HasElement("Player");
            KeepDamageRecord = e.HasElement("KeepDamageRecord");
            Connects = e.HasElement("Connects");
            ProtectFromGroundDamage = e.HasElement("ProtectFromGroundDamage");
            ProtectFromSink = e.HasElement("ProtectFromSink");

            foreach (var i in e.Elements("Projectile"))
            {
                var desc = new ProjectileDesc(i);
                Projectiles[desc.BulletType] = desc;
            }
        }
    }
}
