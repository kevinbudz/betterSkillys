using System;

namespace Shared.database
{
    [Flags]
    public enum DbRegisterStatus
    {
        OK,
        UsedName,
    }

    [Flags]
    public enum DbLoginStatus
    {
        OK,
        AccountNotExists,
        InvalidCredentials
    }

    [Flags]
    public enum AddCharacterStatus
    {
        Ok,
        ReachedLimit,
        SkinUnavailable,
        Locked,
        Error
    }

    [Flags]
    public enum LoginStatus
    {
        Ok,
        AccountNotExists,
        InvalidCredentials
    }

    [Flags]
    public enum DbCreateStatus
    {
        OK,
        ReachCharLimit,
        SkinUnavailable,
        Locked
    }

    [Flags]
    public enum AccountRegisterStatus
    {
        Ok,
        EmailInUse
    }

    [Flags]
    public enum GuildMemberStatus
    {
        Ok,
        NameNotChosen,
        AlreadyIn,
        InAnother,
        AlreadyMember,
        Full
    }
}
