package kabam.rotmg.startup.control
{
   import kabam.lib.tasks.BaseTask;
   import kabam.lib.tasks.Task;
   import kabam.rotmg.startup.model.api.StartupDelegate;
   import kabam.rotmg.startup.model.impl.SignalTaskDelegate;
   import kabam.rotmg.startup.model.impl.TaskDelegate;
   import org.swiftsuspenders.Injector;
   
   public class StartupSequence extends BaseTask
   {
      
      public static const LAST:int = int.MAX_VALUE;
       
      
      [Inject]
      public var injector:Injector;
      
      private const list:Vector.<StartupDelegate> = new Vector.<StartupDelegate>(0);
      
      private var index:int = 0;
      
      public function StartupSequence()
      {
         super();
      }
      
      public function addSignal(signalClass:Class, priority:int = 0) : void
      {
         var delegate:SignalTaskDelegate = new SignalTaskDelegate();
         delegate.injector = this.injector;
         delegate.signalClass = signalClass;
         delegate.priority = priority;
         this.list.push(delegate);
      }
      
      public function addTask(taskClass:Class, priority:int = 0) : void
      {
         var delegate:TaskDelegate = new TaskDelegate();
         delegate.injector = this.injector;
         delegate.taskClass = taskClass;
         delegate.priority = priority;
         this.list.push(delegate);
      }
      
      override protected function startTask() : void
      {
         this.list.sort(this.priorityComparison);
         this.index = 0;
         this.doNextTaskOrComplete();
      }
      
      private function priorityComparison(a:StartupDelegate, b:StartupDelegate) : int
      {
         return a.getPriority() - b.getPriority();
      }
      
      private function doNextTaskOrComplete() : void
      {
         if(this.isAnotherTask())
         {
            this.doNextTask();
         }
         else
         {
            completeTask(true);
         }
      }
      
      private function isAnotherTask() : Boolean
      {
         return this.index < this.list.length;
      }
      
      private function doNextTask() : void
      {
         var task:Task = this.list[this.index++].make();
         task.lastly.addOnce(this.onTaskFinished);
         task.start();
      }
      
      private function onTaskFinished(task:Task, isOK:Boolean, error:String) : void
      {
         if(isOK)
         {
            this.doNextTaskOrComplete();
         }
         else
         {
            completeTask(false,error);
         }
      }
   }
}
