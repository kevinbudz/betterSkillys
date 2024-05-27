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
    public static const potionsToIndex:Array = [2793,2794,2591,2592,2593,2636,2612,2613];
    public static const greaterPotionsToIndex:Array = [9070,9071,9064,9065,9066,9069,9067,9068];
    public static const fillColors:Array = [0x5edddd, 0xffea55, 0xe87ee8, 0x686868, 0x70e08c, 0xfd9d3e, 0xf53434, 0x77b5f2];

    public var stats:Array;
    public var statsMax:Array;

    public var add_:Sprite;
    public var remove_:Sprite;
    private var bar_:StatusBar;
    private var icon_:Bitmap;
    public var consumeButton:TextButton;
    public var maxButton:TextButton;
    private var statType_:int;

    public var plr:Player;
    private var model_:PotionsView;
    private var amount:int;


    public function PotionsContainer(model:PotionsView, player:Player, statType:int, amount:int){
        this.model_ = model;
        this.plr = player;
        this.statType_ = statType;
        this.amount = amount;

        this.stats = [player.hp_, player.mp_, player.attack_, player.defense_, player.speed_, player.dexterity_, player.vitality_, player.wisdom_];
        this.statsMax = [player.maxHPMax_, player.maxMPMax_, player.attackMax_, player.defenseMax_, player.speedMax_, player.dexterityMax_, player.vitalityMax_, player.wisdomMax_];

        this.drawContainer();
        this.addIcons();
        this.addButtons();
        this.draw();
    }

    public function drawContainer():void
    {
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0,0,110, 145,8,[1,1,1,1],this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    public function draw():void{
        if (bar_ == null)
            return;
        this.bar_.draw(this.amount,50,0);
    }

    private function addIcons():void
    {
        var potionIcon:BitmapData = AssetLibrary.getImageFromSet("lofiObj2", potionIndexes[statType_]);
        this.icon_ = new Bitmap(potionIcon);
        this.icon_.scaleX = 4;
        this.icon_.scaleY = 4;
        this.icon_.x = 4;
        this.icon_.y = 6;
        addChild(this.icon_);

        this.add_ = new Sprite();
        var upArrow:Bitmap = new Bitmap(AssetLibrary.getImageFromSet("lofiInterface",54));
        upArrow.scaleX = 3;
        upArrow.scaleY = 3;
        this.add_.x = this.width - (upArrow.width) - 32;
        this.add_.y = 28 - upArrow.height;
        this.add_.addChild(upArrow);
        this.add_.addEventListener(MouseEvent.CLICK, function(e:Event):void { handlePotions(0); });
        addChild(this.add_);

        this.remove_ = new Sprite();
        var downArrow:Bitmap = new Bitmap(AssetLibrary.getImageFromSet("lofiInterface", 55));
        downArrow.scaleX = 3;
        downArrow.scaleY = 3;
        this.remove_.x = this.width - downArrow.width - 4;
        this.remove_.y = this.add_.y + (downArrow.height / 2) - 4;
        this.remove_.addChild(downArrow);
        this.remove_.addEventListener(MouseEvent.CLICK, function(e:Event):void { handlePotions( 1); });
        addChild(this.remove_);
    }

    private function addButtons():void
    {
        this.consumeButton = new TextButton(16, "Consume", 100);
        this.consumeButton.x = 5;
        this.consumeButton.y = 70;
        this.consumeButton.addEventListener(MouseEvent.CLICK, function(e:Event):void { handlePotions(2); });
        addChild(this.consumeButton);

        this.maxButton = new TextButton(16, "Max", 100);
        this.maxButton.x = 5;
        this.maxButton.y = 105;
        this.maxButton.addEventListener(MouseEvent.CLICK, function(e:Event):void { handlePotions(3); });
        addChild(this.maxButton);

        this.bar_ = new StatusBar(100,16, fillColors[this.statType_],0);
        this.bar_.y = 42;
        this.bar_.x = 5;
        addChild(this.bar_);
    }

    private function handlePotions(type:int)
    {
        switch (type)
        {
            case 0: // deposit via. inventory
                var len:int = this.plr.equipment_.length;
                for (var i:uint = 4; i < len; i++) {
                    if (this.plr.equipment_[i] == potionsToIndex[statType_]) {
                        this.amount += 1;
                        this.bar_.draw(this.amount,50,0);
                        break;
                    }
                    if (this.plr.equipment_[i] == greaterPotionsToIndex[statType_])
                    {
                        this.amount += 2;
                        this.bar_.draw(this.amount,50,0);
                        break;
                    }
                }
                break;
            case 1: // withdraw to inventory
                if (this.amount > 0)
                {
                    this.amount -= 1;
                    this.bar_.draw(this.amount,50,0);
                }
                break;
            case 2: // consume potion.
                if (this.amount > 0 && (this.stats[statType_] < this.statsMax[statType_]))
                {
                    this.amount -= 1;
                    this.bar_.draw(this.amount,50,0);
                }
                break;
            case 3: // max potions.
                if (this.amount >= (this.statsMax[statType_] - this.stats[statType_]))
                {
                    this.amount -= this.statsMax[statType_] - this.stats[statType_];
                    this.bar_.draw(this.amount, 50, 0);
                } else
                {
                    if (this.amount > 0)
                    {
                        this.amount = 0;
                        this.bar_.draw(this.amount, 50, 0);
                    }
                }
                break;
            default:
                break;
        }
        model_.useStorage(statType_, type);
    }
}
}
