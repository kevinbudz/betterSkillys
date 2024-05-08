package kabam.lib.ui
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import org.osflash.signals.Signal;
   
   public class GroupMappedSignal extends Signal
   {
       
      
      private var eventType:String;
      
      private var mappedTargets:Dictionary;
      
      public function GroupMappedSignal(eventType:String, ... valueClasses)
      {
         this.eventType = eventType;
         this.mappedTargets = new Dictionary(true);
         super(valueClasses);
      }
      
      public function map(target:IEventDispatcher, value:*) : void
      {
         this.mappedTargets[target] = value;
         target.addEventListener(this.eventType,this.onTarget,false,0,true);
      }
      
      private function onTarget(event:Event) : void
      {
         dispatch(this.mappedTargets[event.target]);
      }
   }
}
