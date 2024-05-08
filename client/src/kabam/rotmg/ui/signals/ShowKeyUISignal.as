package kabam.rotmg.ui.signals
{
   import org.osflash.signals.Signal;
   
   public class ShowKeyUISignal extends Signal
   {
      
      public static var instance:ShowKeyUISignal;
       
      
      public function ShowKeyUISignal()
      {
         super();
         instance = this;
      }
   }
}
