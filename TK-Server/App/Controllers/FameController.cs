using Microsoft.AspNetCore.Mvc;
using Shared.database.character;

namespace App.Controllers
{
    [ApiController]
    [Route("fame")]
    public class FameController : ControllerBase
    {
        private readonly CoreService _core;

        public FameController(CoreService core)
        {
            _core = core;
        }

        [HttpPost("list")]
        public void List([FromForm] string accountId, [FromForm] string charId, [FromForm] string timespan)
        {
            DbChar character = null;
            if (accountId != null)
                character = _core.Database.LoadCharacter(int.Parse(accountId), int.Parse(charId));

            // todo figure this one out to use the actual query stuff isntead of timespan only
            var list = FameList.FromDb(_core, timespan);
            Response.CreateXml(list.ToXml().ToString());
        }
    }
}