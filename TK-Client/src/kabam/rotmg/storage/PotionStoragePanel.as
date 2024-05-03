package kabam.rotmg.storage {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextBox;
import com.company.assembleegameclient.ui.panels.ButtonPanel;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class PotionStoragePanel extends ButtonPanel {

    private var gameObject:GameObject;

    public function PotionStoragePanel(gs:GameSprite, gm:GameObject) {
        super(gs, "Potion Storage", "View");
        this.gameObject = gm;
    }

    override protected function onButtonClick(evt:MouseEvent):void {
        this.openDialog.dispatch(new PotionStorageModal(this.gs_, this.gameObject));
    }

    override protected function onKeyDown(evt:KeyboardEvent):void {
        if (evt.keyCode == Parameters.data_.interact && !TextBox.isInputtingText) {
            this.openDialog.dispatch(new PotionStorageModal(this.gs_, this.gameObject));
        }
    }

}
}
