package kabam.rotmg.market.utils {
import flash.display.Shape;
import flash.geom.ColorTransform;

public class TintUtils
{
    public static function addTint(shape:Shape, color:uint, alpha:Number) : void
    {
        var transform:ColorTransform = shape.transform.colorTransform;
        transform.color = color;
        var rgb:Number = alpha / (1 - (transform.redMultiplier + transform.greenMultiplier + transform.blueMultiplier) / 3);
        transform.redOffset = transform.redOffset * rgb;
        transform.greenOffset = transform.greenOffset * rgb;
        transform.blueOffset = transform.blueOffset * rgb;
        transform.redMultiplier = transform.greenMultiplier = transform.blueMultiplier = 1 - alpha;
        shape.transform.colorTransform = transform;
    }

    public static function removeTint(shape:Shape) : void
    {
        shape.transform.colorTransform = new ColorTransform();
    }
}
}
