// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.ExplosionComplexEffect

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.GameObject;

    public class ExplosionComplexEffect extends ParticleEffect 
    {

        public var go_:GameObject;
        public var color_:uint;
        public var rise_:Number;
        public var minRad_:Number;
        public var maxRad_:Number;
        public var lastUpdate_:int = -1;
        public var amount_:int;
        public var maxLife_:int;
        public var speed_:Number;
        public var bInitialized_:Boolean = false;

        public function ExplosionComplexEffect(_arg_1:GameObject, _arg_2:EffectProperties)
        {
            this.go_ = _arg_1;
            this.color_ = _arg_2.color;
            this.rise_ = _arg_2.rise;
            this.minRad_ = _arg_2.minRadius;
            this.maxRad_ = _arg_2.maxRadius;
            this.amount_ = _arg_2.amount;
            this.maxLife_ = (_arg_2.life * 1000);
            size_ = _arg_2.size;
        }

        private function run(_arg_1:int, _arg_2:int, _arg_3:int):Boolean
        {
            var _local_5:Number;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_11:ExplosionComplexParticle;
            var _local_4:int;
            while (_local_4 < _arg_3)
            {
                _local_5 = ((Math.random() * Math.PI) * 2);
                _local_6 = (this.minRad_ + (Math.random() * (this.maxRad_ - this.minRad_)));
                _local_7 = ((_local_6 * Math.cos(_local_5)) / (0.008 * this.maxLife_));
                _local_8 = ((_local_6 * Math.sin(_local_5)) / (0.008 * this.maxLife_));
                _local_9 = (Math.random() * Math.PI);
                _local_10 = 0;
                _local_11 = new ExplosionComplexParticle(this.color_, 0.2, size_, this.maxLife_, _local_7, _local_8, _local_10);
                map_.addObj(_local_11, x_, y_);
                _local_4++;
            }
            return (false);
        }

        override public function runNormalRendering(_arg_1:int, _arg_2:int):Boolean
        {
            return (this.run(_arg_1, _arg_2, this.amount_));
        }

        override public function runEasyRendering(_arg_1:int, _arg_2:int):Boolean
        {
            return (this.run(_arg_1, _arg_2, (this.amount_ / 6)));
        }


    }
}//package com.company.assembleegameclient.objects.particles

import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Vector3D;

class ExplosionComplexParticle extends Particle 
{

    public static var total_:int = 0;

    public var lifetime_:int;
    public var timeLeft_:int;
    protected var moveVec_:Vector3D = new Vector3D();
    private var deleted:Boolean = false;

    public function ExplosionComplexParticle(_arg_1:uint, _arg_2:Number, _arg_3:int, _arg_4:int, _arg_5:Number, _arg_6:Number, _arg_7:Number)
    {
        super(_arg_1, _arg_2, _arg_3);
        this.timeLeft_ = (this.lifetime_ = _arg_4);
        this.moveVec_.x = _arg_5;
        this.moveVec_.y = _arg_6;
        this.moveVec_.z = _arg_7;
        total_++;
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean
    {
        this.timeLeft_ = (this.timeLeft_ - _arg_2);
        if (this.timeLeft_ <= 0)
        {
            if (!this.deleted)
            {
                total_--;
                this.deleted = true;
            }
            return (false);
        }
        x_ = (x_ + ((this.moveVec_.x * _arg_2) * 0.008));
        y_ = (y_ + ((this.moveVec_.y * _arg_2) * 0.008));
        z_ = (z_ + ((this.moveVec_.z * _arg_2) * 0.008));
        return (true);
    }


}


