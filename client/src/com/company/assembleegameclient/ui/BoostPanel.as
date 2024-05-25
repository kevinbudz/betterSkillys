package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.utils.Timer;
import kabam.rotmg.ui.view.SignalWaiter;

import org.osflash.signals.Signal;

public class BoostPanel extends Sprite {

    public const resized:Signal = new Signal();
    private const SPACE:uint = 40;

    private var timer:Timer;
    private var player:Player;
    private var dropBoostTimer:BoostTimer;
    private var posY:int;

    public function BoostPanel(_arg1:Player) {
        this.player = _arg1;
        this.createHeader();
        this.createBoostTimers();
        this.createTimer();
    }

    private function createTimer():void {
        this.timer = new Timer(1000);
        this.timer.addEventListener(TimerEvent.TIMER, this.update);
        this.timer.start();
    }

    private function update(_arg1:TimerEvent):void {
        this.updateTimer(this.dropBoostTimer, this.player.dropBoost);
    }

    private function updateTimer(_arg1:BoostTimer, _arg2:int):void {
        if (_arg1) {
            if (_arg2) {
                _arg1.setTime(_arg2);
            }
            else {
                this.destroyBoostTimers();
                this.createBoostTimers();
            }
        }
    }

    private function createHeader():void {
        var _local2:Bitmap;
        var _local3:SimpleText;
        var _local1:BitmapData = TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterfaceBig", 22), 20, true, 0);
        _local2 = new Bitmap(_local1);
        _local2.x = -3;
        _local2.y = -1;
        addChild(_local2);
        _local3 = new SimpleText(16, 0xFF00);
        _local3.setBold(true);
        _local3.setText("Active Boosts");
        _local3.multiline = true;
        _local3.mouseEnabled = true;
        _local3.filters = [new DropShadowFilter(0, 0, 0)];
        _local3.x = 20;
        _local3.y = 4;
        addChild(_local3);
    }

    private function createBackground():void {
        graphics.clear();
        graphics.lineStyle(2, 0xFFFFFF);
        graphics.beginFill(0x333333);
        graphics.drawRoundRect(0, 0, 150, 75, 10);
        this.resized.dispatch();
    }

    private function createBoostTimers():void {
        this.posY = 25;
        var _local1:SignalWaiter = new SignalWaiter();
        this.addDropTimerIfAble(_local1);
        this.createBackground();
    }

    private function addDropTimerIfAble(_arg1:SignalWaiter):void {
        if (this.player.dropBoost) {
            this.dropBoostTimer = returnBoostTimer("1.5x Drop Rate", this.player.dropBoost);
            this.addTimer(_arg1, this.dropBoostTimer);
        }
    }

    private function addTimer(_arg1:SignalWaiter, _arg2:BoostTimer):void {
        _arg1.push(_arg2.textChanged);
        addChild(_arg2);
        _arg2.y = this.posY;
        _arg2.x = 10;
        this.posY = (this.posY + this.SPACE);
    }

    private function destroyBoostTimers():void {
        if (((this.dropBoostTimer) && (this.dropBoostTimer.parent))) {
            removeChild(this.dropBoostTimer);
        }
        this.dropBoostTimer = null;
    }

    private static function returnBoostTimer(_arg1:String, _arg2:int):BoostTimer {
        var _local3:BoostTimer = new BoostTimer();
        _local3.setLabelBuilder(_arg1);
        _local3.setTime(_arg2);
        return (_local3);
    }


}
}
