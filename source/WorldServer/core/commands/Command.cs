using Shared;
using System;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public abstract partial class Command
    {
        public virtual RankingType RankRequirement => RankingType.Regular;
        public virtual string Alias { get; }
        public abstract string CommandName { get; }
        public virtual bool ListAsCommand => RankRequirement != RankingType.Admin;

        public bool Execute(Player player, TickTime time, string args)
        {
            if (!HasPermission(player))
            {
                player.SendError("You dont have the required permission to use this command!");
                return false;
            }

            try
            {
                return Process(player, time, args);
            }
            catch (Exception e)
            {
                Console.WriteLine($"{player.Name} | Error when executing the command: {CommandName}", e);
                return false;
            }
        }

        public bool HasPermission(Player player)
        {
            if (player.GameServer.Configuration.serverInfo.testing && (CommandName == "give" || CommandName == "spawn" || CommandName == "max"))
                return true; 
            
            var rank = player.Client.Account.Rank;
            if (player.Client.Account.Admin)
                return true;
            if (RankRequirement == RankingType.Moderator)
                return player.Client.Account.Rank >= (int)RankingType.Moderator;
            return rank >= (int)RankRequirement;
        }

        protected abstract bool Process(Player player, TickTime time, string args);
    }
}
