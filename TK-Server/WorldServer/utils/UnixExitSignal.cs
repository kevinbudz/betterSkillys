//using Mono.Unix;
using System.Threading.Tasks;

namespace WorldServer.utils
{
    //public sealed class UnixExitSignal
    //{
    //    public delegate void UnixExitDelegate();

    //    public event UnixExitDelegate Exit;

    //    private static UnixSignal[] signals = new UnixSignal[]
    //    {
    //        new UnixSignal(Mono.Unix.Native.Signum.SIGTERM),
    //        new UnixSignal(Mono.Unix.Native.Signum.SIGINT),
    //        new UnixSignal(Mono.Unix.Native.Signum.SIGUSR1)
    //    };

    //    public UnixExitSignal()
    //    {
    //        Task.Factory.StartNew(() =>
    //        {
    //            var index = UnixSignal.WaitAny(signals, -1);
    //            Exit?.Invoke();
    //        });
    //    }
    //}
}