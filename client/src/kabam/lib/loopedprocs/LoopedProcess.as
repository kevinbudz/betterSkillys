package kabam.lib.loopedprocs
{
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   
   public class LoopedProcess
   {
      
      private static var maxId:uint;
      
      private static var loopProcs:Dictionary = new Dictionary();
       
      
      public var id:uint;
      
      public var paused:Boolean;
      
      public var interval:uint;
      
      public var lastRun:int;
      
      public function LoopedProcess(runInterval:uint)
      {
         super();
         this.interval = runInterval;
      }
      
      public static function addProcess(proc:LoopedProcess) : uint
      {
         if(loopProcs[proc.id] == proc)
         {
            return proc.id;
         }
         var _loc2_:* = ++maxId;
         loopProcs[_loc2_] = proc;
         proc.lastRun = getTimer();
         return maxId;
      }
      
      public static function runProcesses(curTime:int) : void
      {
         var proc:LoopedProcess = null;
         var timeSinceRun:int = 0;
         for each(proc in loopProcs)
         {
            if(!proc.paused)
            {
               timeSinceRun = curTime - proc.lastRun;
               if(timeSinceRun >= proc.interval)
               {
                  proc.lastRun = curTime;
                  proc.run();
               }
            }
         }
      }
      
      public static function destroyProcess(proc:LoopedProcess) : void
      {
         delete loopProcs[proc.id];
         proc.onDestroyed();
      }
      
      public static function destroyAll() : void
      {
         var proc:LoopedProcess = null;
         for each(proc in loopProcs)
         {
            proc.destroy();
         }
         loopProcs = new Dictionary();
      }
      
      public final function add() : void
      {
         addProcess(this);
      }
      
      public final function destroy() : void
      {
         destroyProcess(this);
      }
      
      protected function run() : void
      {
      }
      
      protected function onDestroyed() : void
      {
      }
   }
}
