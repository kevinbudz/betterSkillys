using System;
using System.Collections.Generic;

namespace TKRShared
{
    public abstract partial class BaseDictionary<TKey, TValue>
    {
        private abstract class Collection<T> : ICollection<T>
        {
            protected IDictionary<TKey, TValue> dictionary;

            protected Collection(IDictionary<TKey, TValue> dictionary) => this.dictionary = dictionary;

            public int Count => dictionary.Count;

            public bool IsReadOnly => true;

            public void Add(T item) => throw new NotSupportedException("Collection is read-only.");

            public void Clear() => throw new NotSupportedException("Collection is read-only.");

            public virtual bool Contains(T item)
            {
                foreach (T element in this)
                    if (EqualityComparer<T>.Default.Equals(element, item))
                        return true;

                return false;
            }

            public void CopyTo(T[] array, int arrayIndex) => Copy(this, array, arrayIndex);

            public IEnumerator<T> GetEnumerator()
            {
                foreach (KeyValuePair<TKey, TValue> pair in dictionary)
                    yield return GetItem(pair);
            }

            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => GetEnumerator();

            public bool Remove(T item) => throw new NotSupportedException("Collection is read-only.");

            protected abstract T GetItem(KeyValuePair<TKey, TValue> pair);
        }
    }
}
