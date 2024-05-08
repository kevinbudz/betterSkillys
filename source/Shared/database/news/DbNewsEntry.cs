using Newtonsoft.Json;
using System;

namespace Shared.database.news
{
    public struct DbNewsEntry
    {
        [JsonIgnore] public DateTime Date;

        public string Icon;
        public string Link;
        public string Text;
        public string Title;
    }
}
