package com.company.assembleegameclient.objects.particles
{
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;
import com.company.util.ImageSet;
import flash.display.BitmapData;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

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

    public function SpritesProjectEffect(gameObject:GameObject, outerRadius_:Number)
    {
        super();
        this.go = gameObject;
        if (gameObject.texture_.height == 8)
        {
            this.innerRadius = 0;
            this.outerRadius = outerRadius_;
            this.particleScale = 50;
        }
        else
        {
            this.innerRadius = 0;
            this.outerRadius = outerRadius_;
            this.particleScale = 80;
        }
    }

    override public function update(param1:int, param2:int) : Boolean
    {
        if (this.isDestroyed)
        {
            return false;
        }
        if (!this.timer)
        {
            this.initialize();
        }
        x_ = this.go.x_;
        y_ = this.go.y_;
        return true;
    }

    override public function removeFromMap() : void
    {
        this.destroy();
        super.removeFromMap();
    }

    public function destroy() : void
    {
        if (this.timer)
        {
            this.timer.removeEventListener("timer",this.onTimer);
            this.timer.removeEventListener("timer",this.onTimerComplete);
            this.timer.stop();
            this.timer = null;
        }
        this.go = null;
        this.isDestroyed = true;
    }

    private function parseBitmapDataFromImageSet() : void
    {
        var _loc3_:uint = 0;
        images = new Vector.<BitmapData>();
        var imageSet:ImageSet = AssetLibrary.getImageSet("lofiparticlesMusicNotes");
        while(_loc3_ < 9)
        {
            images.push(TextureRedrawer.redraw(imageSet.images_[_loc3_],this.particleScale,true,16764736,true));
            _loc3_++;
        }
    }

    private function initialize() : void
    {
        this.timer = new Timer(50,1);
        this.timer.addEventListener("timer",this.onTimer);
        this.timer.addEventListener("timerComplete",this.onTimerComplete);
        this.timer.start();
        this.parseBitmapDataFromImageSet();
    }

    private function onTimer(timerEvent:TimerEvent) : void
    {
        var i:int = 0;
        var i2:int = 0;
        if (map_)
        {
            i = 8 + this.outerRadius * 2;
            i2 = 0;
            while (i2 < i)
            {
                this.radians = i2 * 2 * 3.14159265358979 / i;
                this.start_ = new Point(this.go.x_ + Math.sin(this.radians) * this.innerRadius,this.go.y_ + Math.cos(this.radians) * this.innerRadius);
                this.end_ = new Point(this.go.x_ + Math.sin(this.radians) * this.outerRadius,this.go.y_ + Math.cos(this.radians) * this.outerRadius);
                map_.addObj(new NoteParticle(this.objectId, 20, this.particleScale, this.start_, this.end_, this.radians, this.go, images), this.start_.x, this.start_.y);
                i2++;
            }
        }
    }

    private function onTimerComplete(event:TimerEvent) : void
    {
        this.destroy();
    }
}
}