package kabam.rotmg.emotes {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.events.TimerEvent;
import flash.geom.Matrix;
import flash.utils.Timer;

public class AnimatedEmote extends Emote {

    public static const FRAME_TIME_MS:int = 100;
    public static const TIMER:Timer = new Timer(FRAME_TIME_MS);

    public function AnimatedEmote(name:String, bitmaps:Vector.<BitmapData>, scale:Number, hq:Boolean, frameIndex:int = 0, frameTime:int = FRAME_TIME_MS) {
        super(name, bitmaps[0], scale, hq);
        this.emoteName = name;
        this.bitmaps = bitmaps;
        this.scale = scale;
        this.hq = hq;
        this.frameTime = frameTime;
        this.currFrame = frameIndex;
        this.frames = new Vector.<Bitmap>();
        for each (var bitmapData:BitmapData in bitmaps) {
            var matrix:Matrix = new Matrix();
            matrix.scale(scale, scale);
            var texture:BitmapData = new BitmapData(Math.floor(bitmapData.width * scale), Math.floor(bitmapData.height * scale), true, 0);
            texture.draw(bitmapData, matrix, null, null, null, hq);
            var shape:Shape = new Shape();
            shape.graphics.beginBitmapFill(bitmapData, matrix, false, true);
            shape.graphics.lineStyle(0, 0, 0);
            shape.graphics.drawRect(0, 0, texture.width, texture.height);
            shape.graphics.endFill();
            texture.draw(shape);
            this.frames.push(new Bitmap(texture));
        }
        TIMER.addEventListener(TimerEvent.TIMER, this.animateTexture);
        if (!TIMER.running) {
            TIMER.start();
        }
    }
    private var emoteName:String;
    private var bitmaps:Vector.<BitmapData>;
    private var scale:Number;
    private var hq:Boolean;
    private var frameTime:int;
    private var frames:Vector.<Bitmap>;
    private var currFrame:int;

    override public function clone():Emote {
        return new AnimatedEmote(this.emoteName, this.bitmaps, this.scale, this.hq, this.currFrame, this.frameTime);
    }

    private function animateTexture(e:TimerEvent):void {
        if (!this.emote || !this.emote.parent) {
            return;
        }

        this.emote.parent.removeChild(this.emote);
        this.emote = this.frames[this.currFrame];
        addChild(this.emote);
        this.currFrame++;

        if (this.currFrame >= this.frames.length) {
            this.currFrame = 0;
        }
    }
}
}