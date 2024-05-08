using System;
using System.Collections.Generic;
using WorldServer.core;
using WorldServer.core.commands;
using WorldServer.core.objects;
using WorldServer.core.worlds;

namespace WorldServer.core.commands
{
    public class CommandManager
    {
        private readonly Dictionary<string, Command> _cmds = new Dictionary<string, Command>(StringComparer.InvariantCultureIgnoreCase);

        public void Initialize(GameServer gameServer)
        {
            var type = typeof(Command);
            var types = type.Assembly.GetTypes();

            for (var i = 0; i < types.Length; i++)
                if (type.IsAssignableFrom(types[i]) && types[i] != type)
                {
                    var instance = types[i].GetConstructor(new Type[] { typeof(GameServer) }) == null ? (Command)Activator.CreateInstance(types[i]) : (Command)Activator.CreateInstance(types[i], gameServer);

                    //if (blacklistedCmds.Contains(instance.CommandName.ToLower()))
                    //    continue;

                    _cmds.Add(instance.CommandName, instance);

                    if (instance.Alias != null)
                        _cmds.Add(instance.Alias, instance);
                }
        }

        public IDictionary<string, Command> Commands => _cmds;

        public bool Execute(Player player, TickTime time, string text)
        {
            var index = text.IndexOf(' ');
            var cmd = text.Substring(1, index == -1 ? text.Length - 1 : index - 1);
            var args = index == -1 ? "" : text.Substring(index + 1);

            if (!_cmds.TryGetValue(cmd, out Command command))
            {
                player.SendInfo($"Unknown command: /{cmd}");
                return false;
            }

            return command.Execute(player, time, args);
        }
    }
}
