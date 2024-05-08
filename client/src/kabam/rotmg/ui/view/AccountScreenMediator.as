package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.screens.AccountScreen;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.account.core.view.AccountInfoView;
   import kabam.rotmg.account.web.view.WebAccountInfoView;
   import kabam.rotmg.core.model.PlayerModel;
   import kabam.rotmg.core.signals.HideTooltipsSignal;
   import kabam.rotmg.core.signals.ShowTooltipSignal;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class AccountScreenMediator extends Mediator
   {
       
      
      [Inject]
      public var view:AccountScreen;
      
      [Inject]
      public var account:Account;
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var showTooltip:ShowTooltipSignal;
      
      [Inject]
      public var hideTooltips:HideTooltipsSignal;
      
      public function AccountScreenMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.tooltip.add(this.onTooltip);
         this.view.setRank(this.playerModel.getNumStars());
         this.view.setGuild(this.playerModel.getGuildName(),this.playerModel.getGuildRank());
         this.view.setAccountInfo(this.getInfoView());
      }
      
      private function getInfoView() : AccountInfoView
      {
         var view:AccountInfoView = new WebAccountInfoView();
         return view;
      }
      
      override public function destroy() : void
      {
         this.view.tooltip.remove(this.onTooltip);
         this.hideTooltips.dispatch();
      }
      
      private function onTooltip(tooltip:ToolTip) : void
      {
         this.showTooltip.dispatch(tooltip);
      }
   }
}
