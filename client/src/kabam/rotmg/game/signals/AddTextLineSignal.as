package kabam.rotmg.game.signals
{
   import kabam.lib.signals.DeferredQueueSignal;
   import kabam.rotmg.game.model.AddTextLineVO;
   
   public class AddTextLineSignal extends DeferredQueueSignal
   {
       
      
      public function AddTextLineSignal()
      {
         super(AddTextLineVO);
      }
   }
}
