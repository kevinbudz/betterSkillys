// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.InspireEffect

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.GameObject;
    
    import kabam.lib.math.easing.Back;
    

    public class InspireEffect extends ParticleEffect 
    {

        private static const LIFETIME:int = 1000;

        public var go_:GameObject;
        public var parts1_:Vector.<InspireParticle> = new Vector.<InspireParticle>();
        public var parts2_:Vector.<InspireParticle> = new Vector.<InspireParticle>();
        public var startTime_:int = -1;
        private var percentageDone:Number = 0;

        public function InspireEffect(_arg_1:GameObject, _arg_2:uint, _arg_3:int)
        {
            var _local_4:InspireParticle;
            super();
            this.go_ = _arg_1;
            var _local_5:int;
            while (_local_5 < _arg_3)
            {
                _local_4 = new InspireParticle(_arg_2, 100);
                this.parts1_.push(_local_4);
                _local_4 = new InspireParticle(_arg_2, 100);
                this.parts2_.push(_local_4);
                _local_5++;
            }
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            if (this.go_.map_ == null)
            {
                this.endEffect();
                return (false);
            }
            x_ = this.go_.x_;
            y_ = this.go_.y_;
            if (this.startTime_ < 0)
            {
                this.startTime_ = _arg_1;
            }
            var _local_3:Number = ((_arg_1 - this.startTime_) / LIFETIME);
            if (_local_3 >= 1)
            {
                this.endEffect();
                return (false);
            }
            this.updateSwirl(this.parts1_, 1, 0, _local_3);
            this.updateSwirl(this.parts2_, 1, Math.PI, _local_3);
            return (true);
        }

        private function endEffect():void
        {
            var _local_1:InspireParticle;
            for each (_local_1 in this.parts1_)
            {
                _local_1.alive_ = false;
            }
            for each (_local_1 in this.parts2_)
            {
                _local_1.alive_ = false;
            }
        }

        public function updateSwirl(_arg_1:Vector.<InspireParticle>, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            var _local_5:int;
            var _local_6:InspireParticle;
            var _local_7:Number;
            var _local_8:Number;
            var _local_9:Number;
            _local_5 = 0;
            while (_local_5 < _arg_1.length)
            {
                _local_6 = _arg_1[_local_5];
                _local_6.z_ = (((Back.easeOut(_arg_4) * 2) - 1) + (_local_5 / _arg_1.length));
                if (_local_6.z_ >= 0)
                {
                    if (_local_6.z_ > 1)
                    {
                        _local_6.alive_ = false;
                    }
                    else
                    {
                        _local_7 = (_arg_2 * ((((2 * Math.PI) * (_local_5 / _arg_1.length)) + ((2 * Math.PI) * Back.easeOut(_arg_4))) + _arg_3));
                        _local_8 = (this.go_.x_ + (0.5 * Math.cos(_local_7)));
                        _local_9 = (this.go_.y_ + (0.5 * Math.sin(_local_7)));
                        if (_local_6.map_ == null)
                        {
                            map_.addObj(_local_6, _local_8, _local_9);
                        }
                        else
                        {
                            _local_6.moveTo(_local_8, _local_9);
                        }
                    }
                }
                _local_5++;
            }
        }


    }
}//package com.company.assembleegameclient.objects.particles

import com.company.assembleegameclient.objects.particles.Particle;

class InspireParticle extends Particle 
{

    public var alive_:Boolean = true;

    public function InspireParticle(_arg_1:uint, _arg_2:int)
    {
        super(_arg_1, 0, _arg_2);
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean
    {
        return (this.alive_);
    }


}


