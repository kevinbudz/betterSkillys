package kabam.rotmg.characters.reskin.control
{
   import com.company.assembleegameclient.objects.Player;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.game.model.GameModel;
   import kabam.rotmg.messaging.impl.outgoing.Reskin;
   
   public class ReskinHandler
   {
       
      
      [Inject]
      public var model:GameModel;
      
      [Inject]
      public var classes:ClassesModel;
      
      [Inject]
      public var factory:CharacterFactory;
      
      public function ReskinHandler()
      {
         super();
      }
      
      public function execute(reskin:Reskin) : void
      {
         var player:Player = null;
         var skinID:int = 0;
         var charType:CharacterClass = null;
         player = reskin.player || this.model.player;
         skinID = reskin.skinID;
         charType = this.classes.getCharacterClass(player.objectType_);
         var skin:CharacterSkin = charType.skins.getSkin(skinID);
         player.skinId = skinID;
         player.skin = this.factory.makeCharacter(skin.template);
         player.isDefaultAnimatedChar = false;
      }
   }
}
