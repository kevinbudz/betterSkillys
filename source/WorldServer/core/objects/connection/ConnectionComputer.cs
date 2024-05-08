using System;

namespace WorldServer.core.objects.connection
{
    public static class ConnectionComputer
    {
        public static ConnectedObjectInfo Compute(Func<int, int, bool> offset)
        {
            var z = new bool[3, 3];

            for (int y = -1; y <= 1; y++)
                for (int x = -1; x <= 1; x++)
                    z[x + 1, y + 1] = offset(x, y);

            if (z[1, 0] && z[1, 2] && z[0, 1] && z[2, 1])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.Cross, 0)];
            else if (z[0, 1] && z[1, 1] && z[2, 1] && z[1, 0])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.T, 0)];
            else if (z[1, 0] && z[1, 1] && z[1, 2] && z[2, 1])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.T, 90)];
            else if (z[0, 1] && z[1, 1] && z[2, 1] && z[1, 2])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.T, 180)];
            else if (z[1, 0] && z[1, 1] && z[1, 2] && z[0, 1])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.T, 270)];
            else if (z[0, 1] && z[1, 1] && z[2, 1])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.Line, 90)];
            else if (z[1, 0] && z[1, 1] && z[1, 2])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.Line, 0)];
            else if (z[1, 0] && z[2, 1])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.L, 0)];
            else if (z[2, 1] && z[1, 2])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.L, 90)];
            else if (z[1, 2] && z[0, 1])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.L, 180)];
            else if (z[0, 1] && z[1, 0])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.L, 270)];
            else if (z[1, 0])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.ShortLine, 0)];
            else if (z[2, 1])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.ShortLine, 90)];
            else if (z[1, 2])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.ShortLine, 180)];
            else if (z[0, 1])
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.ShortLine, 270)];
            else
                return ConnectedObjectInfo.Infos2[Tuple.Create(ConnectionType.Dot, 0)];
        }

        public static string GetConnString(Func<int, int, bool> offset) => $"conn:{Compute(offset).Bits}";
    }
}
