package kabam.rotmg.account.core
{
   import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.BuyCharacterSlotTask;
   import kabam.rotmg.account.core.view.BuyingDialog;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.ui.view.CharacterSlotNeedGoldDialog;
import kabam.rotmg.ui.view.FlexibleDialog;

public class BuyCharacterSlotCommand
   {
       
      
      [Inject]
      public var price:int;
      
      [Inject]
      public var task:BuyCharacterSlotTask;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var setScreen:SetScreenSignal;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var closeDialog:CloseDialogsSignal;
      
      [Inject]
      public var model:PlayerModel;
      
      [Inject]
      public var account:Account;
      
      public function BuyCharacterSlotCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         if(this.isSlotUnaffordable())
         {
            this.nonSufficientFunds();
         }
         else
         {
            this.purchaseSlot();
         }
      }
      
      private function isSlotUnaffordable() : Boolean
      {
         return (this.model.isNextCharSlotCurrencyFame()
                 ? this.model.getFame() : this.model.getCredits())
                 < this.model.getNextCharSlotPrice();
      }
      
      private function nonSufficientFunds() : void
      {
         this.openDialog.dispatch(
                 new FlexibleDialog("Not Enough " + (this.model.isNextCharSlotCurrencyFame() ? "Fame" : "Gold"),
                         "Insufficient funds when trying to buy a slot.", "Close"));
      }
      
      private function purchaseSlot() : void
      {
         this.openDialog.dispatch(new BuyingDialog());
         var sequence:TaskSequence = new TaskSequence();
         sequence.add(new BranchingTask(this.task,this.makeSuccessTask(),this.makeFailureTask()));
         sequence.add(new DispatchSignalTask(this.closeDialog));
         this.monitor.add(sequence);
         sequence.start();
      }
      
      private function makeSuccessTask() : Task
      {
         var task:TaskSequence = new TaskSequence();
         task.add(new DispatchSignalTask(this.setScreen,new CharacterSelectionAndNewsScreen()));
         return task;
      }

      private function makeFailureTask() : Task
      {
         return new DispatchSignalTask(this.openDialog,new ErrorDialog("Unable to complete character slot purchase"));
      }
   }
}
