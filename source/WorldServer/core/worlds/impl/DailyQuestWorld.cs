using Shared;
using Shared.resources;
using System;
using System.Collections.Generic;
using System.Linq;
using WorldServer.core.objects.vendors;
using WorldServer.core.structures;

namespace WorldServer.core.worlds.impl
{
    public sealed class DailyQuestWorld : World
    {
        public DailyQuestWorld(GameServer gameServer, int id, WorldResource resource)
            : base(gameServer, id, resource)
        {
        }

        public override void Init()
        {
        }

        protected override void UpdateLogic(ref TickTime time)
        {
        }
    }
}
