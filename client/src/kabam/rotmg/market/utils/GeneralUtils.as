package kabam.rotmg.market.utils {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;

import kabam.rotmg.constants.ItemConstants;

public class GeneralUtils
{
    public static const weaponTypes:Array = [1, 2, 3, 8, 17, 24];
    public static const abilTypes:Array = [4, 5, 9, 11, 12, 13, 15, 16, 18, 19, 20, 21, 22, 23, 25];
    public static const armorTypes:Array = [6, 7, 14];
    public static const noMarket:Array = [0xa22, 0xa23, 0x5000, 0xab0, 0xaeb, 0x223b, 0x225e, 0x225b, 0x224c, 0x223c, 0x223d]; /* there's definitely more, definitely. */

    /* sloppy, but it'll suffice */
    public static function isBanned(itemType:int) : Boolean
    {
        if(noMarket.indexOf(itemType) >= 0)
            return true;

        var item:XML = ObjectLibrary.xmlLibrary_[itemType];
        if (item.hasOwnProperty("Soulbound"))
            return true;

        var slotType:int = int(item.SlotType);
        if (slotType == 10)
            return !(item.hasOwnProperty("Potion"));

        if (item.hasOwnProperty("Tier"))
        {
            var tier:int = int(item.Tier);
            if (weaponTypes.indexOf(slotType) >= 0)
                return tier <= 7;
            if (abilTypes.indexOf(slotType) >= 0)
                return tier <= 3;
            if (armorTypes.indexOf(slotType) >= 0)
                return tier <= 8;
        }
        return false;
    }

    /* Draw the fame icon */
    public static function getFameIcon(size:int = 40) : BitmapData
    {
        var fameBD:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
        return TextureRedrawer.redraw(fameBD,size,true,0);
    }
}
}
