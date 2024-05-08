using System.Collections.Generic;
using System.Diagnostics;

namespace TKRShared
{
    public abstract partial class BaseDictionary<TKey, TValue>
    {
        [DebuggerDisplay("Count = {Count}")]
        [DebuggerTypeProxy(PREFIX + "DictionaryValueCollectionDebugView`2" + SUFFIX)]
        private class ValueCollection : Collection<TValue>
        {
            public ValueCollection(IDictionary<TKey, TValue> dictionary) : base(dictionary)
            { }

            protected override TValue GetItem(KeyValuePair<TKey, TValue> pair) => pair.Value;
        }
    }
}
