// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.AnimatedEffect

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.thrown.BitmapParticle;
    import com.company.assembleegameclient.objects.GameObject;
    
    import flash.display.BitmapData;
    import kabam.lib.math.easing.Quad;

    public class AnimatedEffect extends BitmapParticle 
    {

        public var go:GameObject;
        private var images:Vector.<BitmapData>;
        public var color1_:uint;
        public var color2_:uint;
        public var color3_:uint;
        private var percentDone:Number;
        private var startZ:Number;
        private var lifeTimeMS:int;
        private var delay:int;
        private var currentTime:int;

        public function AnimatedEffect(_arg_1:Vector.<BitmapData>, _arg_2:int, _arg_3:int, _arg_4:int)
        {
            super(_arg_1[0], _arg_2);
            this.images = _arg_1;
            this.delay = _arg_3;
            this.currentTime = 0;
            this.percentDone = 0;
            z_ = _arg_2;
            this.lifeTimeMS = _arg_4;
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:int;
            this.delay = (this.delay - _arg_2);
            if (this.delay <= 0)
            {
                this.percentDone = (this.currentTime / this.lifeTimeMS);
                _local_3 = Math.min(Math.max(0, Math.floor((this.images.length * Quad.easeOut(this.percentDone)))), (this.images.length - 1));
                _bitmapData = this.images[_local_3];
                this.currentTime = (this.currentTime + _arg_2);
                return (this.percentDone < 1);
            }
            return (this.percentDone < 1);
        }


    }
}//package com.company.assembleegameclient.objects.particles

