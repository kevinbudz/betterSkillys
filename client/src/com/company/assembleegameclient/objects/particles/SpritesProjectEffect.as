// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.particles.SpritesProjectEffect

package com.company.assembleegameclient.objects.particles
{
    
    import flash.display.BitmapData;
    import flash.geom.Point;
    import com.company.assembleegameclient.objects.GameObject;
    import flash.utils.Timer;
    import com.company.util.AssetLibrary;
    import com.company.util.ImageSet;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import flash.events.TimerEvent;
    

    public class SpritesProjectEffect extends ParticleEffect 
    {

        public static var images:Vector.<BitmapData>;

        public var start_:Point;
        public var end_:Point;
        public var objectId:uint;
        public var go:GameObject;
        private var innerRadius:Number;
        private var outerRadius:Number;
        private var radians:Number;
        private var particleScale:uint;
        private var timer:Timer;
        private var isDestroyed:Boolean = false;

        public function SpritesProjectEffect(_arg_1:GameObject, _arg_2:Number)
        {
            this.go = _arg_1;
            if (_arg_1.texture_.height == 8)
            {
                this.innerRadius = 0;
                this.outerRadius = _arg_2;
                this.particleScale = 50;
            }
            else
            {
                this.innerRadius = 0;
                this.outerRadius = _arg_2;
                this.particleScale = 80;
            }
        }

        private function parseBitmapDataFromImageSet():void
        {
            var _local_2:uint;
            images = new Vector.<BitmapData>();
            var _local_1:ImageSet = AssetLibrary.getImageSet("lofiparticlesMusicNotes");
            var _local_3:uint = 9;
            _local_2 = 0;
            while (_local_2 < _local_3)
            {
                images.push(TextureRedrawer.redraw(_local_1.images_[_local_2], this.particleScale, true, 16764736, true));
                _local_2++;
            }
        }

        override public function update(_arg_1:int, _arg_2:int):Boolean
        {
            if (this.isDestroyed)
            {
                return (false);
            }
            if (!this.timer)
            {
                this.initialize();
            }
            x_ = this.go.x_;
            y_ = this.go.y_;
            return (true);
        }

        private function initialize():void
        {
            this.timer = new Timer(50, 1);
            this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
            this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
            this.timer.start();
            this.parseBitmapDataFromImageSet();
        }

        private function onTimer(_arg_1:TimerEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            if (map_)
            {
                _local_2 = (8 + (this.outerRadius * 2));
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    this.radians = (((_local_3 * 2) * Math.PI) / _local_2);
                    this.start_ = new Point((this.go.x_ + (Math.sin(this.radians) * this.innerRadius)), (this.go.y_ + (Math.cos(this.radians) * this.innerRadius)));
                    this.end_ = new Point((this.go.x_ + (Math.sin(this.radians) * this.outerRadius)), (this.go.y_ + (Math.cos(this.radians) * this.outerRadius)));
                    map_.addObj(new NoteParticle(this.objectId, 20, this.particleScale, this.start_, this.end_, this.radians, this.go, images), this.start_.x, this.start_.y);
                    _local_3++;
                }
            }
        }

        private function onTimerComplete(_arg_1:TimerEvent):void
        {
            this.destroy();
        }

        public function destroy():void
        {
            if (this.timer)
            {
                this.timer.removeEventListener(TimerEvent.TIMER, this.onTimer);
                this.timer.removeEventListener(TimerEvent.TIMER, this.onTimerComplete);
                this.timer.stop();
                this.timer = null;
            }
            this.go = null;
            this.isDestroyed = true;
        }

        override public function removeFromMap():void
        {
            this.destroy();
            super.removeFromMap();
        }


    }
}//package com.company.assembleegameclient.objects.particles

