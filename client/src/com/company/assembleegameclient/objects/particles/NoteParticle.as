// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.NoteParticle

package com.company.assembleegameclient.objects.particles
{
    import com.company.assembleegameclient.objects.thrown.BitmapParticle;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.parameters.Parameters;
    
    import flash.display.BitmapData;
    import flash.geom.Point;
    import kabam.lib.math.easing.Expo;

    public class NoteParticle extends BitmapParticle 
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
        private var cameraAngle:Number = Parameters.data_.cameraAngle;
        private var images:Vector.<BitmapData>;
        private var percentageDone:Number = 0;
        private var duration:int;

        public function NoteParticle(_arg_1:uint, _arg_2:int, _arg_3:uint, _arg_4:Point, _arg_5:Point, _arg_6:Number, _arg_7:GameObject, _arg_8:Vector.<BitmapData>)
        {
            this.go = _arg_7;
            this.radians = _arg_6;
            this.images = _arg_8;
            super(_arg_8[0], 0);
            this.numFrames = _arg_8.length;
            this.dx_ = (_arg_5.x - _arg_4.x);
            this.dy_ = (_arg_5.y - _arg_4.y);
            this.originX = (_arg_4.x - _arg_7.x_);
            this.originY = (_arg_4.y - _arg_7.y_);
            _rotation = (-(_arg_6) - this.cameraAngle);
            this.duration = _arg_2;
            this.numFramesRemaining = _arg_2;
            var _local_9:uint = uint(Math.floor((Math.random() * _arg_8.length)));
            _bitmapData = _arg_8[_local_9];
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            this.numFramesRemaining--;
            if (this.numFramesRemaining <= 0)
            {
                return (false);
            }
            this.percentageDone = (1 - (this.numFramesRemaining / this.duration));
            this.plusX = (Expo.easeOut(this.percentageDone) * this.dx_);
            this.plusY = (Expo.easeOut(this.percentageDone) * this.dy_);
            if (Parameters.data_.cameraAngle != this.cameraAngle)
            {
                this.cameraAngle = Parameters.data_.cameraAngle;
                _rotation = (-(this.radians) - this.cameraAngle);
            }
            moveTo(((this.go.x_ + this.originX) + this.plusX), ((this.go.y_ + this.originY) + this.plusY));
            return (true);
        }


    }
}//package com.company.assembleegameclient.objects.particles

