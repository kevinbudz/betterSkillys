package kabam.rotmg.ui.view
{
import com.company.assembleegameclient.objects.particles.StreamEffect;
import com.company.assembleegameclient.ui.dialogs.Dialog;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class FlexibleDialog extends Dialog
   {
      private static const CLOSE:String = "Close";
      
      public var cancel:Signal;
      
      public function FlexibleDialog(title:String = "", message:String = "", buttonText:String = "")
      {
         var text:String = message;
         super(text,title,buttonText==""?CLOSE:buttonText, null);
         this.cancel = new NativeMappedSignal(this,BUTTON1_EVENT);
      }
   }
}
