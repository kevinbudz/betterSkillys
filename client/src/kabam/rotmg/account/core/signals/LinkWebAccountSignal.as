package kabam.rotmg.account.core.signals
{
   import kabam.rotmg.account.web.model.AccountData;
   import org.osflash.signals.Signal;
   
   public class LinkWebAccountSignal extends Signal
   {
       
      
      public function LinkWebAccountSignal()
      {
         super(AccountData);
      }
   }
}
