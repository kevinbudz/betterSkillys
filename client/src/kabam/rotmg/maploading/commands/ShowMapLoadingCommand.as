package kabam.rotmg.maploading.commands
{
   import com.company.assembleegameclient.appengine.SavedCharacter;
   import kabam.rotmg.assets.model.Animation;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.view.Layers;
   import kabam.rotmg.game.model.GameInitData;
   import kabam.rotmg.maploading.view.MapLoadingView;
   import kabam.rotmg.messaging.impl.incoming.MapInfo;
   import robotlegs.bender.framework.api.ILogger;
   
   public class ShowMapLoadingCommand
   {
       
      
      [Inject]
      public var layers:Layers;
      
      [Inject]
      public var info:MapInfo;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var classesModel:ClassesModel;
      
      [Inject]
      public var factory:CharacterFactory;
      
      [Inject]
      public var gameInitData:GameInitData;
      
      [Inject]
      public var logger:ILogger;
      
      public function ShowMapLoadingCommand()
      {
         super();
      }
      
      public function execute() : void
      {
         var view:MapLoadingView = new MapLoadingView();
         view.display(this.info.displayName_,this.info.difficulty_,this.makeAnimation());
         this.layers.top.addChild(view);
      }
      
      private function makeAnimation() : Animation
      {
         var savedChar:SavedCharacter = this.playerModel.getCharacterById(this.playerModel.currentCharId);
         var skin:CharacterSkin = this.classesModel.getSelected().skins.getSelectedSkin();
         var tex1:int = Boolean(savedChar)?int(savedChar.tex1()):int(0);
         var tex2:int = Boolean(savedChar)?int(savedChar.tex2()):int(0);
         return this.factory.makeWalkingIcon(skin.template,100,tex1,tex2);
      }
   }
}
