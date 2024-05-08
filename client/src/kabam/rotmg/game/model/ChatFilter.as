package kabam.rotmg.game.model
{
   import com.company.assembleegameclient.parameters.Parameters;
   
   public class ChatFilter
   {
       
      
      public function ChatFilter()
      {
         super();
      }
      
      public function guestChatFilter(name:String) : Boolean
      {
         var show:Boolean = false;
         if(name == null)
         {
            return true;
         }
         if(name == Parameters.SERVER_CHAT_NAME || name == Parameters.HELP_CHAT_NAME || name == Parameters.ERROR_CHAT_NAME || name == Parameters.CLIENT_CHAT_NAME)
         {
            show = true;
         }
         if(name.charAt(0) == "#")
         {
            show = true;
         }
         if(name.charAt(0) == "@")
         {
            show = true;
         }
         return show;
      }
   }
}
