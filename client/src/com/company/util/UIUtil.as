package com.company.util {
import flash.display.DisplayObject;

public class UIUtil {

    public function UIUtil() {

    }

    public static function centerXAndOffset(obj:DisplayObject, num:Number = 0):int
    {
        var width:int = WebMain.STAGE.stageWidth;
        return (width / 2 - obj.width / 2) + num;
    }

    public static function centerYAndOffset(obj:DisplayObject, num:Number = 0):int
    {
        var height:int = WebMain.STAGE.stageHeight;
        return (height / 2 - obj.height / 2) + num;
    }

}
}
