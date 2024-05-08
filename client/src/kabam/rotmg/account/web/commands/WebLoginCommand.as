package kabam.rotmg.account.web.commands
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.screens.CharacterSelectionAndNewsScreen;
import flash.display.Sprite;
import kabam.lib.tasks.BranchingTask;
import kabam.lib.tasks.DispatchSignalTask;
import kabam.lib.tasks.Task;
import kabam.lib.tasks.TaskMonitor;
import kabam.lib.tasks.TaskSequence;
import kabam.rotmg.account.core.services.LoginTask;
import kabam.rotmg.account.core.signals.UpdateAccountInfoSignal;
import kabam.rotmg.account.web.model.AccountData;
import kabam.rotmg.account.web.view.WebAccountDetailDialog;
import kabam.rotmg.core.model.ScreenModel;
import kabam.rotmg.core.signals.InvalidateDataSignal;
import kabam.rotmg.core.signals.SetScreenWithValidDataSignal;
import kabam.rotmg.core.signals.TaskErrorSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;

public class WebLoginCommand
{


   [Inject]
   public var data:AccountData;

   [Inject]
   public var task:LoginTask;

   [Inject]
   public var monitor:TaskMonitor;

   [Inject]
   public var openDialog:OpenDialogSignal;

   [Inject]
   public var loginError:TaskErrorSignal;

   [Inject]
   public var updateLogin:UpdateAccountInfoSignal;

   [Inject]
   public var invalidate:InvalidateDataSignal;

   [Inject]
   public var setScreenWithValidData:SetScreenWithValidDataSignal;

   [Inject]
   public var closeDialogs:CloseDialogsSignal;

   [Inject]
   public var screenModel:ScreenModel;

   public function WebLoginCommand()
   {
      super();
   }

   public function execute() : void
   {
      var branch:BranchingTask = new BranchingTask(this.task,this.makeSuccessTask(),this.makeFailureTask());
      this.monitor.add(branch);
      branch.start();
   }

   private function makeSuccessTask() : TaskSequence
   {
      var sequence:TaskSequence = new TaskSequence();
      sequence.add(new DispatchSignalTask(this.closeDialogs));
      sequence.add(new DispatchSignalTask(this.updateLogin));
      sequence.add(new DispatchSignalTask(this.invalidate));
      sequence.add(new DispatchSignalTask(this.setScreenWithValidData,this.getTargetScreen()));
      return sequence;
   }

   private function makeFailureTask() : Task
   {
      return new DispatchSignalTask(this.loginError,this.task);
   }

   private function getTargetScreen() : Sprite
   {
      var type:Class = this.screenModel.currentType;
      if(type == null || type == GameSprite)
      {
         type = CharacterSelectionAndNewsScreen;
      }
      return new type();
   }
}
}
