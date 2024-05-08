package kabam.rotmg.account.web.commands
{
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.TaskGroup;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.rotmg.account.core.services.SendPasswordReminderTask;
   import kabam.rotmg.account.web.view.WebLoginDialog;
   import kabam.rotmg.core.signals.TaskErrorSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class WebSendPasswordReminderCommand
   {
       
      
      [Inject]
      public var email:String;
      
      [Inject]
      public var task:SendPasswordReminderTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var taskError:TaskErrorSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      public function WebSendPasswordReminderCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var success:TaskGroup = new TaskGroup();
         success.add(new DispatchSignalTask(this.openDialog,new WebLoginDialog()));
         var failure:TaskGroup = new TaskGroup();
         failure.add(new DispatchSignalTask(this.taskError,this.task));
         var branch:BranchingTask = new BranchingTask(this.task,success,failure);
         this.monitor.add(branch);
         branch.start();
      }
   }
}
