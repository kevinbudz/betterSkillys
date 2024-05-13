package kabam.rotmg.storage {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.StatusBar;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.util.AssetLibrary;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.game.GameSprite;
import com.company.util.BitmapUtil;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.events.TimerEvent;
import flash.filters.GlowFilter;
import flash.utils.Timer;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;


public class PotionsContainer extends Sprite{

    private var statType_:int;

    private var icon_:Bitmap;

    public var add_:Sprite;
    public var remove_:Sprite;
    public var toolTip_:TextToolTip = null;

    public var consumeButton:SliceScalingButton;
    public var maxButton:SliceScalingButton;
    public var sellButton:SliceScalingButton;

    private var consumeTimer:Timer = new Timer(100);
    private var gs_:GameSprite;
    private var model_:PotionsView;

    private var bar_:StatusBar;
    private var glowFilter:GlowFilter = new GlowFilter(0xffffff, 0.9, 4, 4, 20, 1);

    private var player_:Player;

    public static const potionIndexes:Array = [38, 39, 52, 53, 54, 55, 48, 49];

    public function PotionsContainer(model:PotionsView, gs:GameSprite, statType:int, player:Player){

        this.player_ = player;
        model_ = model;
        gs_ = gs;
        statType_ = statType;
        this.remove_ = new Sprite();
        this.add_ = new Sprite();

        draw();

        var potionIcon:BitmapData = AssetLibrary.getImageFromSet("lofiObj2", potionIndexes[statType]);
        this.icon_ = new Bitmap(potionIcon);
        this.icon_.scaleX = 4;
        this.icon_.scaleY = 4;
        this.icon_.x = 4;
        this.icon_.y = 6;
        addChild(this.icon_);

        var upArrow:BitmapData = AssetLibrary.getImageFromSet("lofiInterface",54);
        var upArrowBitmap:Bitmap = new Bitmap(upArrow);
        upArrowBitmap.scaleX = 3.5;
        upArrowBitmap.scaleY = 3.5;

        this.add_.x = this.width - (upArrowBitmap.width) - 32;
        this.add_.y = 28 - upArrowBitmap.height;
        this.toolTip_ = new TextToolTip(3552822, 10197915, null, "Deposit", 100);
        this.add_.addChild(upArrowBitmap);

        var downArrow:BitmapData = AssetLibrary.getImageFromSet("lofiInterface", 55);
        var downArrowBitmap:Bitmap = new Bitmap(downArrow);
        downArrowBitmap.scaleX = 3.5;
        downArrowBitmap.scaleY = 3.5;

        this.remove_.x = this.width - downArrowBitmap.width - 4;
        this.remove_.y = this.add_.y + (downArrowBitmap.height / 2) - 4;
        this.toolTip_ = new TextToolTip(3552822, 10197915, null, "Withdraw", 100);
        this.remove_.addChild(downArrowBitmap);

        addChild(this.add_);
        addChild(this.remove_);

        this.sellButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
        this.sellButton.width = 96;
        this.sellButton.setLabel("Sell", DefaultLabelFormat.defaultModalTitle);
        this.sellButton.x = 4;
        this.sellButton.y = this.height - this.sellButton.height - 4;
        addChild(this.sellButton);

        this.maxButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
        this.maxButton.width = 96;
        this.maxButton.setLabel("Max", DefaultLabelFormat.defaultModalTitle);
        this.maxButton.x = 4;
        this.maxButton.y = this.height - (this.maxButton.height * 2) - 4;

        addChild(this.maxButton);

        this.consumeButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "generic_green_button"));
        this.consumeButton.width = 96;
        this.consumeButton.setLabel("Drink", DefaultLabelFormat.defaultModalTitle);
        this.consumeButton.x = 4;
        this.consumeButton.y = this.height - (this.consumeButton.height * 3) - 4;

        addChild(this.consumeButton);

        this.bar_ = new StatusBar(82,14, BitmapUtil.mostCommonColor(this.icon_.bitmapData),0);
        this.bar_.filters = [glowFilter];
        this.bar_.y = this.height / 2 - 45;
        this.bar_.x = this.width / 2 - 41;

        addChild(this.bar_);

        this.add_.addEventListener(MouseEvent.CLICK, onAddPotion);
        this.remove_.addEventListener(MouseEvent.CLICK, onRemovePotion);
        this.consumeButton.addEventListener(MouseEvent.CLICK, onConsumePotionClick);
        this.consumeButton.addEventListener(MouseEvent.MOUSE_DOWN, onConsumePotionDown);
        this.sellButton.addEventListener(MouseEvent.CLICK, onSellPotion);
        this.maxButton.addEventListener(MouseEvent.CLICK, onMaxPotion);

        draw();
    }


    private function onConsumePotionDown(e:Event):void {
        consumeTimer.addEventListener(TimerEvent.TIMER, onConsumePotionTick)
        this.addEventListener(MouseEvent.MOUSE_UP, onConsumePotionUp);
        consumeTimer.start();
    }

    private function onConsumePotionUp(e:Event):void {
        //removeEventListener(Event.ENTER_FRAME, onConsumePotionTick)
        removeEventListener(TimerEvent.TIMER, onConsumePotionTick);
        consumeTimer.stop();
        consumeTimer.reset();
        this.removeEventListener(MouseEvent.MOUSE_UP, onConsumePotionUp);
    }

    private function onAddPotion(e:Event):void {
        model_.useStorage(statType_, 0);
    }

    private function onRemovePotion(e:Event):void {
        model_.useStorage(statType_, 1);
    }

    private function onConsumePotionClick(e:Event):void {
        model_.useStorage(statType_, 2);
    }

    private function onMaxPotion(e:Event):void {
        model_.useStorage(statType_, 4);
    }

    private function onConsumePotionTick(e:TimerEvent):void {
        model_.useStorage(statType_, 2);
    }

    private function onSellPotion(e:Event):void {
        model_.useStorage(statType_, 3);
    }

    public function drawContainer():void
    {

    }

    public function draw():void{
        var g:Graphics = this.graphics;
        g.clear();
        g.lineStyle(2,0x363636);
        g.beginFill(0,0.7);
        g.drawRoundRect(0, 0, 100, 180,5,5);
        g.endFill();
        if (bar_ == null)
            return;
    }
}
}
