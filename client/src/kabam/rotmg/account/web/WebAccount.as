package kabam.rotmg.account.web
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.GUID;
   import flash.external.ExternalInterface;
   import flash.net.SharedObject;
   import kabam.rotmg.account.core.Account;
   
   public class WebAccount implements Account
   {
      private var userId:String = "";
      private var _userDisplayName:String = "";
      private var password:String;
      
      public function WebAccount()
      {
         super();
      }
      
      public function getUserName() : String
      {
         return this.userId;
      }

      public function get userDisplayName():String {
         return (this._userDisplayName);
      }

      public function set userDisplayName(_arg1:String):void {
         this._userDisplayName = _arg1;
      }

      public function getUserId() : String
      {
         return this.userId = this.userId || GUID.create();
      }
      
      public function getPassword() : String
      {
         return this.password || "";
      }
      
      public function getCredentials() : Object
      {
         return {
            "guid":this.getUserId(),
            "password":this.getPassword()
         };
      }
      
      public function isRegistered() : Boolean
      {
         return this.getPassword() != "";
      }
      
      public function updateUser(userId:String, password:String) : void
      {
         var rotmg:SharedObject = null;
         this.userId = userId;
         this.password = password;
         try
         {
            rotmg = SharedObject.getLocal("OSRotMG","/");
            rotmg.data["GUID"] = userId;
            rotmg.data["Password"] = password;
            rotmg.flush();
         }
         catch(error:Error)
         {
         }
      }
      
      public function clear() : void
      {
         this.updateUser(GUID.create(),null);
         Parameters.data_.charIdUseMap = {};
         Parameters.save();
      }
      
      public function reportIntStat(name:String, value:int) : void
      {
         trace("Setting int stat \"" + name + "\" to \"" + value + "\"");
      }
   }
}
