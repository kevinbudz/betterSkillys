using System.Collections.Generic;

namespace Shared
{
    // Compares objects of the given type or WeakKeyReferences to them
    // for equality based on the given comparer. Note that we can only
    // implement IEqualityComparer<T> for T = object as there is no
    // other common base between T and WeakKeyReference<T>. We need a
    // single comparer to handle both types because we don't want to
    // allocate a new weak reference for every lookup.
    internal sealed class WeakKeyComparer<T> : IEqualityComparer<object> where T : class
    {
        private readonly IEqualityComparer<T> comparer;

        internal WeakKeyComparer(IEqualityComparer<T> comparer)
        {
            if (comparer == null) comparer = EqualityComparer<T>.Default;

            this.comparer = comparer;
        }

        // Note: There are actually 9 cases to handle here.
        //
        //  Let Wa = Alive Weak Reference
        //  Let Wd = Dead Weak Reference
        //  Let S  = Strong Reference
        //
        //  x  | y  | Equals(x,y)
        // -------------------------------------------------
        //  Wa | Wa | comparer.Equals(x.Target, y.Target)
        //  Wa | Wd | false
        //  Wa | S  | comparer.Equals(x.Target, y)
        //  Wd | Wa | false
        //  Wd | Wd | x == y
        //  Wd | S  | false
        //  S  | Wa | comparer.Equals(x, y.Target)
        //  S  | Wd | false
        //  S  | S  | comparer.Equals(x, y)
        // -------------------------------------------------
        public new bool Equals(object x, object y)
        {
            T first = GetTarget(x, out bool xIsDead);
            T second = GetTarget(y, out bool yIsDead);

            if (xIsDead) return yIsDead ? x == y : false;

            if (yIsDead) return false;

            return comparer.Equals(first, second);
        }

        public int GetHashCode(object obj)
        {
            if (obj is WeakKeyReference<T> weakKey) return weakKey.HashCode;

            return comparer.GetHashCode((T)obj);
        }

        private static T GetTarget(object obj, out bool isDead)
        {
            T target;

            if (obj is WeakKeyReference<T> wref)
            {
                target = wref.Target;
                isDead = !wref.IsAlive;
            }
            else
            {
                target = (T)obj;
                isDead = false;
            }

            return target;
        }
    }
}
