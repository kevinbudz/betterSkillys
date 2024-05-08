package kabam.rotmg.death.control
{
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.death.model.DeathModel;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.messaging.impl.incoming.Death;
   import robotlegs.bender.framework.api.ILogger;
   
   public class HandleDeathCommand
   {
       
      
      [Inject]
      public var death:Death;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var model:DeathModel;
      
      [Inject]
      public var player:PlayerModel;

      [Inject]
      public var normal:HandleNormalDeathSignal;
      
      public function HandleDeathCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         this.closeDialogs.dispatch();
         if(this.isDeathPending())
         {
            this.passPreviousDeathToFameView();
         }
         else
         {
            this.updateModelAndHandleDeath();
         }
      }
      
      private function isDeathPending() : Boolean
      {
         return this.model.getIsDeathViewPending();
      }
      
      private function passPreviousDeathToFameView() : void
      {
         this.normal.dispatch(this.model.getLastDeath());
      }
      
      private function updateModelAndHandleDeath() : void
      {
         this.model.setLastDeath(this.death);
         this.normal.dispatch(this.death);
      }
   }
}
