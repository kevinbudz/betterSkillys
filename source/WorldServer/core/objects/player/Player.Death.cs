using Shared.database.party;
using Shared.resources;
using System.Linq;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking;
using WorldServer.networking.packets.outgoing;

namespace WorldServer.core.objects
{
    public partial class Player
    {
        private void AnnounceDeath(string killer)
        {
            var maxed = GetMaxedStats();
            var deathMessage = $"{Name} ({maxed}/8, {Client.Character.Fame}) has been killed by {killer}!";

            if (maxed >= 6 || Fame >= 1000)
            {
                var worlds = GameServer.WorldManager.GetWorlds();
                foreach (var world in worlds)
                    world.ForeachPlayer(_ => _.DeathNotif(deathMessage));
                return;
            }

            var pGuild = Client.Account.GuildId;

            // guild case, only for level 20
            if (pGuild > 0 && Level == 20)
            {
                var worlds = GameServer.WorldManager.GetWorlds();
                foreach (var world in worlds)
                    world.ForeachPlayer(_ =>
                    {
                        if (_.Client.Account.GuildId == pGuild)
                            _.DeathNotif(deathMessage);
                    });

                World.ForeachPlayer(_ =>
                {
                    if (_.Client.Account.GuildId != pGuild)
                        _.DeathNotif(deathMessage);
                });
            }
            else
                // guild less case
                World.ForeachPlayer(_ => _.DeathNotif(deathMessage));
        }

        private void GenerateGravestone(bool phantomDeath = false)
        {
            var playerDesc = GameServer.Resources.GameData.Classes[ObjectType];

            var maxed = playerDesc.Stats.Where((t, i) => Stats.Base[i] >= t.MaxValue).Count();

            ushort objType;
            int? time = null;
            switch (maxed)
            {
                case 8: objType = 0x073d; break;
                case 7: objType = 0x073c; break;
                case 6: objType = 0x072b; break;
                case 5: objType = 0x072a; break;
                case 4: objType = 0x0729; break;
                case 3: objType = 0x0728; break;
                case 2: objType = 0x0727; break;
                case 1: objType = 0x0726; break;
                default:
                    objType = 0x0725;
                    time = 300000;
                    if (Level < 20)
                    {
                        objType = 0x0724;
                        time = 60000;
                    }
                    if (Level <= 1)
                    {
                        objType = 0x0723;
                        time = 30000;
                    }
                    break;
            }

            var deathMessage = Name + " (" + maxed + "/8, " + Client.Character.Fame + ")";

            var obj = new StaticObject(GameServer, objType, time, true, true, false);
            obj.Move(X, Y);
            obj.Name = (!phantomDeath) ? deathMessage : $"{Name} got rekt";
            World.EnterWorld(obj);
        }

        public void Death(string killer, bool rekt = false)
        {
            if (Client.State == ProtocolState.Disconnected || Dead)
                return;
            Dead = true;

            if (HandleTestWorld())
                return;
            
            if (rekt)
            {
                GenerateGravestone(true);
                ReconnectToNexus();
                return;
            }

            if (TryResurrect())
            {
                ReconnectToNexus();
                return;
            }

            SaveToCharacter();
            GameServer.Database.Death(GameServer.Resources.GameData, Client.Account, Client.Character, FameCounter.Stats, killer);

            GenerateGravestone();
            AnnounceDeath(killer);

            Client.SendPacket(new DeathMessage(AccountId, Client.Character.CharId, killer));
            Client.Disconnect("Death");
        }

        private bool HandleTestWorld()
        {
            if (World is not TestWorld)
                return false;
            GenerateGravestone();
            ReconnectToNexus();
            return true;
        }

        private void ReconnectToNexus()
        {
            Health = Stats[0];
            Mana = Stats[1];

            Client.Reconnect(new Reconnect()
            {
                Host = "",
                Port = GameServer.Configuration.serverInfo.port,
                GameId = World.NEXUS_ID,
                Name = "Nexus"
            });

            var party = DbPartySystem.Get(Client.Account.Database, Client.Account.PartyId);
            if (party != null && party.PartyLeader.Item1 == Client.Account.Name && party.PartyLeader.Item2 == Client.Account.AccountId)
                party.WorldId = -1;
        }

        private bool TryResurrect()
        {
            for (int slot = 0; slot < 4; slot++)
            {
                var item = Inventory[slot];
                if (item == null || !item.Resurrects)
                    continue;
                Inventory[slot] = null;
                World.ForeachPlayer(_ => _.SendInfo($"{Name}'s {item.DisplayName} breaks and he disappears"));
                return true;
            }
            return false;
        }
    }
}
