package kabam.rotmg.ui.view.components
{
import com.company.rotmg.graphics.ScreenGraphic;

import flash.display.Graphics;
import flash.display.Sprite;
import flash.geom.Rectangle;
import io.decagames.rotmg.ui.buttons.SliceScalingButton;

public class MenuOptionsBar extends Sprite
{

    private static const Y_POSITION:Number = 520;

    private static const SPACING:int = 20;

    public static const TOP:String = "TOP";

    public static const BOTTOM:String = "BOTTOM";

    public static const CENTER:String = "CENTER";

    public static const RIGHT:String = "RIGHT";

    public static const LEFT:String = "LEFT";


    private var screenGraphic:ScreenGraphic;

    private const leftObjects:Array = [];

    private const rightObjects:Array = [];

    public function MenuOptionsBar() {
        super();
    }

    public function addButton(param1:SliceScalingButton, param2:String) : void
    {
        addChild(param1);
        switch(param2)
        {
            case CENTER:
                this.leftObjects[0] = this.rightObjects[0] = param1;
                param1.x = 800 / 2 - 50;
                param1.y = Y_POSITION;
                return;
            case LEFT:
                this.layoutToLeftOf(this.leftObjects[this.leftObjects.length - 1],param1);
                this.leftObjects.push(param1);
                return;
            case RIGHT:
                this.layoutToRightOf(this.rightObjects[this.rightObjects.length - 1],param1);
                this.rightObjects.push(param1);
                return;
            default:
                return;
        }
    }

    private function layoutToLeftOf(param1:SliceScalingButton, param2:SliceScalingButton) : void
    {
        var _loc3_:Rectangle = param1.getBounds(param1);
        var _loc4_:Rectangle = param2.getBounds(param2);
        param2.x = param1.x + _loc3_.left - _loc4_.right - SPACING;
        param2.y = Y_POSITION;
    }

    private function layoutToRightOf(param1:SliceScalingButton, param2:SliceScalingButton) : void
    {
        var _loc3_:Rectangle = param1.getBounds(param1);
        var _loc4_:Rectangle = param2.getBounds(param2);
        param2.x = param1.x + _loc3_.right - _loc4_.left + SPACING;
        param2.y = Y_POSITION;
    }
}
}
