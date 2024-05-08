package kabam.rotmg.account.core
{
   public interface Account
   {
      function updateUser(guid:String, password:String) : void;
      
      function getUserName() : String;
      
      function getUserId() : String;
      
      function getPassword() : String;
      
      function getCredentials() : Object;
      
      function isRegistered() : Boolean;
      
      function clear() : void;
      
      function reportIntStat(name:String, value:int) : void;
   }
}
