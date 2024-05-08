package kabam.rotmg.ui.model
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeSignal;
   
   public class PotionModel
   {
       
      
      public var objectId:uint;
      
      public var maxPotionCount:int;
      
      public var position:int;
      
      public var available:Boolean;

      public var update:Signal;
      
      public function PotionModel()
      {
         super();
         this.update = new Signal(int);
         this.available = true;
      }
   }
}
