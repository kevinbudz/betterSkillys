using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using StackExchange.Redis;
using System;
using System.Linq;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using TKR.Shared;
using TKR.Shared.database;
using TKR.Shared.database.account;
using TKR.Shared.resources;
using TKR.Shared.utils;

namespace TKR.App.Controllers
{
    [ApiController]
    [Route("account")]
    public class AccountController : ControllerBase
    {
        private readonly CoreService _core;

        public AccountController(CoreService core)
        {
            _core = core;
        }

        [HttpPost("purchaseSkin")]
        public void PurcahseSkin([FromForm] string guid, [FromForm] string password, [FromForm] string skinType)
        {
            var db = _core.Database;

            var status = db.Verify(guid, password, out var acc);
            if (status == DbLoginStatus.OK)
            {
                var type = (ushort)Utils.GetInt(skinType);
                var skinDesc = _core.Resources.GameData.Skins[type];
                var classStats = _core.Database.ReadClassStats(acc);

                if (skinDesc.UnlockLevel > classStats[skinDesc.PlayerClassType].BestLevel || skinDesc.Cost > acc.Credits)
                {
                    Response.CreateError("Failed to purchase skin");
                    return;
                }

                db.PurchaseSkin(acc, type, skinDesc.Cost);
                Response.CreateSuccess();
                return;
            }
            Response.CreateError(status.GetInfo());
        }

        [HttpPost("purchaseCharSlot")]
        public async void PurchaseCharSlot([FromForm] string guid, [FromForm] string password)
        {
            // works but currently keeps you with account in use
            // need to fix

            var db = _core.Database;

            var status = db.Verify(guid, password, out var acc);
            if (status == DbLoginStatus.OK)
            {
                using (var l = db.Lock(acc))
                {
                    if (!db.LockOk(l))
                    {
                        Response.CreateError("Account in use");
                        return;
                    }

                    var currency = _core.Resources.Settings.NewAccounts.SlotCurrency;
                    var price = _core.Resources.Settings.NewAccounts.SlotCost;

                    acc.Reload("fame");
                    acc.Reload("totalFame");

                    if (currency == CurrencyType.Gold && acc.Credits < price || currency == CurrencyType.Fame && acc.Fame < price)
                    {
                        Response.CreateError("Insufficient funds");
                        return;
                    }

                    var trans = db.Conn.CreateTransaction();
                    var t1 = db.UpdateCurrency(acc, -price, currency, trans);
                    trans.AddCondition(Condition.HashEqual(acc.Key, "maxCharSlot", acc.MaxCharSlot));
                    await trans.HashIncrementAsync(acc.Key, "maxCharSlot");
                    var t2 = trans.ExecuteAsync();

                    await Task.WhenAll(t1, t2).ContinueWith(r =>
                    {
                        if (t2.IsCanceled || !t2.Result)
                        {
                            Response.CreateError("<Error>Internal Server Error</Error>");
                            return;
                        }

                        acc.MaxCharSlot++;
                        Response.CreateSuccess();
                    }).ContinueWith(e => _core.Logger.Error(e.Exception.InnerException.ToString()), TaskContinuationOptions.OnlyOnFaulted);
                }
                return;
            }
            Response.CreateError(status.GetInfo());
        }

        // removed so that people cant call the api and get shit for free
        //[HttpPost("handleDono")]
        //public void HandleDono([FromForm] string accountId, [FromForm] string secret, [FromForm] string type, [FromForm] string amountDonated)
        //{
        //    if (secret == "NEW_SECRET_KEY_HERE_TODO_SOMEONE_DONT_LET_THEM_KNOW_YOUR_NEXT_MOVE_OK")
        //    {
        //        var amount = int.Parse(amountDonated);

        //        var acc = _core.Database.GetAccount(int.Parse(accountId));
        //        if (type == "rank")
        //        {
        //            var rank = new DbRank(acc.Database, acc.AccountId);
        //            rank.NewAmountDonated += amount;
        //            rank.Flush();
        //            Response.CreateSuccess();
        //        }
        //        else if (type == "gold")
        //        {
        //            acc.Credits += amount;
        //            acc.TotalCredits += amount;
        //            acc.FlushAsync();
        //            Response.CreateSuccess();
        //        }
        //        return;
        //    }
        //    Response.CreateError("Internal Server Error.");
        //}

        [HttpPost("changePassword")]
        public void ChangePassword([FromForm] string guid, [FromForm] string password, [FromForm] string newPassword)
        {
            var status = _core.Database.Verify(guid, password, out var acc);
            if (status == DbLoginStatus.OK)
            {
                _core.Database.ChangePassword(guid, newPassword);
                _core.Logger.Info($"Password changed for <{acc.Name}-{acc.AccountId}>");
                Response.CreateSuccess();
                return;
            }
            Response.CreateError(status.GetInfo());
        }

        [HttpPost("verify")]
        public void Verify([FromForm] string guid, [FromForm] string password, [FromForm] string secret)
        {
            var status = _core.Database.Verify(guid, password, out DbAccount acc);
            if (status == DbLoginStatus.OK)
            {
                Response.CreateXml(Account.FromDb(_core, acc).ToXml().ToString());
                return;
            }
         
            Response.CreateError(status.GetInfo());
        }

        [HttpPost("setName")]
        public void SetName()
        {
            Response.CreateError("Unknown Error");
        }
        
        [HttpPost("register")]
        public void Register([FromForm] string guid, [FromForm] string newGuid, [FromForm] string newPassword, [FromForm] string name)
        {
            //if (_core.IsProduction()) // old code
            //{
            //    if (_core.Config.serverInfo.requireSecret && secret != "69420")
            //    {
            //        _core.Logger.Warn($"{newGuid} Tried to register without secret");
            //        Response.CreateError("Internal Server Error.");
            //        return;
            //    }

            //    if (_core.Resources.Settings.NewAccounts.TestingRegister)
            //    {
            //        Response.CreateError("Testers Only");
            //        return;
            //    }
            //}

            if (Database.GuestNames.Contains(name, StringComparer.InvariantCultureIgnoreCase) || !IsValidName(name))
            {
                Response.CreateError("Invalid name");
                return;
            }

            foreach (var i in Database.BlackListedNames)
                if (name.ToLower() == i.ToLower())
                {
                    Response.CreateError("Invalid name");
                    return;
                }

            if (!Utils.IsValidEmail(newGuid))
            {
                Response.CreateError("Invalid email");
                return;
            }

            var key = Database.REG_LOCK;
            var lockToken = "";
            try
            {
                while ((lockToken = _core.Database.AcquireLock(key)) == null) ;

                string nameLockToken = null;

                var nameKey = Database.NAME_LOCK;

                try
                {
                    while ((nameLockToken = _core.Database.AcquireLock(nameKey)) == null) ;

                    if (_core.Database.Conn.HashExists("names", name.ToUpperInvariant()))
                    {
                        Response.CreateError("Duplicated name");
                        return;
                    }

                    var s = _core.Database.Register(newGuid, newPassword, false, out var acc);
                    if (s == DbRegisterStatus.OK)
                    {
                        while (!_core.Database.RenameIGN(acc, name, nameLockToken)) ;

                        Response.CreateSuccess();
                    }
                    else
                        Response.CreateError(s.GetInfo());
                }
                finally
                {
                    if (nameLockToken != null)
                        _core.Database.ReleaseLock(nameKey, nameLockToken);
                }

            }
            finally
            {
                if (lockToken != null)
                    _core.Database.ReleaseLock(key, lockToken);
            }

            bool IsValidName(string text)
            {
                var nonDup = new Regex(@"([a-zA-z]{2,})\1{1,}");
                var alpha = new Regex(@"^[A-Za-z]{1,10}$");
                return !(nonDup.Matches(text).Count > 0) && alpha.Matches(text).Count > 0;
            }
        }
    }
}