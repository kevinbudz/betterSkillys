using WorldServer.core.objects;
using WorldServer.core.worlds;
using WorldServer.utils;

namespace WorldServer.logic.behaviors
{
    internal class PetFollow : CycleBehavior
    {
        private enum F
        {
            DontKnowWhere,
            Acquired,
        }

        protected override void TickCore(Entity host, TickTime time, ref object state)
        {
            if ((host as Pet)?.PlayerOwner == null)
            {
                host.World.LeaveWorld(host);
                return;
            }

            var pet = (Pet)host;
            var s = state == null ? new FollowState { State = F.DontKnowWhere, RemainingTime = 1000 } : (FollowState)state;

            Status = CycleStatus.NotStarted;

            if (!(host.World.GetEntity(pet.PlayerOwner.Id) is Player player))
                return;

            Status = CycleStatus.InProgress;

            switch (s.State)
            {
                case F.DontKnowWhere:
                    if (s.RemainingTime > 0)
                        s.RemainingTime -= time.ElapsedMsDelta;
                    else
                        s.State = F.Acquired;
                    break;

                case F.Acquired:
                    if (player == null)
                    {
                        s.State = F.DontKnowWhere;
                        s.RemainingTime = 1000;
                        break;
                    }

                    if (s.RemainingTime > 0)
                        s.RemainingTime -= time.ElapsedMsDelta;

                    var vect = new Vector2(player.X - host.X, player.Y - host.Y);

                    if (vect.Length() > 20)
                        host.Move(player.X, player.Y);
                    else if (vect.Length() > 1)
                    {
                        var dist = host.GetSpeed(0.5f) * time.BehaviourTickTime;
                        if (vect.Length() > 2)
                            dist = host.GetSpeed(0.7f + (float)player.Stats[4] / 100) * time.BehaviourTickTime;
                        vect.Normalize();

                        host.ValidateAndMove(host.X + vect.X * dist, host.Y + vect.Y * dist);
                    }

                    break;
            }

            state = s;
        }

        private class FollowState
        {
            public int RemainingTime;
            public F State;
        }
    }
}
