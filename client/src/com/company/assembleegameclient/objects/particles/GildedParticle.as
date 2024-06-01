// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.GildedParticle

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.GameObject;
    import kabam.lib.math.easing.Quad;
    import com.company.util.MoreColorUtil;

    public class GildedParticle extends Particle 
    {

        private var mSize:Number = (3.5 + (2 * Math.random()));
        private var fSize:Number = 0;
        private var go:GameObject;
        private var currentLife:int;
        private var lifetimeMS:int = 2500;
        private var radius:Number;
        private var armOffset:Number = 0;
        public var color1_:uint;
        public var color2_:uint;
        public var color3_:uint;

        public function GildedParticle(_arg_1:GameObject, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number, _arg_6:int, _arg_7:uint=0x270068, _arg_8:uint=0x270068, _arg_9:uint=0x270068)
        {
            super(_arg_7, 1, 0);
            this.lifetimeMS = _arg_6;
            this.radius = _arg_5;
            this.color1_ = _arg_7;
            this.color2_ = _arg_8;
            this.color3_ = _arg_9;
            z_ = 0;
            this.fSize = 0;
            size_ = this.fSize;
            this.currentLife = 0;
            this.armOffset = _arg_4;
            this.go = _arg_1;
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:Number = (this.currentLife / this.lifetimeMS);
            if (this.mSize > size_)
            {
                this.fSize = (this.fSize + (_arg_2 * 0.01));
            }
            size_ = this.fSize;
            var _local_4:Number = Quad.easeOut(_local_3);
            var _local_5:Number = ((2 * Math.PI) * (_local_4 + this.armOffset));
            var _local_6:Number = (this.radius * (1 - _local_4));
            var _local_7:Number = (_local_6 * Math.cos(_local_5));
            var _local_8:Number = (_local_6 * Math.sin(_local_5));
            moveTo((this.go.x_ + _local_7), (this.go.y_ + _local_8));
            if (_local_3 < 0.33)
            {
                setColor(MoreColorUtil.lerpColor(this.color3_, this.color2_, this.normalizedRange(_local_3, 0, 0.33)));
            }
            else
            {
                if (_local_3 > 0.5)
                {
                    setColor(MoreColorUtil.lerpColor(this.color2_, this.color1_, this.normalizedRange(_local_3, 0.5, 1)));
                }
            }
            this.currentLife = (this.currentLife + _arg_2);
            return (_local_3 < 1);
        }

        public function normalizedRange(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number
        {
            var _local_4:Number = ((_arg_1 - _arg_2) / (_arg_3 - _arg_2));
            if (_local_4 < 0)
            {
                _local_4 = 0;
            }
            else
            {
                if (_local_4 > 1)
                {
                    _local_4 = 1;
                }
            }
            return (_local_4);
        }


    }
}//package com.company.assembleegameclient.objects.particles

