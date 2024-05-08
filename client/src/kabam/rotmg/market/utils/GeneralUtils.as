package kabam.rotmg.market.utils {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;

public class GeneralUtils
{
    /* Add restricted values to this */
    public static function isBanned(itemType:int) : Boolean
    {
        return ObjectLibrary.isSoulbound(itemType);
    }

    /* Draw the fame icon */
    public static function getFameIcon(size:int = 40) : BitmapData
    {
        var fameBD:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
        return TextureRedrawer.redraw(fameBD,size,true,0);
    }
}
}
