// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.CircleEffect

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.GameObject;
    
    import com.company.assembleegameclient.util.ColorUtil;
    

    public class CircleEffect extends ParticleEffect 
    {

        public var go_:GameObject;
        public var color_:uint;
        public var rise_:Number;
        public var rad_:Number;
        public var maxRad_:Number;
        public var lastUpdate_:int = -1;
        public var bInitialized_:Boolean = false;
        public var amount_:int;
        public var maxLife_:int;
        public var speed_:Number;
        public var parts_:Vector.<CircleParticle> = new Vector.<CircleParticle>();

        public function CircleEffect(_arg_1:GameObject, _arg_2:EffectProperties)
        {
            this.go_ = _arg_1;
            this.color_ = _arg_2.color;
            this.rise_ = _arg_2.rise;
            this.rad_ = _arg_2.minRadius;
            this.maxRad_ = _arg_2.maxRadius;
            this.amount_ = _arg_2.amount;
            this.maxLife_ = (_arg_2.life * 1000);
            this.speed_ = _arg_2.speed;
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_3:CircleParticle;
            var _local_4:int;
            var _local_5:CircleParticle;
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
                    _local_5 = new CircleParticle(ColorUtil.randomSmart(this.color_));
                    _local_5.cX_ = x_;
                    _local_5.cY_ = y_;
                    _local_6 = (2 * Math.PI);
                    _local_7 = (_local_6 / this.amount_);
                    _local_5.startTime_ = _arg_1;
                    _local_5.angle_ = (_local_7 * _local_4);
                    _local_5.rad_ = this.rad_;
                    _local_5.speed_ = this.speed_;
                    this.parts_.push(_local_5);
                    map_.addObj(_local_5, x_, y_);
                    _local_5.move();
                    _local_4++;
                }
                this.bInitialized_ = true;
            }
            for each (_local_3 in this.parts_)
            {
                _local_3.rad_ = this.rad_;
            }
            this.rad_ = Math.min((this.rad_ + (this.rise_ * (_arg_2 / 1000))), this.maxRad_);
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
            var _local_1:CircleParticle;
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

class CircleParticle extends Particle 
{

    public var startTime_:int;
    public var speed_:Number;
    public var cX_:Number;
    public var cY_:Number;
    public var angle_:Number;
    public var rad_:Number;
    public var alive_:Boolean = true;

    public function CircleParticle(_arg_1:uint=0)
    {
        var _local_2:Number = Math.random();
        super(_arg_1, (0.2 + (Math.random() * 0.2)), (100 + (_local_2 * 20)));
    }

    override public function removeFromMap():void
    {
        super.removeFromMap();
        FreeList.deleteObject(this);
    }

    public function move():void
    {
        x_ = (this.cX_ + (this.rad_ * Math.cos(this.angle_)));
        y_ = (this.cY_ + (this.rad_ * Math.sin(this.angle_)));
        this.angle_ = (this.angle_ + this.speed_);
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean
    {
        this.move();
        return (this.alive_);
    }


}


