using System;

namespace WorldServer.logic
{
    internal struct Cooldown
    {
        public int CoolDown;
        public int Variance;

        public Cooldown(int cooldown, int variance)
        {
            CoolDown = cooldown;
            Variance = variance;
        }

        public Cooldown Normalize()
        {
            if (CoolDown == 0)
                return 1000;
            else
                return this;
        }

        public Cooldown Zero() => CoolDown == 0 ? (Cooldown)(-1) : this;

        public Cooldown Normalize(int def) => CoolDown == 0 ? (Cooldown)def : this;

        public int Next(Random rand)
        {
            if (Variance == 0)
                return CoolDown;
            return CoolDown + rand.Next(-Variance, Variance + 1);
        }

        public static implicit operator Cooldown(int cooldown) => new Cooldown(cooldown, 0);
    }
}
