package kabam.rotmg.market {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextBox;
import com.company.assembleegameclient.ui.panels.ButtonPanel;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class MarketPanel extends ButtonPanel {

    public function MarketPanel(gs:GameSprite) {
        super(gs, "Marketplace", "Manage");
    }

    override protected function onKeyDown(evt:KeyboardEvent) : void
    {
        if(!this.gs_.mui_.setHotkeysInput_ || !this.gs_.mui_.enablePlayerInput_){
            return;
        }
        if(evt.keyCode == Parameters.data_.interact && !TextBox.isInputtingText)
        {
            this.gs_.mui_.setEnablePlayerInput(false); /* Disable player movement */
            this.gs_.mui_.setEnableHotKeysInput(false); /* Disable Hotkeys */
            this.gs_.forceScaledLayer.addChild(new MemMarket(this.gs_));
        }
    }

    override protected function onButtonClick(evt:MouseEvent):void{
        this.gs_.mui_.setEnablePlayerInput(false); /* Disable player movement */
        this.gs_.mui_.setEnableHotKeysInput(false); /* Disable Hotkeys */
        this.gs_.forceScaledLayer.addChild(new MemMarket(this.gs_));
    }


}
}
