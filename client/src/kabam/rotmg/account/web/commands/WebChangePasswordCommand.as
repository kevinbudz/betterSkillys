package kabam.rotmg.account.web.commands
{
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.ChangePasswordTask;
   import kabam.rotmg.account.web.view.WebAccountDetailDialog;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class WebChangePasswordCommand
   {
       
      
      [Inject]
      public var task:ChangePasswordTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var close:CloseDialogsSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var loginError:TaskErrorSignal;
      
      public function WebChangePasswordCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var branch:BranchingTask = new BranchingTask(this.task,this.makeSuccess(),this.makeFailure());
         this.monitor.add(branch);
         branch.start();
      }
      
      private function makeSuccess() : Task
      {
         var sequence:TaskSequence = new TaskSequence();
         sequence.add(new DispatchSignalTask(this.openDialog,new WebAccountDetailDialog()));
         return sequence;
      }
      
      private function makeFailure() : Task
      {
         return new DispatchSignalTask(this.loginError,this.task);
      }
   }
}
