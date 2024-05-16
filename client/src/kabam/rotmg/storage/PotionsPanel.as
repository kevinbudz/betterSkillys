package kabam.rotmg.storage {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextBox;
import com.company.assembleegameclient.ui.panels.ButtonPanel;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class PotionsPanel extends ButtonPanel {

    public function PotionsPanel(gs:GameSprite) {
        super(gs, "Potion Storage", "View");
    }

    override protected function onButtonClick(evt:MouseEvent):void {
        this.gs_.scaledLayer.addChild(new PotionsView(this.gs_));
    }

    override protected function onKeyDown(evt:KeyboardEvent):void {
        if (evt.keyCode == Parameters.data_.interact && !TextBox.isInputtingText) {
            this.gs_.scaledLayer.addChild(new PotionsView(this.gs_));
        }
    }

}
}
