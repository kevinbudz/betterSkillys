package kabam.rotmg.core.commands
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import kabam.lib.tasks.BranchingTask;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.Task;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.services.GetCharListTask;
   import kabam.rotmg.account.core.view.RegisterPromptDialog;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.service.PurchaseCharacterClassTask;
   import kabam.rotmg.core.service.PurchaseCharacterErrorTask;
   import kabam.rotmg.core.signals.BuyCharacterPendingSignal;
   import kabam.rotmg.core.signals.UpdateNewCharacterScreenSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.ui.view.NotEnoughGoldDialog;
   
   public class PurchaseCharacterCommand
   {
       
      
      [Inject]
      public var classType:int;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var updateNewCharacterScreen:UpdateNewCharacterScreenSignal;
      
      [Inject]
      public var buyCharacterPending:BuyCharacterPendingSignal;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var task:PurchaseCharacterClassTask;
      
      [Inject]
      public var failure:PurchaseCharacterErrorTask;
      
      [Inject]
      public var charList:GetCharListTask;
      
      private var cost:int;
      
      public function PurchaseCharacterCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.cost = this.getCostToUnlockCharacter();
         if(!this.account.isRegistered())
         {
            this.showPromptToRegister();
         }
         else if(this.isCharacterUnlockAffordable())
         {
            this.purchaseCharacterClass();
         }
         else
         {
            this.showNotEnoughGoldDialog();
         }
      }
      
      private function showPromptToRegister() : void
      {
         this.openDialog.dispatch(new RegisterPromptDialog("In order to unlock a class type you must be a registered user."));
         this.updateNewCharacterScreen.dispatch();
      }
      
      private function purchaseCharacterClass() : void
      {
         this.playerModel.changeCredits(-1 * this.cost);
         this.buyCharacterPending.dispatch(this.classType);
         var sequence:TaskSequence = new TaskSequence();
         sequence.add(new BranchingTask(this.task,this.charList,this.makeFailureTask()));
         sequence.add(new DispatchSignalTask(this.updateNewCharacterScreen));
         this.monitor.add(sequence);
         sequence.start();
      }
      
      private function makeFailureTask() : Task
      {
         this.failure.parentTask = this.task;
         return this.failure;
      }
      
      private function showNotEnoughGoldDialog() : void
      {
         this.openDialog.dispatch(new NotEnoughGoldDialog("This character class costs " + String(this.cost) + " Gold."));
         this.updateNewCharacterScreen.dispatch();
      }
      
      private function getCostToUnlockCharacter() : int
      {
         return ObjectLibrary.xmlLibrary_[this.classType].UnlockCost;
      }
      
      private function isCharacterUnlockAffordable() : Boolean
      {
         return !this.cost || this.cost <= this.playerModel.getCredits();
      }
   }
}
