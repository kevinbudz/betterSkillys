package com.company.assembleegameclient.misc
{
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

public class UILabel extends TextField
{

    public static var DEBUG:Boolean = false;


    private var chromeFixMargin:int = 2;

    public function UILabel()
    {
        super();
        if(DEBUG)
        {
            this.debugDraw();
        }
        this.embedFonts = true;
        this.selectable = false;
        this.autoSize = TextFieldAutoSize.LEFT;
    }

    private function debugDraw() : void
    {
        this.border = true;
        this.borderColor = 16711680;
    }

    override public function set y(param1:Number) : void
    {
        super.y = param1;
    }

    override public function get textWidth() : Number
    {
        return super.textWidth + 4;
    }
}
}
