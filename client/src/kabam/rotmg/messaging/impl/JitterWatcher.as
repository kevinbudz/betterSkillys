package kabam.rotmg.messaging.impl {
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.utils.getTimer;

public class JitterWatcher extends Sprite {
    public function JitterWatcher() {
        this.ticks_ = new Vector.<int>();

        super();

        this.text_ = new SimpleText(14, 16777215, false, 0, 0);
        this.text_.filters = [new DropShadowFilter(0, 0, 0)];

        this.addChild(this.text_);

        this.addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    private var text_:SimpleText = null;
    private var lastRecord_:int = -1;
    private var ticks_:Vector.<int>;
    private var sum_:int;

    public function get getNetJitter():int {
        return int(this.jitter());
    }

    public function record():void {
        var oldDT:int = 0;
        var t:int = getTimer();

        if (this.lastRecord_ == -1) {
            this.lastRecord_ = t;
            return;
        }

        var dt:int = t - this.lastRecord_;

        this.ticks_.push(dt);
        this.sum_ = this.sum_ + dt;

        if (this.ticks_.length > 50) {
            oldDT = this.ticks_.shift();
            this.sum_ = this.sum_ - oldDT;
        }

        this.lastRecord_ = t;
    }

    private function jitter():Number {
        var t:int = 0;
        var len:int = this.ticks_.length;

        if (len == 0)
            return 0;

        var mean:Number = this.sum_ / len;
        var variance:Number = 0;

        for each(t in this.ticks_)
            variance = variance + (t - mean) * (t - mean);

        return int(Math.sqrt(variance / len) * 10) / 10;
    }

    private function onAddedToStage(event:Event):void {
        this.stage.addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onRemovedFromStage(event:Event):void {
        this.stage.removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(event:Event):void {
        this.text_.text = "net jitter: " + int(this.jitter());
        this.text_.useTextDimensions();
    }
}
}
