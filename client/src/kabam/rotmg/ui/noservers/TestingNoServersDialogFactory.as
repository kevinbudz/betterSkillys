package kabam.rotmg.ui.noservers
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   
   public class TestingNoServersDialogFactory implements NoServersDialogFactory
   {
      
      private static const BODY:String = "There are currently no testing servers available. Please play on <font color=\"#7777EE\"><a href=\"http://www.realmofthemadgod.com/\">www.realmofthemadgod.com</a></font>.";
      
      private static const TITLE:String = "No Testing Servers";
       
      
      public function TestingNoServersDialogFactory()
      {
         super();
      }
      
      public function makeDialog() : Dialog
      {
         return new Dialog(BODY,TITLE,null,null);
      }
   }
}
