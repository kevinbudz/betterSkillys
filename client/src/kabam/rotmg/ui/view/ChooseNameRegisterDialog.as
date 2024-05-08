package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class ChooseNameRegisterDialog extends Dialog
   {
      
      private static const TEXT:String = "In order to select a unique name you must be a registered user.";
      
      private static const TITLE:String = "Not Registered";
      
      private static const CANCEL:String = "Cancel";
      
      private static const REGISTER:String = "Register";
       
      
      public var cancel:Signal;
      
      public var register:Signal;
      
      public function ChooseNameRegisterDialog()
      {
         super(TEXT,TITLE,CANCEL,REGISTER);
         this.cancel = new NativeMappedSignal(this,BUTTON1_EVENT);
         this.register = new NativeMappedSignal(this,BUTTON2_EVENT);
      }
   }
}
