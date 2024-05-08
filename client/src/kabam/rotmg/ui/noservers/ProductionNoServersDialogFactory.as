package kabam.rotmg.ui.noservers
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   
   public class ProductionNoServersDialogFactory implements NoServersDialogFactory
   {
      public function ProductionNoServersDialogFactory()
      {
         super();
      }
      
      public function makeDialog() : Dialog
      {
         return new Dialog("There are currently no servers online.", "No Servers","Close",null);
      }
   }
}
