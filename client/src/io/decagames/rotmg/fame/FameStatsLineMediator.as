// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//io.decagames.rotmg.fame.FameStatsLineMediator

package io.decagames.rotmg.fame
{
import com.company.assembleegameclient.ui.tooltip.HoverTooltipDelegate;

import robotlegs.bender.bundles.mvcs.Mediator;
    import kabam.rotmg.core.signals.ShowTooltipSignal;
    import kabam.rotmg.core.signals.HideTooltipsSignal;
    import com.company.assembleegameclient.ui.tooltip.TextToolTip;

    public class FameStatsLineMediator extends Mediator 
    {

        [Inject]
        public var view:StatsLine;
        [Inject]
        public var showTooltipSignal:ShowTooltipSignal;
        [Inject]
        public var hideTooltipSignal:HideTooltipsSignal;
        private var toolTip:TextToolTip = null;
        private var hoverTooltipDelegate:HoverTooltipDelegate;


        override public function initialize():void
        {
            if (this.view.tooltipText != "")
            {
                this.toolTip = new TextToolTip(0x363636, 0x9B9B9B, "", this.view.tooltipText, 200);
                this.hoverTooltipDelegate = new HoverTooltipDelegate();
                this.hoverTooltipDelegate.setShowToolTipSignal(this.showTooltipSignal);
                this.hoverTooltipDelegate.setHideToolTipsSignal(this.hideTooltipSignal);
                this.hoverTooltipDelegate.setDisplayObject(this.view);
                this.hoverTooltipDelegate.tooltip = this.toolTip;
            }
        }

        override public function destroy():void
        {
            if (this.view.tooltipText != "")
            {
                this.hoverTooltipDelegate = null;
                this.toolTip = null;
            }
            this.view.clean();
        }


    }
}//package io.decagames.rotmg.fame

