using System.ComponentModel;

namespace WorldServer.core.objects.vendors
{
    public enum BuyResult
    {
        [Description("Player's with a Higher rank can't buy player items.")]
        Admin,

        [Description("Purchase successful.")]
        Ok,

        [Description("Cannot purchase items with a guest account.")]
        IsGuest,

        [Description("Insufficient Rank.")]
        InsufficientRank,

        [Description("Insufficient Funds.")]
        InsufficientFunds,

        [Description("Can't buy items on a test map.")]
        IsTestMap,

        [Description("Uninitalized.")]
        Uninitialized,

        [Description("Transaction failed.")]
        TransactionFailed,

        [Description("Item is currently being purchased.")]
        BeingPurchased,

        [Description("You don't have enough inventory slots.")]
        NotEnoughSlots
    }
}
