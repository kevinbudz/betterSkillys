package kabam.rotmg.game.commands
{
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.utils.getTimer;
   import kabam.rotmg.constants.UseType;
   import kabam.rotmg.game.model.PotionInventoryModel;
   import kabam.rotmg.game.model.UseBuyPotionVO;
   import kabam.rotmg.messaging.impl.GameServerConnection;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.model.PotionModel;
   import robotlegs.bender.framework.api.ILogger;
   
   public class UseBuyPotionCommand
   {
       
      
      [Inject]
      public var vo:UseBuyPotionVO;
      
      [Inject]
      public var potInventoryModel:PotionInventoryModel;
      
      [Inject]
      public var hudModel:HUDModel;
      
      [Inject]
      public var logger:ILogger;
      
      private var gsc:GameServerConnection;
      
      private var player:Player;
      
      private var potionId:int;
      
      private var count:int;
      
      private var potion:PotionModel;
      
      public function UseBuyPotionCommand()
      {
         this.gsc = GameServerConnection.instance;
         super();
      }
      
      public function execute() : void
      {
         this.player = this.hudModel.gameSprite.map.player_;
         this.potionId = this.vo.objectId;
         this.count = this.player.getPotionCount(this.potionId);
         this.potion = this.potInventoryModel.getPotionModel(this.potionId);
         if(this.count > 0)
         {
            this.usePotionIfEffective();
         }
         else
         {
            this.logger.info("Not safe to purchase potion");
         }
      }

      private function usePotionIfEffective() : void
      {
         if(this.isPlayerStatMaxed())
         {
            this.logger.info("UseBuyPotionCommand.execute: User has MAX of that attribute, not requesting a use/buy from server.");
         }
         else
         {
            this.sendServerRequest();
         }
      }
      
      private function isPlayerStatMaxed() : Boolean
      {
         if(this.potionId == PotionInventoryModel.HEALTH_POTION_ID)
         {
            return this.player.hp_ >= this.player.maxHP_;
         }
         if(this.potionId == PotionInventoryModel.MAGIC_POTION_ID)
         {
            return this.player.mp_ >= this.player.maxMP_;
         }
         return false;
      }
      
      private function sendServerRequest() : void
      {
         var slot:int = PotionInventoryModel.getPotionSlot(this.vo.objectId);
         this.gsc.useItem(getTimer(),this.player.objectId_,slot,this.potionId,this.player.x_,this.player.y_,UseType.START_USE);
      }
   }
}
