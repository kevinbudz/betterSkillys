package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.game.events.NameResultEvent;
   import com.company.assembleegameclient.parameters.Parameters;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.ui.signals.NameChangedSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ChooseNameFrameMediator extends Mediator
   {
       
      
      [Inject]
      public var view:ChooseNameFrame;
      
      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var nameChanged:NameChangedSignal;
      
      private var gameSprite:GameSprite;
      
      private var name:String;
      
      public function ChooseNameFrameMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.gameSprite = this.view.gameSprite;
         this.view.choose.add(this.onChoose);
         this.view.cancel.add(this.onCancel);
      }
      
      override public function destroy() : void
      {
         this.view.choose.remove(this.onChoose);
         this.view.cancel.remove(this.onCancel);
      }
      
      private function onChoose(name:String) : void
      {
         this.name = name;
         this.gameSprite.addEventListener(NameResultEvent.NAMERESULTEVENT,this.onNameResult);
         this.gameSprite.gsc_.chooseName(name);
         this.view.disable();
      }
      
      public function onNameResult(event:NameResultEvent) : void
      {
         this.gameSprite.removeEventListener(NameResultEvent.NAMERESULTEVENT,this.onNameResult);
         var isSuccess:Boolean = event.m_.success_;
         if(isSuccess)
         {
            this.handleSuccessfulNameChange();
         }
         else
         {
            this.handleFailedNameChange(event.m_.errorText_);
         }
      }
      
      private function handleSuccessfulNameChange() : void
      {
         this.gameSprite.model.setName(this.name);
         this.closeDialogs.dispatch();
         this.nameChanged.dispatch(this.name);
      }
      
      private function handleFailedNameChange(errorText:String) : void
      {
         this.view.setError(errorText);
         this.view.enable();
      }
      
      private function onCancel() : void
      {
         this.closeDialogs.dispatch();
      }
   }
}
