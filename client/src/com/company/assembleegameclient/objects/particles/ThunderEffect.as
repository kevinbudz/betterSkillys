// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.ThunderEffect

package com.company.assembleegameclient.objects.particles
{
    
    import flash.display.BitmapData;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.util.MoreColorUtil;
    import flash.geom.ColorTransform;
    import com.company.util.AssetLibrary;
    import com.company.util.ImageSet;
    import com.company.assembleegameclient.util.TextureRedrawer;
    

    public class ThunderEffect extends ParticleEffect 
    {

        private static var impactImages:Vector.<BitmapData>;
        private static var beamImages:Vector.<BitmapData>;

        public var go_:GameObject;

        public function ThunderEffect(_arg_1:GameObject)
        {
            this.go_ = _arg_1;
            x_ = this.go_.x_;
            y_ = this.go_.y_;
        }

        public static function initialize():void
        {
            beamImages = parseBitmapDataFromImageSet(6, "lofiParticlesBeam", 16768115);
            impactImages = prepareThunderImpactImages(parseBitmapDataFromImageSet(13, "lofiParticlesElectric"));
        }

        private static function prepareThunderImpactImages(_arg_1:Vector.<BitmapData>):Vector.<BitmapData>
        {
            var _local_2:int = _arg_1.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                if (_local_3 == 8)
                {
                    _arg_1[_local_3] = applyColorTransform(_arg_1[_local_3], 16768115);
                }
                else
                {
                    if (_local_3 == 7)
                    {
                        _arg_1[_local_3] = applyColorTransform(_arg_1[_local_3], 0xFFFFFF);
                    }
                    else
                    {
                        _arg_1[_local_3] = applyColorTransform(_arg_1[_local_3], 0xFF9A00);
                    }
                }
                _local_3++;
            }
            return (_arg_1);
        }

        private static function applyColorTransform(_arg_1:BitmapData, _arg_2:uint):BitmapData
        {
            var _local_3:ColorTransform = MoreColorUtil.veryGreenCT;
            _local_3.color = _arg_2;
            var _local_4:BitmapData = _arg_1.clone();
            _local_4.colorTransform(_local_4.rect, _local_3);
            return (_local_4);
        }

        private static function parseBitmapDataFromImageSet(_arg_1:uint, _arg_2:String, _arg_3:uint=0):Vector.<BitmapData>
        {
            var _local_6:uint;
            var _local_8:BitmapData;
            var _local_4:Vector.<BitmapData> = new Vector.<BitmapData>();
            var _local_5:ImageSet = AssetLibrary.getImageSet(_arg_2);
            var _local_7:uint = _arg_1;
            _local_6 = 0;
            while (_local_6 < _local_7)
            {
                _local_8 = TextureRedrawer.redraw(_local_5.images_[_local_6], 120, true, 16768115, true, 5, 16768115, 1.4);
                if (_arg_3 != 0)
                {
                    _local_8 = applyColorTransform(_local_8, _arg_3);
                }
                _local_4.push(_local_8);
                _local_6++;
            }
            return (_local_4);
        }


        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            this.runEffect();
            return (false);
        }

        private function runEffect():void
        {
            map_.addObj(new AnimatedEffect(beamImages, 2, 0, 240), x_, y_);
            map_.addObj(new AnimatedEffect(impactImages, 0, 80, 360), x_, y_);
        }


    }
}//package com.company.assembleegameclient.objects.particles

