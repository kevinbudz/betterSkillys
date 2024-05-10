package com.company.assembleegameclient.game {
import com.company.assembleegameclient.util.FilterUtil;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import flash.utils.getTimer;

public class GameStatistics extends Sprite {

   public var container_:Sprite;
   private var fps_:SimpleText;
   private var ping_:SimpleText;
   private var mem_:SimpleText;
   private var lastPing_:int;

   public function GameStatistics() {
      this.fps_ = new SimpleText(17, 0xFFFFFF);
      this.fps_.text = "FPS: 999";
      this.fps_.autoSize = "right";
      this.fps_.setBold(true);
      this.fps_.setAlignment("right");
      this.fps_.useTextDimensions();
      this.fps_.filters = FilterUtil.getTextOutlineFilter();
      this.fps_.y = 8;
      addChild(this.fps_);
      this.ping_ = new SimpleText(17, 0xFFFFFF);
      this.ping_.text = "PING: 999";
      this.ping_.autoSize = "right";
      this.ping_.setBold(true);
      this.ping_.setAlignment("right");
      this.ping_.useTextDimensions();
      this.ping_.filters = FilterUtil.getTextOutlineFilter();
      this.ping_.y = (this.fps_.height - 2) + 8;
      addChild(this.ping_);
      this.mem_ = new SimpleText(17, 0xFFFFFF);
      this.mem_.text = "MEM: 999.9";
      this.mem_.autoSize = "right";
      this.mem_.setBold(true);
      this.mem_.setAlignment("right");
      this.mem_.useTextDimensions();
      this.mem_.filters = FilterUtil.getTextOutlineFilter();
      this.mem_.y = (this.ping_.y + this.ping_.height - 2);
      addChild(this.mem_);
       this.container_ = new Sprite();
       this.container_.graphics.clear();
       this.container_.graphics.beginFill(0, 0);
       this.container_.graphics.drawRect(0, 0, this.width + 20, this.height);
       this.container_.graphics.endFill();
       addChild(this.container_);

       addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
       addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
   }

    private function init(e : Event) : void {
        addEventListener(Event.ENTER_FRAME, update);
    }

    private function destroy(e : Event) : void {

        while(numChildren > 0)
            removeChildAt(0);

        removeEventListener(Event.ENTER_FRAME, update);
    }

    private var timer:uint = 0;
    private var memTimer:uint = 0;
    private var fps:uint = 0;
    private var ms_prev:uint = 0;
    private var mem_prev:uint = 0;

    private function update(e:Event) : void
    {
        timer = getTimer();
        memTimer = getTimer();

        if (timer - 1000 > ms_prev)
        {
            ms_prev = timer;

            fps_.setText("FPS: " + fps);
            ping_.setText("PING: " + lastPing_);

            fps = 0;
        }

        if (timer - 5000 > mem_prev)
        {
            mem_prev = timer;
            mem_.setText("MEM: " + Number((System.totalMemory * 0.000000954).toFixed(1)));
        }
        fps++;
    }

   public function setPing(ping:int):void{
      this.lastPing_ = ping;
   }
}
}