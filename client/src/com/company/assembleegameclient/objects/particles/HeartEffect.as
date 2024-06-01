// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.HeartEffect

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.ColorUtil;

    public class HeartEffect extends ParticleEffect 
    {

        public var go_:GameObject;
        public var color_:uint;
        public var color2_:uint;
        public var rise_:Number;
        public var rad_:Number;
        public var maxRad_:Number;
        public var lastUpdate_:int = -1;
        public var bInitialized_:Boolean = false;
        public var amount_:int;
        public var maxLife_:int;
        public var speed_:Number;
        public var parts_:Vector.<HeartParticle> = new Vector.<HeartParticle>();

        public function HeartEffect(_arg_1:GameObject, _arg_2:EffectProperties)
        {
            this.go_ = _arg_1;
            this.color_ = _arg_2.color;
            this.color2_ = _arg_2.color2;
            this.rise_ = _arg_2.rise;
            this.rad_ = _arg_2.minRadius;
            this.maxRad_ = _arg_2.maxRadius;
            this.amount_ = _arg_2.amount;
            this.maxLife_ = (_arg_2.life * 1000);
            this.speed_ = (_arg_2.speed / (2 * Math.PI));
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:HeartParticle;
            var _local_4:int;
            var _local_5:HeartParticle;
            var _local_6:Number;
            var _local_7:Number;
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
            if (!this.bInitialized_)
            {
                _local_4 = 0;
                while (_local_4 < this.amount_)
                {
                    _local_5 = new HeartParticle(ColorUtil.rangeRandomSmart(this.color_, this.color2_));
                    _local_5.cX_ = x_;
                    _local_5.cY_ = y_;
                    _local_6 = (2 * Math.PI);
                    _local_7 = (_local_6 / this.amount_);
                    _local_5.restart((_arg_1 + ((_local_7 * _local_4) * 1000)), _arg_1);
                    _local_5.rad_ = this.rad_;
                    this.parts_.push(_local_5);
                    map_.addObj(_local_5, x_, y_);
                    _local_5.z_ = (0.4 + (Math.sin(((_local_7 * _local_4) * 1.5)) * 0.05));
                    _local_4++;
                }
                this.bInitialized_ = true;
            }
            for each (_local_3 in this.parts_)
            {
                _local_3.rad_ = this.rad_;
            }
            if (this.maxLife_ <= 500)
            {
                this.rad_ = Math.max((this.rad_ - ((2 * this.maxRad_) * (_arg_2 / 1000))), 0);
            }
            else
            {
                this.rad_ = Math.min((this.rad_ + (this.rise_ * (_arg_2 / 1000))), this.maxRad_);
            }
            this.maxLife_ = (this.maxLife_ - _arg_2);
            if (this.maxLife_ <= 0)
            {
                this.endEffect();
                return (false);
            }
            this.lastUpdate_ = _arg_1;
            return (true);
        }

        private function endEffect():void
        {
            var _local_1:HeartParticle;
            for each (_local_1 in this.parts_)
            {
                _local_1.alive_ = false;
            }
        }

        override public function removeFromMap():void
        {
            this.endEffect();
            super.removeFromMap();
        }


    }
}//package com.company.assembleegameclient.objects.particles

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.FreeList;

class HeartParticle extends Particle 
{

    public var startTime_:int;
    public var cX_:Number;
    public var cY_:Number;
    public var rad_:Number;
    public var alive_:Boolean = true;
    public var speed_:Number;
    private var radVar_:Number = (0.97 + (Math.random() * 0.06));

    public function HeartParticle(_arg_1:uint=0xFF0000)
    {
        super(_arg_1, 0, (140 + (Math.random() * 40)));
    }

    private function move(_arg_1:Number):void
    {
        x_ = (this.cX_ + (((((16 * Math.sin(_arg_1)) * Math.sin(_arg_1)) * Math.sin(_arg_1)) / 16) * (this.rad_ * this.radVar_)));
        y_ = (this.cY_ - ((((((13 * Math.cos(_arg_1)) - (5 * Math.cos((2 * _arg_1)))) - (2 * Math.cos((3 * _arg_1)))) - Math.cos((4 * _arg_1))) / 16) * (this.rad_ * this.radVar_)));
    }

    public function restart(_arg_1:int, _arg_2:int):void
    {
        this.startTime_ = _arg_1;
        var _local_3:Number = ((_arg_2 - this.startTime_) / 1000);
        this.move(_local_3);
    }

    override public function removeFromMap():void
    {
        super.removeFromMap();
        FreeList.deleteObject(this);
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean
    {
        var _local_3:Number = ((_arg_1 - this.startTime_) / 1000);
        this.move(_local_3);
        return (this.alive_);
    }


}


