package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class NotEnoughGoldDialog extends Dialog
   {
      
      private static const TEXT:String = "You do not have enough Gold for this item.";
      
      private static const TITLE:String = "Not Enough Gold";
      
      private static const CANCEL:String = "Cancel";
       
      
      public var cancel:Signal;
      
      public function NotEnoughGoldDialog(message:String = "")
      {
         var text:String = message == ""?TEXT:message;
         super(text,TITLE,CANCEL, null);
         this.cancel = new NativeMappedSignal(this,BUTTON1_EVENT);
      }
   }
}
