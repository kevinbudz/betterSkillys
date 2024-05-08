package kabam.lib.loopedprocs
{
   public class LoopedCallback extends LoopedProcess
   {
       
      
      public var callback:Function;
      
      public var parameters:Array;
      
      public function LoopedCallback(runInterval:int, callbackFunc:Function, ... params)
      {
         super(runInterval);
         this.callback = callbackFunc;
         this.parameters = params;
      }
      
      override protected function run() : void
      {
         this.callback.apply(this.parameters);
      }
      
      override protected function onDestroyed() : void
      {
         this.callback = null;
         this.parameters = null;
      }
   }
}
