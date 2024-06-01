// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.SnowflakeEffect

package com.company.assembleegameclient.objects.particles
{
    import flash.geom.Point;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.ColorUtil;

    public class SnowflakeEffect extends ParticleEffect 
    {

        public var start_:Point;
        public var color1_:int;
        public var color2_:int;
        public var minRad_:Number;
        public var maxRad_:Number;
        public var maxLife_:int;

        public function SnowflakeEffect(_arg_1:GameObject, _arg_2:EffectProperties)
        {
            this.color1_ = _arg_2.color;
            this.color2_ = _arg_2.color2;
            this.minRad_ = _arg_2.minRadius;
            this.maxRad_ = _arg_2.maxRadius;
            this.maxLife_ = (_arg_2.life * 1000);
            size_ = _arg_2.size;
        }

        private function run(_arg_1:int, _arg_2:int, _arg_3:int):Boolean
        {
            var _local_6:int;
            var _local_7:Number;
            var _local_8:Particle;
            var _local_4:Number = (this.minRad_ + (Math.random() * (this.maxRad_ - this.minRad_)));
            var _local_5:int;
            while (_local_5 < _arg_3)
            {
                _local_6 = ColorUtil.rangeRandomSmart(this.color1_, this.color2_);
                _local_7 = (((_local_5 * 2) * Math.PI) / _arg_3);
                _local_8 = new SnowflakeParticle(size_, _local_6, this.maxLife_, _local_7, _local_4, true);
                map_.addObj(_local_8, x_, y_);
                _local_5++;
            }
            return (false);
        }

        override public function runNormalRendering(_arg_1:int, _arg_2:int):Boolean
        {
            return (this.run(_arg_1, _arg_2, 6));
        }

        override public function runEasyRendering(_arg_1:int, _arg_2:int):Boolean
        {
            return (this.run(_arg_1, _arg_2, 6));
        }


    }
}//package com.company.assembleegameclient.objects.particles

import com.company.assembleegameclient.objects.particles.Particle;
import com.company.assembleegameclient.util.MathUtil;
import com.company.assembleegameclient.objects.particles.SparkParticle;
import com.company.assembleegameclient.util.RandomUtil;

class SnowflakeParticle extends Particle 
{

    private var timeLeft_:int;
    private var angle_:Number;
    private var radius_:Number;
    private var dx_:Number;
    private var dy_:Number;
    private var split_:Boolean;
    private var timeSplit_:int;

    public function SnowflakeParticle(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Number, _arg_5:Number, _arg_6:Boolean=false)
    {
        super(_arg_2, 0, _arg_1);
        this.timeLeft_ = _arg_3;
        this.timeSplit_ = (this.timeLeft_ * 0.5);
        this.angle_ = _arg_4;
        this.radius_ = _arg_5;
        this.dx_ = ((_arg_5 * Math.cos(_arg_4)) / this.timeLeft_);
        this.dy_ = ((_arg_5 * Math.sin(_arg_4)) / this.timeLeft_);
        this.split_ = _arg_6;
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean
    {
        this.timeLeft_ = (this.timeLeft_ - _arg_2);
        if (this.timeLeft_ <= 0)
        {
            return (false);
        }
        moveTo((x_ + (this.dx_ * _arg_2)), (y_ + (this.dy_ * _arg_2)));
        if (((this.split_) && (this.timeLeft_ < this.timeSplit_)))
        {
            map_.addObj(new SnowflakeParticle(size_, color_, this.timeLeft_, (this.angle_ + (60 * MathUtil.TO_RAD)), (this.radius_ * 0.5)), x_, y_);
            map_.addObj(new SnowflakeParticle(size_, color_, this.timeLeft_, (this.angle_ - (60 * MathUtil.TO_RAD)), (this.radius_ * 0.5)), x_, y_);
            this.split_ = false;
        }
        map_.addObj(new SparkParticle((100 * (z_ + 1)), color_, 600, z_, RandomUtil.plusMinus(1), RandomUtil.plusMinus(1)), x_, y_);
        return (true);
    }


}


