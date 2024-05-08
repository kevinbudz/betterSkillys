package com.company.assembleegameclient.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

public class TextPanel extends ButtonPanel {

    private var textField:SimpleText;
    private var virtualWidth:Number;
    private var virtualHeight:Number;

    public function TextPanel(_arg1:GameSprite) {
        super(_arg1, "Gift Chest is Empty", "");
        removeChild(this.button_);
    }


}
}
