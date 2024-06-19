using Shared;
using Shared.resources;
using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.core.worlds.impl;
using WorldServer.networking;

namespace WorldServer.core.net.handlers
{
    public class UsePortalHandler : IMessageHandler
    {
        private const string PORTAL_TO_NEXUS = "Portal To Nexus";
        private const string TOMB_PORTAL_OF_COWARDICE = "Tomb Portal of Cowardice";
        private const string PORTAL_OF_COWARDICE = "Portal of Cowardice";
        private const string GLOWING_PORTAL_OF_COWARDICE = "Glowing Portal of Cowardice";
        private const string RANDOM_REALM_PORTAL = "Random Realm Portal";
        private const string REALM_PORTAL = "Realm Portal";
        private const string GLOWING_REALM_PORTAL = "Glowing Realm Portal";
        private const string ARENA_PORTAL = "Arena Portal";

        public override MessageId MessageId => MessageId.USEPORTAL;

        public override void Handle(Client client, NetworkReader rdr, ref TickTime time)
        {
            var player = client.Player;
            if (player == null || player?.World == null || client?.Player?.World is TestWorld)
                return;

            var objectId = rdr.ReadInt32();

            var portal = player.World.GetEntity(objectId) as Portal;
            if (portal == null)
                return;

            World world;
            string dungeonName;

            if (portal.GuildHallPortal)
            {
                if (string.IsNullOrEmpty(player.Guild))
                {
                    player.SendError("You are not in a guild.");
                    return;
                }

                var manager = player.Client.GameServer;
                var guildId = player.Client.Account.GuildId;

                world = manager.WorldManager.GetGuild(guildId);
                if (world == null)
                {
                    var guild = player.Client.GameServer.Database.GetGuild(guildId);

                    // this is mandatory
                    dungeonName = $"{portal.PortalDescr.DungeonName} {guild.Level + 1}";

                    world = manager.WorldManager.CreateNewWorld(dungeonName, null, player.World);
                    if (world != null)
                        manager.WorldManager.AddGuildInstance(guildId, world);
                }

                if (world != null)
                    player.Reconnect(world);
                else
                    player.SendInfo("[Bug] Unable to Create Guild.");
                return;
            }

            if (!portal.Usable)
            {
                player.SendInfo("Portal is unusable!");
                return;
            }

            world = portal.WorldInstance;
            if (world == null)
            {
                switch (portal.ObjectDesc.IdName)
                {
                    case PORTAL_TO_NEXUS:
                        world = player.GameServer.WorldManager.Nexus;
                        player.Reconnect(world);
                        break;
                    case ARENA_PORTAL:
                        world = player.GameServer.WorldManager.Arena;
                        if (world == null)
                            world = player.GameServer.WorldManager.Nexus;
                        player.Reconnect(world);
                        break;
                    case TOMB_PORTAL_OF_COWARDICE:
                    case PORTAL_OF_COWARDICE:
                    case GLOWING_PORTAL_OF_COWARDICE:
                    case RANDOM_REALM_PORTAL:
                    case REALM_PORTAL:
                    case GLOWING_REALM_PORTAL:
                        world = player.GameServer.WorldManager.GetRandomRealm();
                        if (world == null)
                            world = player.GameServer.WorldManager.Nexus;
                        player.Reconnect(world);
                        break;
                }

                if (world != null)
                    return;
            }

            if (world != null)
            {
                if (world.IsPlayersMax())
                {
                    player.SendError("Dungeon is full.");
                    return;
                }

                if (world is RealmWorld && !player.GameServer.Resources.GameData.ObjectTypeToId[portal.ObjectDesc.ObjectType].Contains("Cowardice"))
                    player.FameCounter.CompleteDungeon(player.World.IdName);

                player.Reconnect(world);
                return;
            }

            dungeonName = portal.PortalDescr.DungeonName;

            world = portal.GameServer.WorldManager.CreateNewWorld(dungeonName, null, player.World);
            if (world == null)
            {
                player.SendError($"[Bug] Unable to create: {dungeonName}");
                return;
            }

            if (world.IdName == "Trial of Souls")
            {
                if (player.Client.Character.CompletedTrialOfSouls)
                {
                    player.SendError($"You have already completed the trial of souls");
                    return;
                }

                if (player.GetMaxedStats() != 8)
                {
                    player.SendError($"You must be 8/8 to enter this dungeon");
                    return;
                }
            }

            if (world.InstanceType == WorldResourceInstanceType.Vault)
                (world as VaultWorld).SetOwner(player.AccountId);
            else if (!world.CreateInstance)
                portal.WorldInstance = world;
            player.Reconnect(world);

            if (player.Pet != null)
                player.World.LeaveWorld(player.Pet);
        }
    }
}
