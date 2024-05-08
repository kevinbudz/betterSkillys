package kabam.rotmg.appengine.impl
{
   import kabam.lib.console.signals.ConsoleWatchSignal;
   
   public class AppEngineRequestStats
   {
       
      
      [Inject]
      public var watch:ConsoleWatchSignal;
      
      private const nameMap:Object = {};
      
      public function AppEngineRequestStats()
      {
         super();
      }
      
      public function recordStats(name:String, isOK:Boolean, responseTime:int) : void
      {
         var stats:StatsWatch = this.nameMap[name] = this.nameMap[name] || new StatsWatch(name);
         stats.addResponse(isOK,responseTime);
         this.watch.dispatch(stats);
      }
   }
}

import kabam.lib.console.model.Watch;

class StatsWatch extends Watch
{
   
   private static const STATS_PATTERN:String = "[APPENGINE STATS] [0xFFEE00:{/x={MEAN}ms, ok={OK}/{COUNT}} {NAME}]";
   
   private static const MEAN:String = "{MEAN}";
   
   private static const COUNT:String = "{COUNT}";
   
   private static const OK:String = "{OK}";
   
   private static const NAME:String = "{NAME}";
    
   
   private var count:int;
   
   private var time:int;
   
   private var mean:int;
   
   private var ok:int;
   
   function StatsWatch(name:String)
   {
      super(name,"");
      this.count = 0;
      this.ok = 0;
      this.time = 0;
   }
   
   public function addResponse(isOK:Boolean, responseTime:int) : void
   {
      isOK && ++this.ok;
      this.time = this.time + responseTime;
      this.mean = this.time / ++this.count;
      data = this.report();
   }
   
   private function report() : String
   {
      return STATS_PATTERN.replace(MEAN,this.mean).replace(COUNT,this.count).replace(OK,this.ok).replace(NAME,name);
   }
}
