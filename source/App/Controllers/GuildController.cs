using Microsoft.AspNetCore.Mvc;
using System.Web;
using Shared.database;
using Shared.database.account;
using Shared.utils;

namespace App.Controllers
{
    [ApiController]
    [Route("guild")]
    public class GuildController : ControllerBase
    {
        private readonly CoreService _core;

        public GuildController(CoreService core)
        {
            _core = core;
        }

        [HttpPost("listMembers")]
        public void ListMembers([FromForm] string guid, [FromForm] string password)
        {
            var status = _core.Database.Verify(guid, password, out DbAccount acc);
            if (status == DbLoginStatus.OK)
            {
                if (acc.GuildId <= 0)
                {
                    Response.CreateError("Not in guild");
                    return;
                }

                var guild = _core.Database.GetGuild(acc.GuildId);
                Response.CreateXml(Guild.FromDb(_core, guild).ToXml().ToString());
                return;
            }
            Response.CreateError(status.GetInfo());
        }

        [HttpPost("getBoard")]
        public void GetBoard([FromForm] string guid, [FromForm] string password)
        {
            var status = _core.Database.Verify(guid, password, out DbAccount acc);
            if (status == DbLoginStatus.OK)
            {
                if (acc.GuildId <= 0)
                {
                    Response.CreateError("Not in guild");
                    return;
                }

                var guild = _core.Database.GetGuild(acc.GuildId);
                Response.CreateText(guild.Board);
                return;
            }
            Response.CreateError(status.GetInfo());
        }

        [HttpPost("setBoard")]
        public void SetBoard([FromForm] string guid, [FromForm] string password, [FromForm] string board)
        {
            var status = _core.Database.Verify(guid, password, out DbAccount acc);
            if (status == DbLoginStatus.OK)
            {
                if (acc.GuildId <= 0 || acc.GuildRank < 20)
                {
                    Response.CreateError("No permission");
                    return;
                }

                var guild = _core.Database.GetGuild(acc.GuildId);
                var text = HttpUtility.UrlDecode(board);
                if (_core.Database.SetGuildBoard(guild, text))
                {
                    Response.CreateText(text);
                    return;
                }

                Response.CreateError("Failed to set board");
                return;
            }

            Response.CreateError(status.GetInfo());
        }
    }
}