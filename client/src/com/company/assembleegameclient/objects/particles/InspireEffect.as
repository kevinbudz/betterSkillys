package com.company.assembleegameclient.objects.particles
{
import com.company.assembleegameclient.objects.GameObject;
import kabam.lib.math.easing.Back;

public class InspireEffect extends ParticleEffect
{
    private static const LIFETIME:int = 1000;
    public var go_:GameObject;
    public var parts1_:Vector.<InspireParticle>;
    public var parts2_:Vector.<InspireParticle>;
    public var startTime_:int = -1;
    private var percentageDone:Number = 0;

    public function InspireEffect(object:GameObject, color:uint, count:int)
    {
        var particle:InspireParticle = null;
        this.parts1_ = new Vector.<InspireParticle>();
        this.parts2_ = new Vector.<InspireParticle>();
        super();
        this.go_ = object;
        var i:int = 0;
        while(i < count)
        {
            particle = new InspireParticle(color,100);
            this.parts1_.push(particle);
            particle = new InspireParticle(color,100);
            this.parts2_.push(particle);
            i++;
        }
    }

    override public function update(time:int, param2:int) : Boolean
    {
        if (this.go_.map_ == null)
        {
            this.endEffect();
            return false;
        }
        x_ = this.go_.x_;
        y_ = this.go_.y_;
        if (this.startTime_ < 0)
        {
            this.startTime_ = time;
        }
        var number:Number = (time - this.startTime_) / 1000;
        if (number >= 1)
        {
            this.endEffect();
            return false;
        }
        this.updateSwirl(this.parts1_, 1, 0, number);
        this.updateSwirl(this.parts2_, 1, 3.14159265358979, number);
        return true;
    }

    public function updateSwirl(particles:Vector.<InspireParticle>, number:Number, number2:Number, number3:Number) : void
    {
        var i:int = 0;
        var particle:InspireParticle = null;
        var number4:Number = NaN;
        var number5:Number = NaN;
        var number6:Number = NaN;
        while (i < particles.length)
        {
            particle = particles[i];
            particle.z_ = Back.easeOut(number3) * 2 - 1 + i / particles.length;
            if (particle.z_ >= 0)
            {
                if (particle.z_ > 1)
                {
                    particle.alive_ = false;
                }
                else
                {
                    number4 = number * (6.28318530717958 * (i / particles.length) + 6.28318530717958 * Back.easeOut(number3) + number2);
                    number5 = this.go_.x_ + 0.5 * Math.cos(number4);
                    number6 = this.go_.y_ + 0.5 * Math.sin(number4);
                    if (particle.map_ == null)
                    {
                        map_.addObj(particle,number5,number6);
                    }
                    else
                    {
                        particle.moveTo(number5,number6);
                    }
                }
            }
            i++;
        }
    }

    private function endEffect() : void
    {
        var particle:InspireParticle = null;
        for each (particle in this.parts1_)
        {
            particle.alive_ = false;
        }
        for each (particle in this.parts2_)
        {
            particle.alive_ = false;
        }
    }
}
}

import com.company.assembleegameclient.objects.particles.Particle;

class InspireParticle extends Particle
{
    public var alive_:Boolean = true;

    function InspireParticle(color:uint, size:int)
    {
        super(color, 0, size);
    }

    override public function update(param1:int, param2:int) : Boolean
    {
        return this.alive_;
    }
}