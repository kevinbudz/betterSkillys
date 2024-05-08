using TKRShared;
using System;
using System.Collections.Generic;

namespace Shared
{
    public sealed class WeakDictionary<TKey, TValue> : BaseDictionary<TKey, TValue> where TKey : class
    {
        private WeakKeyComparer<TKey> comparer;
        private Dictionary<object, TValue> dictionary;

        public WeakDictionary() : this(0, null)
        { }

        public WeakDictionary(int capacity) : this(capacity, null)
        { }

        public WeakDictionary(IEqualityComparer<TKey> comparer) : this(0, comparer)
        { }

        public WeakDictionary(int capacity, IEqualityComparer<TKey> comparer)
        {
            this.comparer = new WeakKeyComparer<TKey>(comparer);

            dictionary = new Dictionary<object, TValue>(capacity, this.comparer);
        }

        // WARNING: The count returned here may include entries for which
        // either the key or value objects have already been garbage
        // collected. Call RemoveCollectedEntries to weed out collected
        // entries and update the count accordingly.
        public override int Count => dictionary.Count;

        public override void Add(TKey key, TValue value)
        {
            if (key == null) throw new ArgumentNullException("key");

            var weakKey = new WeakKeyReference<TKey>(key, comparer);

            dictionary.Add(weakKey, value);
        }

        public override void Clear() => dictionary.Clear();

        public override bool ContainsKey(TKey key) => dictionary.ContainsKey(key);

        public override IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator()
        {
            foreach (KeyValuePair<object, TValue> kvp in dictionary)
            {
                var weakKey = (WeakReference<TKey>)kvp.Key;
                var value = kvp.Value;
                var key = weakKey.Target;

                if (weakKey.IsAlive) yield return new KeyValuePair<TKey, TValue>(key, value);
            }
        }

        public override bool Remove(TKey key) => dictionary.Remove(key);

        // Removes the left-over weak references for entries in the dictionary
        // whose key or value has already been reclaimed by the garbage
        // collector. This will reduce the dictionary's Count by the number
        // of dead key-value pairs that were eliminated.
        public void RemoveCollectedEntries()
        {
            var toRemove = new List<object>();

            foreach (KeyValuePair<object, TValue> pair in dictionary)
            {
                var weakKey = (WeakReference<TKey>)pair.Key;

                if (!weakKey.IsAlive) toRemove.Add(weakKey);
            }

            if (toRemove != null)
                foreach (object key in toRemove) dictionary.Remove(key);
        }

        public override bool TryGetValue(TKey key, out TValue value)
        {
            if (dictionary.TryGetValue(key, out TValue weakValue))
            {
                value = weakValue;
                return true;
            }

            value = default;
            return false;
        }

        protected override void SetValue(TKey key, TValue value)
        {
            var weakKey = new WeakKeyReference<TKey>(key, comparer);

            dictionary[weakKey] = value;
        }
    }
}
