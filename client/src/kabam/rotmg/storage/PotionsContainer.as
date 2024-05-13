package kabam.rotmg.storage {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.StatusBar;
import com.company.assembleegameclient.ui.TextButton;
import com.company.assembleegameclient.ui.tooltip.TextToolTip;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.game.GameSprite;
import com.company.util.BitmapUtil;
import com.company.util.GraphicsUtil;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
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

    private var fill_:GraphicsSolidFill = new GraphicsSolidFill(0x202020,1);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
    private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[fill_,path_,GraphicsUtil.END_FILL];

    public static const potionIndexes:Array = [38, 39, 52, 53, 54, 55, 48, 49];

    public var add_:Sprite;
    public var remove_:Sprite;
    private var bar_:StatusBar;
    private var icon_:Bitmap;
    public var consumeButton:TextButton;
    public var maxButton:TextButton;
    private var statType_:int;

    private var consumeTimer:Timer = new Timer(100);
    private var gs_:GameSprite;
    private var model_:PotionsView;
    private var player_:Player;

    public static const fillColors:Array = [0x5edddd, 0xffea55, 0xe87ee8, 0x686868, 0x70e08c, 0xfd9d3e, 0xf53434, 0x77b5f2];

    public function PotionsContainer(model:PotionsView, gs:GameSprite, statType:int, player:Player){

        this.player_ = player;
        model_ = model;
        gs_ = gs;
        statType_ = statType;
        this.remove_ = new Sprite();
        this.add_ = new Sprite();

        this.draw();
        this.drawContainer();

        var potionIcon:BitmapData = AssetLibrary.getImageFromSet("lofiObj2", potionIndexes[statType]);
        this.icon_ = new Bitmap(potionIcon);
        this.icon_.scaleX = 4;
        this.icon_.scaleY = 4;
        this.icon_.x = 4;
        this.icon_.y = 6;
        addChild(this.icon_);

        var upArrow:Bitmap = new Bitmap(AssetLibrary.getImageFromSet("lofiInterface",54));
        upArrow.scaleX = 3;
        upArrow.scaleY = 3;
        this.add_.x = this.width - (upArrow.width) - 32;
        this.add_.y = 28 - upArrow.height;
        this.add_.addChild(upArrow);
        addChild(this.add_);

        var downArrow:Bitmap = new Bitmap(AssetLibrary.getImageFromSet("lofiInterface", 55));
        downArrow.scaleX = 3;
        downArrow.scaleY = 3;
        this.remove_.x = this.width - downArrow.width - 4;
        this.remove_.y = this.add_.y + (downArrow.height / 2) - 4;
        this.remove_.addChild(downArrow);
        addChild(this.remove_);

        this.consumeButton = new TextButton(16, "Consume", 100);
        this.consumeButton.x = 5;
        this.consumeButton.y = 70;
        addChild(this.consumeButton);

        this.maxButton = new TextButton(16, "Max", 100);
        this.maxButton.x = 5;
        this.maxButton.y = 105;
        addChild(this.maxButton);

        this.bar_ = new StatusBar(100,16, fillColors[this.statType_],0);
        this.bar_.y = 42;
        this.bar_.x = 5;
        addChild(this.bar_);

        this.add_.addEventListener(MouseEvent.CLICK, onAddPotion);
        this.remove_.addEventListener(MouseEvent.CLICK, onRemovePotion);
        this.consumeButton.addEventListener(MouseEvent.CLICK, onConsumePotionClick);
        this.consumeButton.addEventListener(MouseEvent.MOUSE_DOWN, onConsumePotionDown);
        this.maxButton.addEventListener(MouseEvent.CLICK, onMaxPotion);
        draw();
    }


    private function onConsumePotionDown(e:Event):void {
        consumeTimer.addEventListener(TimerEvent.TIMER, onConsumePotionTick);
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

    public function drawContainer():void
    {
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0,0,110, 145,8,[1,1,1,1],this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    public function draw():void{
        switch(statType_){
            case 0: //life
                this.bar_.draw(this.player_.SPS_Life,this.player_.SPS_Life_Max,0);
                break;
            case 1://mana
                this.bar_.draw(this.player_.SPS_Mana,this.player_.SPS_Mana_Max,0);
                break;
            case 2://att
                this.bar_.draw(this.player_.SPS_Attack,this.player_.SPS_Attack_Max,0);
                break;
            case 3://def
                this.bar_.draw(this.player_.SPS_Defense,this.player_.SPS_Defense_Max,0);
                break;
            case 4://spd
                this.bar_.draw(this.player_.SPS_Speed,this.player_.SPS_Speed_Max,0);
                break;
            case 5://dex
                this.bar_.draw(this.player_.SPS_Dexterity,this.player_.SPS_Dexterity_Max,0);
                break;
            case 6://vit
                this.bar_.draw(this.player_.SPS_Vitality,this.player_.SPS_Vitality_Max,0);
                break;
            case 7://wis
                this.bar_.draw(this.player_.SPS_Wisdom,this.player_.SPS_Wisdom_Max,0);
                break;
        }
    }
}
}
