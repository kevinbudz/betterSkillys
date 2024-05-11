package kabam.rotmg.game.view
{
import com.company.assembleegameclient.ui.tooltip.HoverTooltipDelegate;

import kabam.rotmg.dialogs.control.OpenDialogSignal;

import robotlegs.bender.bundles.mvcs.Mediator;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.ShowTooltipSignal;
import kabam.rotmg.core.signals.HideTooltipsSignal;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.assembleegameclient.map.Map;
import flash.events.MouseEvent;

public class CreditDisplayMediator extends Mediator
{

   [Inject]
   public var view:CreditDisplay;
   [Inject]
   public var model:PlayerModel;
   [Inject]
   public var showTooltipSignal:ShowTooltipSignal;
   [Inject]
   public var hideTooltipSignal:HideTooltipsSignal;
   [Inject]
   protected var openDialog:OpenDialogSignal;

   private var toolTip:TextToolTip = null;
   private var hoverTooltipDelegate:HoverTooltipDelegate;


   override public function initialize():void
   {
      this.model.creditsChanged.add(this.onCreditsChanged);
      this.model.fameChanged.add(this.onFameChanged);
      if (((!(this.view.gs == null)) && (this.view.gs.map.name_ == Map.NEXUS)))
      {
         this.view.addResourceButtons();
      }
      else
      {
         this.view.removeResourceButtons();
      }
      if (((this.view.showButton) && ((!(this.view.gs == null)) && (this.view.gs.map.name_ == Map.NEXUS))))
      {
         this.view._fameButton.addEventListener(MouseEvent.CLICK, this.view.onFameClick);
         this.toolTip = new TextToolTip(0x363636, 0x9B9B9B, "Fame", "Click to get an Overview!", 160);
         this.hoverTooltipDelegate = new HoverTooltipDelegate();
         this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
         this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
         this.hoverTooltipDelegate.setDisplayObject(this.view._fameButton);
         this.hoverTooltipDelegate.tooltip = this.toolTip;
      }
      this.view.displayFameTooltip.add(this.forceShowingTooltip);
   }

   private function forceShowingTooltip():void
   {
      if (this.toolTip)
      {
         this.hoverTooltipDelegate.getDisplayObject().dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER, true));
         this.toolTip.x = 267;
         this.toolTip.y = 41;
      }
   }

   override public function destroy():void
   {
      this.model.creditsChanged.remove(this.onCreditsChanged);
      this.model.fameChanged.remove(this.onFameChanged);
      if (((this.view.showButton) && ((!(this.view.gs == null)) && (this.view.gs.map.name_ == Map.NEXUS))))
      {
         this.view._fameButton.removeEventListener(MouseEvent.CLICK, this.view.onFameClick);
      }
      this.view.displayFameTooltip.remove(this.forceShowingTooltip);
   }

   private function onCreditsChanged(_arg_1:int):void
   {
      this.view.draw(_arg_1, this.model.getFame());
   }

   private function onFameChanged(_arg_1:int):void
   {
      this.view.draw(this.model.getCredits(), _arg_1);
   }


}
}//package kabam.rotmg.game.view

