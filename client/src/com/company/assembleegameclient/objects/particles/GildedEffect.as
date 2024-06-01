// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.GildedEffect

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.GameObject;

    public class GildedEffect extends ParticleEffect 
    {

        public var go_:GameObject;
        public var color1_:uint;
        public var color2_:uint;
        public var color3_:uint;
        public var rad_:Number;
        public var duration_:int;
        private var numArm:int = 3;
        private var partPerArm:int = 10;
        public var delayBetweenParticles:Number = 150;
        public var particlesOffset:Number = 0;
        private var healEffectDelay:int;
        private var lastUpdate:int;
        private var healUpdate:int;
        private var runs:int;

        public function GildedEffect(_arg_1:GameObject, _arg_2:uint, _arg_3:uint, _arg_4:uint, _arg_5:Number, _arg_6:int)
        {
            this.go_ = _arg_1;
            this.color1_ = _arg_2;
            this.color2_ = _arg_3;
            this.color3_ = _arg_4;
            this.rad_ = _arg_5;
            this.duration_ = _arg_6;
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            this.particlesOffset = 0;
            this.healEffectDelay = this.duration_;
            this.lastUpdate = 0;
            this.runs = 0;
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            if ((_arg_1 - this.lastUpdate) > this.delayBetweenParticles)
            {
                if (this.runs < this.partPerArm)
                {
                    this.addParticles();
                    this.lastUpdate = _arg_1;
                    this.runs++;
                    if (this.runs >= this.numArm)
                    {
                        this.healUpdate = _arg_1;
                    }
                }
            }
            if (this.healUpdate != 0)
            {
                if ((_arg_1 - this.healUpdate) > this.healEffectDelay)
                {
                    this.go_.map_.addObj(new HealEffect(this.go_, this.color3_, this.color1_), this.go_.x_, this.go_.y_);
                    return (false);
                }
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            return (true);
        }

        private function addParticles():void
        {
            var _local_2:Number;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:GildedParticle;
            if (!map_)
            {
                return;
            }
            this.particlesOffset = (this.particlesOffset - 0.01618);
            this.healEffectDelay = (this.healEffectDelay - this.delayBetweenParticles);
            var _local_1:int;
            while (_local_1 < this.numArm)
            {
                _local_2 = ((_local_1 / this.numArm) - this.particlesOffset);
                _local_3 = (Math.cos(_local_2) * this.rad_);
                _local_4 = (Math.sin(_local_2) * this.rad_);
                _local_5 = new GildedParticle(this.go_, _local_3, _local_4, _local_2, this.rad_, this.healEffectDelay, this.color1_, this.color2_, this.color3_);
                map_.addObj(_local_5, (x_ + _local_3), (y_ + _local_4));
                _local_1++;
            }
        }


    }
}//package com.company.assembleegameclient.objects.particles

