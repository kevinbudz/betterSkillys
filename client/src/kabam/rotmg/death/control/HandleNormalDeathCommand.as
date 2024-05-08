package kabam.rotmg.death.control
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.lib.tasks.DispatchSignalTask;
   import kabam.lib.tasks.TaskMonitor;
   import kabam.lib.tasks.TaskSequence;
   import kabam.rotmg.account.core.services.GetCharListTask;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.fame.control.ShowFameViewSignal;
   import kabam.rotmg.fame.model.FameVO;
   import kabam.rotmg.fame.model.SimpleFameVO;
   import kabam.rotmg.game.signals.DisconnectGameSignal;
   import kabam.rotmg.messaging.impl.incoming.Death;
   import robotlegs.bender.framework.api.ILogger;
   
   public class HandleNormalDeathCommand
   {
       
      
      [Inject]
      public var death:Death;
      
      [Inject]
      public var player:PlayerModel;
      
      [Inject]
      public var task:GetCharListTask;
      
      [Inject]
      public var showFame:ShowFameViewSignal;
      
      [Inject]
      public var monitor:TaskMonitor;
      
      [Inject]
      public var disconnect:DisconnectGameSignal;
      
      [Inject]
      public var logger:ILogger;
      
      private var fameVO:FameVO;
      
      public function HandleNormalDeathCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.logger.info("Handle Normal Death");
         this.disconnect.dispatch();
         this.fameVO = new SimpleFameVO(this.death.accountId_,this.death.charId_);
         this.gotoFameView();
      }
      
      private function gotoFameView() : void
      {
         if(this.player.getAccountId() == -1)
         {
            this.gotoFameViewOnceDataIsLoaded();
         }
         else
         {
            this.showFame.dispatch(this.fameVO);
         }
      }
      
      private function gotoFameViewOnceDataIsLoaded() : void
      {
         var sequence:TaskSequence = new TaskSequence();
         sequence.add(this.task);
         sequence.add(new DispatchSignalTask(this.showFame,this.fameVO));
         this.monitor.add(sequence);
         sequence.start();
      }
   }
}
