using Shared.database.character;
using Shared.resources;
using WorldServer.core.objects.inventory;

namespace WorldServer.core.objects
{
    partial class Player
    {
        public PotionStack[] PotionStacks { get; private set; }
        public PotionStack HealthPotionStack { get; private set; }
        public PotionStack MagicPotionStack { get; private set; }

        public void InitializePotionStacks(DbChar character, AppSettings settings)
        {
            HealthPotionStack = new PotionStack(this, 254, 0x0A22, count: character.HealthStackCount, settings.MaxStackablePotions);
            MagicPotionStack = new PotionStack(this, 255, 0x0A23, count: character.MagicStackCount, settings.MaxStackablePotions);
            PotionStacks = [HealthPotionStack, MagicPotionStack];
        }
    }
}
