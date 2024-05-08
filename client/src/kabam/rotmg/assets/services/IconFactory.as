// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//kabam.rotmg.assets.services.IconFactory

package kabam.rotmg.assets.services
{
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    import flash.display.BitmapData;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import com.company.util.BitmapUtil;
    import flash.display.Bitmap;

    public class IconFactory 
    {


        public static function makeCoin(_arg_1:int=40):BitmapData
        {
            var _local_2:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiObj3", 225), null, _arg_1, true, 0, 0);
            return (cropAndGlowIcon(_local_2));
        }

        public static function makeFortune():BitmapData
        {
            var _local_1:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiCharBig", 32), null, 20, true, 0, 0);
            return (cropAndGlowIcon(_local_1));
        }

        public static function makeFame(_arg_1:int=40):BitmapData
        {
            var _local_2:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiObj3", 224), null, _arg_1, true, 0, 0);
            return (cropAndGlowIcon(_local_2));
        }

        public static function makeGuildFame():BitmapData
        {
            var _local_1:BitmapData = TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiObj3", 226), null, 40, true, 0, 0);
            return (cropAndGlowIcon(_local_1));
        }

        public static function makeSupporterPointsIcon(_arg_1:int=40, _arg_2:Boolean=false):BitmapData
        {
            if (_arg_2)
            {
                return (cropAndGlowIcon(TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterfaceBig", 43), _arg_1, true, 0xFFFFFFFF, false, 5, 0x666666)));
            }
            return (cropAndGlowIcon(TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiInterfaceBig", 43), null, _arg_1, true, 0, 0)));
        }

        private static function cropAndGlowIcon(_arg_1:BitmapData):BitmapData
        {
            _arg_1 = GlowRedrawer.outlineGlow(_arg_1, 0xFFFFFFFF);
            return (BitmapUtil.cropToBitmapData(_arg_1, 10, 10, (_arg_1.width - 20), (_arg_1.height - 20)));
        }


        public function makeIconBitmap(_arg_1:int):Bitmap
        {
            var _local_2:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig", _arg_1);
            _local_2 = TextureRedrawer.redraw(_local_2, (320 / _local_2.width), true, 0);
            return (new Bitmap(_local_2));
        }


    }
}//package kabam.rotmg.assets.services

