using System.Collections.Generic;
using System.Diagnostics;

namespace TKRShared
{
    public abstract partial class BaseDictionary<TKey, TValue>
    {
        [DebuggerDisplay("Count = {Count}")]
        [DebuggerTypeProxy(PREFIX + "DictionaryKeyCollectionDebugView`2" + SUFFIX)]
        private class KeyCollection : Collection<TKey>
        {
            public KeyCollection(IDictionary<TKey, TValue> dictionary) : base(dictionary)
            { }

            public override bool Contains(TKey item) => dictionary.ContainsKey(item);

            protected override TKey GetItem(KeyValuePair<TKey, TValue> pair) => pair.Key;
        }
    }
}
