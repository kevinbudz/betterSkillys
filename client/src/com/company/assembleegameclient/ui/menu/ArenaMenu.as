package com.company.assembleegameclient.ui.menu
{
import com.company.assembleegameclient.util.FilterUtil;
import com.company.ui.SimpleText;
import com.company.util.GraphicsUtil;
import com.company.util.RectangleUtil;
import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import flash.text.TextFieldAutoSize;
import flash.utils.Timer;

public class ArenaMenu extends Sprite
{
    private const timer:Timer = new Timer(1000);
    private var started:Boolean = false;
    private var seconds:Number = 0;

    private const downTimer:Timer = new Timer(1000);
    private var downStarted:Boolean = false;
    private var downSeconds:Number = 0;

    private var arenaText:SimpleText;
    private var waveText:SimpleText;
    private var waveValueText:SimpleText;
    private var timeText:SimpleText;
    private var timeValueText:SimpleText;
    private var currentStateText:SimpleText;

    private var background:Sprite;
    private var foreground:Sprite;

    private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0x454545,1);
    private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(0x909090,1);
    private var lineStyle_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
    private var backgroundFillNoLine_:GraphicsSolidFill = new GraphicsSolidFill(0x303030,1);

    private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,backgroundFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
    private const graphicsDataNoLine_:Vector.<IGraphicsData> = new <IGraphicsData>[backgroundFillNoLine_,path_,GraphicsUtil.END_FILL];

    public function ArenaMenu()
    {
        super();
        this.drawBackground();
        this.drawForeground();
        this.drawText();
    }

    private function drawText():void
    {
        this.arenaText = new SimpleText(18, 0xffffff, false, 800, 0);
        this.arenaText.setBold(true);
        this.arenaText.autoSize = TextFieldAutoSize.CENTER;
        this.arenaText.text = "Arena";
        this.arenaText.filters = FilterUtil.getTextOutlineFilter();
        this.arenaText.x = 125 - this.arenaText.width / 2;
        this.arenaText.y = 3;
        addChild(this.arenaText);

        this.waveText = new SimpleText(14, 0xffffff, false, 800, 0);
        this.waveText.setBold(true);
        this.waveText.autoSize = TextFieldAutoSize.CENTER;
        this.waveText.text = "Wave";
        this.waveText.filters = FilterUtil.getTextOutlineFilter();
        this.waveText.x = 190 - this.waveText.width / 2;
        this.waveText.y = 7;
        addChild(this.waveText);

        this.timeText = new SimpleText(14, 0xffffff, false, 800, 0);
        this.timeText.setBold(true);
        this.timeText.autoSize = TextFieldAutoSize.CENTER;
        this.timeText.text = "Time";
        this.timeText.filters = FilterUtil.getTextOutlineFilter();
        this.timeText.x = 60 - this.timeText.width / 2;
        this.timeText.y = 7;
        addChild(this.timeText);

        this.waveValueText = new SimpleText(28, 0xffffff, false, 800, 0);
        this.waveValueText.setBold(true);
        this.waveValueText.autoSize = TextFieldAutoSize.CENTER;
        this.waveValueText.text = "1";
        this.waveValueText.filters = FilterUtil.getTextOutlineFilter();
        this.waveValueText.x = 190 - this.waveValueText.width / 2;
        this.waveValueText.y = 22;
        addChild(this.waveValueText);

        this.timeValueText = new SimpleText(28, 0xffffff, false, 800, 0);
        this.timeValueText.setBold(true);
        this.timeValueText.autoSize = TextFieldAutoSize.CENTER;
        this.timeValueText.text = "00:00";
        this.timeValueText.filters = FilterUtil.getTextOutlineFilter();
        this.timeValueText.x = 60 - this.timeValueText.width / 2;
        this.timeValueText.y = 22;
        addChild(this.timeValueText);

        this.currentStateText = new SimpleText(14, 0xaaaaaa, false, 800, 0);
        this.currentStateText.setBold(true);
        this.currentStateText.autoSize = TextFieldAutoSize.CENTER;
        this.currentStateText.filters = FilterUtil.getTextOutlineFilter();
        this.currentStateText.x = 125 - this.currentStateText.width / 2;
        addChild(this.currentStateText);
    }

    private function startTimer():void
    {
        this.started = true;
        this.timer.addEventListener(TimerEvent.TIMER, this.updateTimer);
        this.timer.start();
    }

    private function startDownTimer():void
    {
        this.downStarted = true;
        this.downTimer.addEventListener(TimerEvent.TIMER, this.updateTimer);
        this.downTimer.start();
    }

    private function updateTimer(e:TimerEvent = null):void
    {
        var _local2:int = (this.seconds / 60);
        var _local3:int = (this.seconds % 60);
        var _local4:String = (((_local2 < 10)) ? "0" : "");
        _local4 = (_local4 + (_local2 + ":"));
        _local4 = (_local4 + (((_local3 < 10)) ? "0" : ""));
        _local4 = (_local4 + _local3);
        this.timeValueText.text = _local4;
        this.timeValueText.updateMetrics();
        this.timeValueText.x = 60 - this.timeValueText.width / 2;
        this.seconds++;
    }

    public function onWaveInfo(runtime:int, wave:int, state:int):void
    {
        this.waveValueText.text = wave.toString();
        this.waveValueText.updateMetrics();
        this.waveValueText.x = 190 - this.waveValueText.width / 2;
        if (state == 1)
        {
            if (!this.started)
                startTimer();
        }
        else
        {
            seconds = int(runtime / 1000);
        }
    }

    public function drawForeground():void
    {
        this.foreground = new Sprite();
        addChild(this.foreground);
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(5,25,240, 30,8,[1,1,1,1],this.path_);
        this.foreground.graphics.drawGraphicsData(this.graphicsDataNoLine_);
    }

    private function drawBackground():void
    {
        this.background = new Sprite();
        addChild(this.background);
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0,0,250,60,8,[1,1,1,1],this.path_);
        this.background.graphics.drawGraphicsData(this.graphicsData_);
    }
}
}
