namespace WorldServer.core.objects.player.data
{
    public enum PlayerShootStatus
    {
        OK,
        ITEM_MISMATCH,
        COOLDOWN_STILL_ACTIVE,
        NUM_PROJECTILE_MISMATCH,
        CLIENT_TOO_SLOW,
        CLIENT_TOO_FAST
    }
}
