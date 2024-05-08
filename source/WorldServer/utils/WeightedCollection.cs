using System;
using System.Collections.Generic;

namespace WorldServer.utils
{
    public struct WeightedItem<T>
    {
        public T Item { get; }
        public int Weight { get; }

        public WeightedItem(T item, int weight)
        {
            Item = item;
            Weight = weight;
        }
    }

    public class WeightedCollection<T>
    {
        private readonly List<WeightedItem<T>> Items = new List<WeightedItem<T>>();

        public void AddItem(T item, int weight)
        {
            TotalWeight += weight;
            Items.Add(new WeightedItem<T>(item, weight));
        }

        public T GetRandom(Random random)
        {
            var rolled = random.Next(TotalWeight);

            var accumulated = 0;
            foreach (var item in Items)
            {
                accumulated += item.Weight;
                if (rolled <= accumulated)
                    return item.Item;
            }

            return Items[Items.Count - 1].Item;
        }

        public int TotalWeight;
    }

}
