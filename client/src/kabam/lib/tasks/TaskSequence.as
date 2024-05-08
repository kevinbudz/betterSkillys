package kabam.lib.tasks
{
   public class TaskSequence extends BaseTask
   {
       
      
      private var tasks:Vector.<Task>;
      
      private var index:int;
      
      private var continueOnFail:Boolean;
      
      public function TaskSequence()
      {
         super();
         this.tasks = new Vector.<Task>();
      }
      
      public function getContinueOnFail() : Boolean
      {
         return this.continueOnFail;
      }
      
      public function setContinueOnFail(value:Boolean) : void
      {
         this.continueOnFail = value;
      }
      
      public function add(task:Task) : void
      {
         this.tasks.push(task);
      }
      
      override protected function startTask() : void
      {
         this.index = 0;
         this.doNextTaskOrComplete();
      }
      
      override protected function onReset() : void
      {
         var task:Task = null;
         for each(task in this.tasks)
         {
            task.reset();
         }
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
         return this.index < this.tasks.length;
      }
      
      private function doNextTask() : void
      {
         var task:Task = this.tasks[this.index++];
         task.lastly.addOnce(this.onTaskFinished);
         task.start();
      }
      
      private function onTaskFinished(task:Task, isOK:Boolean, error:String) : void
      {
         if(isOK || this.continueOnFail)
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
