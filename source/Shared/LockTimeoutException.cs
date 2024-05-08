// code from: http://www.interact-sw.co.uk/iangblog/2004/04/26/yetmoretimedlocking

using System;

public class LockTimeoutException : ApplicationException
{
    public LockTimeoutException() : base("Timeout waiting for lock")
    { }
}
