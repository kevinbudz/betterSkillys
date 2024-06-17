package com.company.assembleegameclient.objects.particles
{
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.thrown.ThrownObject;
import com.company.assembleegameclient.parameters.Parameters;
import flash.display.BitmapData;
import flash.geom.Point;
import kabam.lib.math.easing.Expo;

public class NoteParticle extends ThrownObject
{
    private var numFramesRemaining:int;
    private var dx_:Number;
    private var dy_:Number;
    private var originX:Number;
    private var originY:Number;
    private var radians:Number;
    private var frameUpdateModulator:uint = 0;
    private var currentFrame:uint = 0;
    private var numFrames:uint;
    private var go:GameObject;
    private var plusX:Number = 0;
    private var plusY:Number = 0;
    private var cameraAngle:Number;
    private var images:Vector.<BitmapData>;
    private var percentageDone:Number = 0;
    private var duration:int;

    public function NoteParticle(param1:uint, duration_:int, param3:uint, pos_:Point, pos2_:Point, radians_:Number, gameObject:GameObject, images_:Vector.<BitmapData>)
    {
        this.cameraAngle = Parameters.data_.cameraAngle;
        this.go = gameObject;
        this.radians = radians_;
        this.images = images_;
        super(0, images_[0]);
        this.numFrames = images_.length;
        this.dx_ = pos2_.x - pos_.x;
        this.dy_ = pos2_.y - pos_.y;
        this.originX = pos_.x - gameObject.x_;
        this.originY = pos_.y - gameObject.y_;
        _rotation = -radians_ - this.cameraAngle;
        this.duration = duration_;
        this.numFramesRemaining = duration_;
        var _loc9_:uint = Math.floor(Math.random() * images_.length);
        _bitmapData = images_[_loc9_];
    }

    override public function update(param1:int, param2:int) : Boolean
    {
        this.numFramesRemaining--;
        if (this.numFramesRemaining <= 0)
        {
            return false;
        }
        this.percentageDone = 1 - this.numFramesRemaining / this.duration;
        this.plusX = Expo.easeOut(this.percentageDone) * this.dx_;
        this.plusY = Expo.easeOut(this.percentageDone) * this.dy_;
        if (Parameters.data_.cameraAngle != this.cameraAngle)
        {
            this.cameraAngle = Parameters.data_.cameraAngle;
            _rotation = -this.radians - this.cameraAngle;
        }
        moveTo(this.go.x_ + this.originX + this.plusX,this.go.y_ + this.originY + this.plusY);
        return true;
    }
}
}