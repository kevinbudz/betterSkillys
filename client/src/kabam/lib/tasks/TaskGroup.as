package kabam.lib.tasks
{
   public class TaskGroup extends BaseTask
   {
       
      
      private var tasks:Vector.<BaseTask>;
      
      private var pending:int;
      
      public function TaskGroup()
      {
         super();
         this.tasks = new Vector.<BaseTask>();
      }
      
      public function add(task:BaseTask) : void
      {
         this.tasks.push(task);
      }
      
      override protected function startTask() : void
      {
         this.pending = this.tasks.length;
         if(this.pending > 0)
         {
            this.startAllTasks();
         }
         else
         {
            completeTask(true);
         }
      }
      
      override protected function onReset() : void
      {
         var task:BaseTask = null;
         for each(task in this.tasks)
         {
            task.reset();
         }
      }
      
      private function startAllTasks() : void
      {
         var i:int = this.pending;
         while(i--)
         {
            this.tasks[i].lastly.addOnce(this.onTaskFinished);
            this.tasks[i].start();
         }
      }
      
      private function onTaskFinished(task:BaseTask, isOK:Boolean, error:String) : void
      {
         if(isOK)
         {
            if(--this.pending == 0)
            {
               completeTask(true);
            }
         }
         else
         {
            completeTask(false,error);
         }
      }
      
      public function toString() : String
      {
         return "[TaskGroup(" + this.tasks.join(",") + ")]";
      }
   }
}
