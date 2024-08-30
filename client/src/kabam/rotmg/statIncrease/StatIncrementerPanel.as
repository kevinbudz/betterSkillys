package kabam.rotmg.statIncrease {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextBox;
import com.company.assembleegameclient.ui.panels.ButtonPanel;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import kabam.rotmg.statIncrease.StatIncreaseView;

public class StatIncrementerPanel extends ButtonPanel {

    public function StatIncrementerPanel(gs:GameSprite) {
        super(gs, "Stat Incrementer", "Open");
    }

    override protected function onButtonClick(evt:MouseEvent):void {
        this.gs_.scaledLayer.addChild(new StatIncreaseView(this.gs_));
        this.gs_.mui_.setEnablePlayerInput(false);
    }

    override protected function onKeyDown(evt:KeyboardEvent):void {
        if (evt.keyCode == Parameters.data_.interact && !TextBox.isInputtingText) {
            this.gs_.scaledLayer.addChild(new StatIncreaseView(this.gs_));
            this.gs_.mui_.setEnablePlayerInput(false);
        }
    }

}
}
