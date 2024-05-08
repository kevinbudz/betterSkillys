package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.objects.SellableObject;
   import com.company.assembleegameclient.util.Currency;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.view.RegisterPromptDialog;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class SellableObjectPanelMediator extends Mediator
   {
      
      public static const TEXT:String = "In order to use ${type} you must be a registered user.";
       
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var view:SellableObjectPanel;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      public function SellableObjectPanelMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.buyItem.add(this.onBuyItem);
      }

      override public function destroy() : void
      {
         this.view.buyItem.remove(this.onBuyItem);
      }
      
      private function onBuyItem(item:SellableObject, currencyType:int) : void
      {
         if(this.account.isRegistered())
         {
            this.view.gs_.gsc_.buy(item.objectId_,currencyType);
         }
         else
         {
            this.openDialog.dispatch(this.makeRegisterDialog(item));
         }
      }
      
      private function makeRegisterDialog(item:SellableObject) : RegisterPromptDialog
      {
         var text:String = TEXT.replace("${type}",Currency.typeToName(item.currency_));
         return new RegisterPromptDialog(text);
      }
   }
}
