package com.company.assembleegameclient.account.ui
{
   import com.company.util.MoreObjectUtil;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.CloseDialogsSignal;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.ui.signals.NameChangedSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class NewChooseNameFrameMediator extends Mediator
   {
       
      
      [Inject]
      public var view:NewChooseNameFrame;
      
      [Inject]
      public var account:Account;

      [Inject]
      public var closeDialogs:CloseDialogsSignal;
      
      [Inject]
      public var nameChanged:NameChangedSignal;
      
      [Inject]
      public var client:AppEngineClient;
      
      private var name:String;
      
      public function NewChooseNameFrameMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
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
         if(name.length < 1)
         {
            this.view.setError("Name too short");
         }
         else
         {
            this.sendNameToServer();
         }
      }
      
      private function sendNameToServer() : void
      {
         var params:Object = {"name":this.name};
         MoreObjectUtil.addToObject(params,this.account.getCredentials());
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/account/setName",params);
         this.view.disable();
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onNameChoseDone();
         }
         else
         {
            this.onNameChoseError(data);
         }
      }
      
      private function onNameChoseDone() : void
      {
         this.nameChanged.dispatch(this.name);
         this.closeDialogs.dispatch();
      }
      
      private function onNameChoseError(error:String) : void
      {
         this.view.setError(error);
         this.view.enable();
      }
      
      private function onCancel() : void
      {
         this.closeDialogs.dispatch();
      }
   }
}
