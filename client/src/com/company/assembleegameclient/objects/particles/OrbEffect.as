// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.OrbEffect

package com.company.assembleegameclient.objects.particles
{
    
    import flash.display.BitmapData;
    import com.company.assembleegameclient.objects.GameObject;
    import flash.geom.Point;
    import com.company.util.MoreColorUtil;
    import flash.geom.ColorTransform;
    import com.company.util.AssetLibrary;
    import com.company.util.ImageSet;
    import com.company.assembleegameclient.util.TextureRedrawer;
    

    public class OrbEffect extends ParticleEffect 
    {

        public static var images:Vector.<BitmapData>;

        public var go_:GameObject;
        public var color1_:uint;
        public var color2_:uint;
        public var color3_:uint;
        public var duration_:int;
        public var rad_:Number;
        public var target_:Point;

        public function OrbEffect(_arg_1:GameObject, _arg_2:uint, _arg_3:uint, _arg_4:uint, _arg_5:Number, _arg_6:int, _arg_7:Point)
        {
            this.go_ = _arg_1;
            this.color1_ = _arg_2;
            this.color2_ = _arg_3;
            this.color3_ = _arg_4;
            this.rad_ = _arg_5;
            this.duration_ = _arg_6;
            this.target_ = _arg_7;
        }

        public static function initialize():void
        {
            images = parseBitmapDataFromImageSet("lofiParticlesSkull");
        }

        private static function apply(_arg_1:BitmapData, _arg_2:uint):BitmapData
        {
            var _local_3:ColorTransform = MoreColorUtil.veryGreenCT;
            _local_3.color = _arg_2;
            var _local_4:BitmapData = _arg_1.clone();
            _local_4.colorTransform(_local_4.rect, _local_3);
            return (_local_4);
        }

        private static function parseBitmapDataFromImageSet(_arg_1:String):Vector.<BitmapData>
        {
            var _local_4:uint;
            var _local_6:BitmapData;
            var _local_2:Vector.<BitmapData> = new Vector.<BitmapData>();
            var _local_3:ImageSet = AssetLibrary.getImageSet(_arg_1);
            var _local_5:uint = _local_3.images_.length;
            _local_4 = 0;
            while (_local_4 < _local_5)
            {
                _local_6 = TextureRedrawer.redraw(_local_3.images_[_local_4], 120, true, 11673446, true, 5, 11673446, 1.4);
                if (_local_4 == 8)
                {
                    _local_6 = apply(_local_6, 11673446);
                }
                else
                {
                    _local_6 = apply(_local_6, 3675232);
                }
                _local_2.push(_local_6);
                _local_4++;
            }
            return (_local_2);
        }


        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            x_ = this.target_.x;
            y_ = this.target_.y;
            map_.addObj(new SkullEffect(this.target_, images), this.target_.x, this.target_.y);
            return (false);
        }


    }
}//package com.company.assembleegameclient.objects.particles

