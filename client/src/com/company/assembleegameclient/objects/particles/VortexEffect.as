// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.VortexEffect

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.util.FreeList;

    public class VortexEffect extends ParticleEffect 
    {

        public var go_:GameObject;
        public var color_:uint;
        public var rad_:Number;
        public var lastUpdate_:int = -1;

        public function VortexEffect(_arg_1:GameObject, _arg_2:EffectProperties)
        {
            this.go_ = _arg_1;
            this.color_ = _arg_2.color;
            this.color_ = _arg_2.color;
            this.rad_ = _arg_2.minRadius;
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            var _local_4:int;
            var _local_5:VortexParticle;
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
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
            var _local_3:int = int((this.lastUpdate_ / 50));
            while (_local_3 < (_arg_1 / 50))
            {
                _local_4 = (_local_3 * 50);
                _local_5 = (FreeList.newObject(VortexParticle) as VortexParticle);
                _local_5.setColor(this.color_);
                _local_6 = ((2 * Math.PI) * Math.random());
                _local_7 = (Math.cos(_local_6) * 6);
                _local_8 = (Math.sin(_local_6) * 6);
                map_.addObj(_local_5, (x_ + _local_7), (y_ + _local_8));
                _local_5.restart(_local_4, _arg_1, x_, y_);
                _local_3++;
            }
            this.lastUpdate_ = _arg_1;
            return (true);
        }


    }
}//package com.company.assembleegameclient.objects.particles

import com.company.assembleegameclient.objects.particles.Particle;
import flash.geom.Vector3D;
import com.company.assembleegameclient.util.FreeList;

class VortexParticle extends Particle 
{

    private static const G:Number = 4;

    public var startTime_:int;
    protected var moveVec_:Vector3D = new Vector3D();
    private var A:Number = (2.5 + (0.5 * Math.random()));
    private var mSize:Number = (3.5 + (2 * Math.random()));
    private var centerX_:Number;
    private var centerY_:Number;
    private var initAccelX:Number;
    private var initAccelY:Number;
    private var fSize:Number = 0;

    public function VortexParticle(_arg_1:uint=0x270068)
    {
        super(_arg_1, 1, 0);
    }

    public function restart(_arg_1:int, _arg_2:int, _arg_3:Number, _arg_4:Number):void
    {
        this.centerX_ = _arg_3;
        this.centerY_ = _arg_4;
        var _local_5:Number = ((Math.atan2((this.centerX_ - x_), (this.centerY_ - y_)) + (Math.PI / 2)) - (Math.PI / 6));
        this.initAccelX = (Math.sin(_local_5) * this.A);
        this.initAccelY = (Math.cos(_local_5) * this.A);
        z_ = 1;
        this.fSize = 0;
        size_ = this.fSize;
    }

    override public function removeFromMap():void
    {
        super.removeFromMap();
        FreeList.deleteObject(this);
    }

    override public function update(_arg_1:int, _arg_2:int):Boolean
    {
        var _local_3:Number = Math.atan2((this.centerX_ - x_), (this.centerY_ - y_));
        var _local_4:Number = 1;
        var _local_5:Number = ((Math.sin(_local_3) / _local_4) * G);
        var _local_6:Number = ((Math.cos(_local_3) / _local_4) * G);
        if (this.mSize > size_)
        {
            this.fSize = (this.fSize + (_arg_2 * 0.01));
        }
        size_ = this.fSize;
        moveTo((x_ + (((_local_5 + this.initAccelX) * _arg_2) * 0.0006)), (y_ + (((_local_6 + this.initAccelY) * _arg_2) * 0.0006)));
        z_ = (z_ + ((-0.5 * _arg_2) * 0.0006));
        return (z_ > 0);
    }


}


