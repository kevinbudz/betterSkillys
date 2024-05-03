package kabam.rotmg.classes.view
{
   import com.company.assembleegameclient.util.FameUtil;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import kabam.rotmg.assets.model.Animation;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.control.FocusCharacterSkinSignal;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.core.model.PlayerModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ClassDetailMediator extends Mediator
   {
       
      
      [Inject]
      public var view:ClassDetailView;
      
      [Inject]
      public var classesModel:ClassesModel;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var focusSet:FocusCharacterSkinSignal;
      
      [Inject]
      public var factory:CharacterFactory;
      
      private const skins:Object = new Object();
      
      private var character:CharacterClass;
      
      private var nextSkin:CharacterSkin;
      
      private const nextSkinTimer:Timer = new Timer(250,1);
      
      public function ClassDetailMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.character = this.classesModel.getSelected();
         this.nextSkinTimer.addEventListener(TimerEvent.TIMER,this.delayedFocusSet);
         this.focusSet.add(this.onFocusSet);
         this.setCharacterData();
         this.onFocusSet();
      }
      
      override public function destroy() : void
      {
         this.focusSet.remove(this.onFocusSet);
         this.nextSkinTimer.removeEventListener(TimerEvent.TIMER,this.delayedFocusSet);
         this.view.setWalkingAnimation(null);
         this.disposeAnimations();
      }
      
      private function setCharacterData() : void
      {
         var fame:int = this.playerModel.charList.bestFame(this.character.id);
         var stars:int = FameUtil.numStars(fame);
         this.view.setData(this.character.name,this.character.description,stars,this.playerModel.charList.bestLevel(this.character.id),fame);
         var nextStarFame:int = FameUtil.nextStarFame(fame,0);
         this.view.setNextGoal(this.character.name,nextStarFame);
      }
      
      private function onFocusSet(skin:CharacterSkin = null) : void
      {
         this.nextSkin = skin = skin || this.character.skins.getSelectedSkin();
         this.nextSkinTimer.start();
      }
      
      private function delayedFocusSet(e:TimerEvent) : void
      {
         var animation:Animation = this.skins[this.nextSkin.id] = this.skins[this.nextSkin.id] || this.factory.makeWalkingIcon(this.nextSkin.template,this.nextSkin.is16x16 ? 100 : 200);
         this.view.setWalkingAnimation(animation);
      }
      
      private function disposeAnimations() : void
      {
         var id:* = null;
         var animation:Animation = null;
         for(id in this.skins)
         {
            animation = this.skins[id];
            animation.dispose();
            delete this.skins[id];
         }
      }
   }
}
