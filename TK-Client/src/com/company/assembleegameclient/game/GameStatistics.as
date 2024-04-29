package com.company.assembleegameclient.game {
import com.company.assembleegameclient.util.FilterUtil;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;
import flash.utils.getTimer;

public class GameStatistics extends Sprite {

   private var fps_:SimpleText;
   private var ping_:SimpleText;
   private var mem_:SimpleText;
   private var lastPing_:int;

   public function GameStatistics() {
      this.fps_ = new SimpleText(17, 0xFFFFFF);
      this.fps_.text = "FPS";
      this.fps_.autoSize = "right";
      this.fps_.setBold(true);
      this.fps_.setAlignment("right");
      this.fps_.useTextDimensions();
      this.fps_.filters = FilterUtil.getTextOutlineFilter();
      addChild(this.fps_);
      this.ping_ = new SimpleText(17, 0xFFFFFF);
      this.ping_.text = "PING";
      this.ping_.autoSize = "right";
      this.ping_.setBold(true);
      this.ping_.setAlignment("right");
      this.ping_.useTextDimensions();
      this.ping_.filters = FilterUtil.getTextOutlineFilter();
      this.ping_.y = this.fps_.height - 2;
      addChild(this.ping_);
      this.mem_ = new SimpleText(17, 0xFFFFFF);
      this.mem_.text = "MEM";
      this.mem_.autoSize = "right";
      this.mem_.setBold(true);
      this.mem_.setAlignment("right");
      this.mem_.useTextDimensions();
      this.mem_.filters = FilterUtil.getTextOutlineFilter();
      this.mem_.y = this.ping_.y + this.ping_.height - 2;
      addChild(this.mem_);

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
    private var fps:uint = 0;
    private var ms_prev:uint = 0;

    private function update(e:Event) : void
    {
        timer = getTimer();

        if (timer - 1000 > ms_prev)
        {
            ms_prev = timer;

            fps_.setText("FPS: " + fps);
            ping_.setText("PING: " + lastPing_);
            mem_.setText("MEM: " + Number((System.totalMemory * 0.000000954).toFixed(1)));

            fps = 0;
        }
        fps++;
    }

   public function setPing(ping:int):void{
      this.lastPing_ = ping;
   }
}
}