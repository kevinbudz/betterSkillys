package kabam.lib.tasks
{
   public class BranchingTask extends BaseTask
   {
       
      
      private var task:Task;
      
      private var success:Task;
      
      private var failure:Task;
      
      public function BranchingTask(task:Task, success:Task = null, failure:Task = null)
      {
         super();
         this.task = task;
         this.success = success;
         this.failure = failure;
      }
      
      public function addSuccessTask(task:Task) : void
      {
         this.success = task;
      }
      
      public function addFailureTask(task:Task) : void
      {
         this.failure = task;
      }
      
      override protected function startTask() : void
      {
         this.task.finished.addOnce(this.onTaskFinished);
         this.task.start();
      }
      
      private function onTaskFinished(task:Task, isOK:Boolean, error:String = "") : void
      {
         if(isOK)
         {
            this.handleBranchTask(this.success);
         }
         else
         {
            this.handleBranchTask(this.failure);
         }
      }
      
      private function handleBranchTask(task:Task) : void
      {
         if(task)
         {
            task.finished.addOnce(this.onBranchComplete);
            task.start();
         }
         else
         {
            completeTask(true);
         }
      }
      
      private function onBranchComplete(task:Task, isOK:Boolean, error:String = "") : void
      {
         completeTask(isOK,error);
      }
   }
}
