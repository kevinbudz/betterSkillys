// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//kabam.rotmg.assets.services.CharacterFactory

package kabam.rotmg.assets.services
{
    import com.company.assembleegameclient.util.AnimatedChars;
    import kabam.rotmg.assets.model.CharacterTemplate;
    import com.company.assembleegameclient.util.AnimatedChar;
    import flash.display.BitmapData;
    import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
    import com.company.util.BitmapUtil;
    import kabam.rotmg.assets.model.Animation;
    import com.company.assembleegameclient.util.MaskedImage;
    import com.company.assembleegameclient.util.TextureRedrawer;

    public class CharacterFactory 
    {

        private var texture1:int;
        private var texture2:int;
        private var size:int;


        public function makeCharacter(_arg_1:CharacterTemplate):AnimatedChar
        {
            return (AnimatedChars.getAnimatedChar(_arg_1.file, _arg_1.index));
        }

        public function makeIcon(_arg_1:CharacterTemplate, _arg_2:int=100, _arg_3:int=0, _arg_4:int=0, _arg_5:Boolean=false):BitmapData
        {
            this.texture1 = _arg_3;
            this.texture2 = _arg_4;
            this.size = _arg_2;
            var _local_6:AnimatedChar = this.makeCharacter(_arg_1);
            var _local_7:BitmapData = this.makeFrame(_local_6, AnimatedChar.STAND, 0);
            _local_7 = GlowRedrawer.outlineGlow(_local_7, ((_arg_5) ? 0xFF0000 : 0));
            _local_7 = BitmapUtil.cropToBitmapData(_local_7, 6, 6, (_local_7.width - 12), (_local_7.height - 6));
            return (_local_7);
        }

        public function makeWalkingIcon(_arg_1:CharacterTemplate, _arg_2:int=100, _arg_3:int=0, _arg_4:int=0):Animation
        {
            this.texture1 = _arg_3;
            this.texture2 = _arg_4;
            this.size = _arg_2;
            var _local_5:AnimatedChar = this.makeCharacter(_arg_1);
            var _local_6:BitmapData = this.makeFrame(_local_5, AnimatedChar.WALK, 0.5);
            _local_6 = GlowRedrawer.outlineGlow(_local_6, 0);
            var _local_7:BitmapData = this.makeFrame(_local_5, AnimatedChar.WALK, 0);
            _local_7 = GlowRedrawer.outlineGlow(_local_7, 0);
            var _local_8:Animation = new Animation();
            _local_8.setFrames(_local_6, _local_7);
            return (_local_8);
        }

        private function makeFrame(_arg_1:AnimatedChar, _arg_2:int, _arg_3:Number):BitmapData
        {
            var _local_4:MaskedImage = _arg_1.imageFromDir(AnimatedChar.RIGHT, _arg_2, _arg_3);
            return (TextureRedrawer.resize(_local_4.image_, _local_4.mask_, this.size, false, this.texture1, this.texture2));
        }


    }
}//package kabam.rotmg.assets.services

