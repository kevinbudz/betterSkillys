// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.SkyBeamEffect

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.FreeList;

    public class SkyBeamEffect extends ParticleEffect 
    {

        private static const BUBBLE_PERIOD:int = 30;

        public var go_:GameObject;
        public var color_:uint;
        public var rise_:Number;
        public var radius:Number;
        public var height_:Number;
        public var maxRadius:Number;
        public var speed_:Number;
        public var lastUpdate_:int = -1;

        public function SkyBeamEffect(_arg_1:GameObject, _arg_2:EffectProperties)
        {
            this.go_ = _arg_1;
            this.color_ = _arg_2.color;
            this.rise_ = _arg_2.rise;
            this.radius = _arg_2.minRadius;
            this.maxRadius = _arg_2.maxRadius;
            this.height_ = _arg_2.zOffset;
            this.speed_ = _arg_2.speed;
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_4:int;
            var _local_5:SkyBeamParticle;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            if (this.go_.map_ == null)
            {
                return (false);
            }
            if (this.lastUpdate_ < 0)
            {
                this.lastUpdate_ = Math.max(0, (_arg_1 - 400));
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            var _local_3:int = int(int((this.lastUpdate_ / BUBBLE_PERIOD)));
            while (_local_3 < int((_arg_1 / BUBBLE_PERIOD)))
            {
                _local_4 = (_local_3 * BUBBLE_PERIOD);
                _local_5 = (FreeList.newObject(SkyBeamParticle) as SkyBeamParticle);
                _local_5.setColor(this.color_);
                _local_5.height_ = this.height_;
                _local_5.restart(_local_4, _arg_1);
                _local_6 = ((2 * Math.random()) * Math.PI);
                _local_7 = (Math.random() * this.radius);
                _local_5.setSpeed((this.speed_ + (this.maxRadius - _local_7)));
                _local_8 = (this.go_.x_ + (_local_7 * Math.cos(_local_6)));
                _local_9 = (this.go_.y_ + (_local_7 * Math.sin(_local_6)));
                map_.addObj(_local_5, _local_8, _local_9);
                _local_3++;
            }
            this.radius = Math.min((this.radius + (this.rise_ * (_arg_2 / 1000))), this.maxRadius);
            this.lastUpdate_ = _arg_1;
            return (true);
        }


    }
}//package com.company.assembleegameclient.objects.particles

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

class SkyBeamParticle extends Particle 
{

    public var startTime_:int;
    public var speed_:Number;
    public var height_:Number;

    public function SkyBeamParticle()
    {
        var _local_1:Number = Math.random();
        super(2542335, this.height_, (80 + (_local_1 * 40)));
    }

    public function setSpeed(_arg_1:Number):void
    {
        this.speed_ = _arg_1;
    }

    public function restart(_arg_1:int, _arg_2:int):void
    {
        this.startTime_ = _arg_1;
        var _local_3:Number = ((_arg_2 - this.startTime_) / 1000);
        z_ = (this.height_ - (this.speed_ * _local_3));
    }

    override public function removeFromMap():void
    {
        super.removeFromMap();
        FreeList.deleteObject(this);
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean
    {
        var _local_3:Number = ((_arg_1 - this.startTime_) / 1000);
        z_ = (this.height_ - (this.speed_ * _local_3));
        return (z_ > 0);
    }


}


