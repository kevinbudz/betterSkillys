using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Shared.database.character.inventory
{
    public class ItemData
    {

        public string ObjectId { get; set; }

        public int Stack { get; set; }
        public int MaxStack { get; set; }

        public string GetData() => JsonConvert.SerializeObject(this);

        public static ItemData CreateData(string json) => JsonConvert.DeserializeObject<ItemData>(json);
    }
}
