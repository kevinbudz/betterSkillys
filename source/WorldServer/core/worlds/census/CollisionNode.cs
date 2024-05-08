namespace WorldServer.core.worlds.census
{
    public class CollisionNode<T> where T : ICollidable<T>
    {
        /*  Bit field:
         *  0  - 7  X coordinate of chunk
         *  8  - 15 Y coordinate of chunk
         *  16 - 23 Collision Map Type
         *
         */
        public int Data;
        public CollisionNode<T> Next;
        public ICollidable<T> Parent;
        public CollisionNode<T> Previous;

        public void InsertAfter(CollisionNode<T> node)
        {
            if (Next != null)
            {
                node.Next = Next;
                Next.Previous = node;
            }
            else
                node.Next = null;

            node.Previous = this;
            Next = node;
        }

        public CollisionNode<T> Remove()
        {
            CollisionNode<T> ret = null;

            if (Previous != null)
            {
                ret = Previous;
                Previous.Next = Next;
            }

            if (Next != null)
            {
                ret = Next;
                Next.Previous = Previous;
            }

            Previous = null;
            Next = null;

            return ret;
        }
    }
}
