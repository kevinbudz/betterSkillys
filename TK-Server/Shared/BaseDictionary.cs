using System;
using System.Collections.Generic;
using System.Diagnostics;

namespace TKRShared
{
    /// <summary>
    /// Represents a dictionary mapping keys to values.
    /// </summary>
    ///
    /// <remarks>
    /// Provides the plumbing for the portions of IDictionary<TKey,
    /// TValue> which can reasonably be implemented without any
    /// dependency on the underlying representation of the dictionary.
    /// </remarks>
    [DebuggerDisplay("Count = {Count}")]
    [DebuggerTypeProxy(PREFIX + "DictionaryDebugView`2" + SUFFIX)]
    public abstract partial class BaseDictionary<TKey, TValue> : IDictionary<TKey, TValue>
    {
        private const string PREFIX = "System.Collections.Generic.Mscorlib_";
        private const string SUFFIX = ",mscorlib,Version=2.0.0.0,Culture=neutral,PublicKeyToken=b77a5c561934e089";

        private KeyCollection keys;
        private ValueCollection values;

        protected BaseDictionary()
        { }

        public abstract int Count { get; }

        public bool IsReadOnly => false;

        public ICollection<TKey> Keys
        {
            get
            {
                if (keys == null) keys = new KeyCollection(this);

                return keys;
            }
        }

        public ICollection<TValue> Values
        {
            get
            {
                if (values == null) values = new ValueCollection(this);

                return values;
            }
        }

        public TValue this[TKey key]
        {
            get
            {
                if (!TryGetValue(key, out TValue value)) throw new KeyNotFoundException();

                return value;
            }
            set => SetValue(key, value);
        }

        public abstract void Add(TKey key, TValue value);

        public void Add(KeyValuePair<TKey, TValue> item) => Add(item.Key, item.Value);

        public abstract void Clear();

        public bool Contains(KeyValuePair<TKey, TValue> item)
        {
            if (!TryGetValue(item.Key, out TValue value)) return false;

            return EqualityComparer<TValue>.Default.Equals(value, item.Value);
        }

        public abstract bool ContainsKey(TKey key);

        public void CopyTo(KeyValuePair<TKey, TValue>[] array, int arrayIndex) => Copy(this, array, arrayIndex);

        public abstract IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator();

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => GetEnumerator();

        public abstract bool Remove(TKey key);

        public bool Remove(KeyValuePair<TKey, TValue> item)
        {
            if (!Contains(item)) return false;

            return Remove(item.Key);
        }

        public abstract bool TryGetValue(TKey key, out TValue value);

        protected abstract void SetValue(TKey key, TValue value);

        private static void Copy<T>(ICollection<T> source, T[] array, int arrayIndex)
        {
            if (array == null) throw new ArgumentNullException("array");

            if (arrayIndex < 0 || arrayIndex > array.Length) throw new ArgumentOutOfRangeException("arrayIndex");

            if ((array.Length - arrayIndex) < source.Count)
                throw new ArgumentException("Destination array is not large enough. Check array.Length and arrayIndex.");

            foreach (T item in source) array[arrayIndex++] = item;
        }
    }
}
