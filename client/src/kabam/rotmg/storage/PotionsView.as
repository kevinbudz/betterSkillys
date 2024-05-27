package kabam.rotmg.storage {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.LineBreakDesign;
import com.company.rotmg.graphics.DeleteXGraphic;
import com.company.ui.SimpleText;
import com.company.util.GraphicsUtil;
import com.company.util.MoreObjectUtil;
import com.gskinner.motion.GTween;

import flash.display.CapsStyle;
import flash.display.Graphics;

import flash.display.GraphicsPath;

import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;

import flash.display.Sprite;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.text.TextFieldAutoSize;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.popups.header.PopupHeader;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.AddTextLineSignal;

import org.osflash.signals.Signal;

public class PotionsView extends Sprite {

    public var gs_:GameSprite;
    internal var player:Player;
    internal var text_:String;

    public var storageContainer:Sprite;
    public var potionContainers:Vector.<PotionsContainer>;
    private var titleText_:SimpleText;
    private var closeButton_:DeleteXGraphic;
    private var lineBreak_:LineBreakDesign;

    private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(0x484848,1);
    private var lineStyle_:GraphicsStroke = new GraphicsStroke(3,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
    private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0x323232,1);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,backgroundFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
    private var listClient_:AppEngineClient;

    public function PotionsView(gs:GameSprite) {
        this.x = 55;
        this.y = 105;
        this.storageContainer = this.drawStorage();
        this.potionContainers = new Vector.<PotionsContainer>();

        this.titleText_ = new SimpleText(24, 0xFFFFFF, false, 800, 0);
        this.titleText_.setBold(true);
        this.titleText_.setText("Potion Storage");
        this.titleText_.autoSize = TextFieldAutoSize.LEFT;
        this.titleText_.x = 170;
        this.titleText_.y = 10;
        this.storageContainer.addChild(this.titleText_);

        this.closeButton_ = new DeleteXGraphic();
        this.closeButton_.x = 480 - this.closeButton_.width;
        this.closeButton_.y = 10;
        this.closeButton_.addEventListener(MouseEvent.CLICK, onClose);
        this.storageContainer.addChild(this.closeButton_);

        this.lineBreak_ = new LineBreakDesign(225, 0x242424);
        this.lineBreak_.scaleX = this.lineBreak_.scaleY = 2;
        this.lineBreak_.x = 20;
        this.lineBreak_.y = 48;
        this.storageContainer.addChild(this.lineBreak_);

        this.gs_ = gs;
        var _local5:Account = StaticInjectorContext.getInjector().getInstance(Account);
        var _local6:Object = {"num": this.gs_, "offset": 15};
        MoreObjectUtil.addToObject(_local6, _local5.getCredentials());
        this.listClient_ = StaticInjectorContext.getInjector().getInstance(AppEngineClient);
        this.listClient_.setMaxRetries(2);
        this.listClient_.complete.addOnce(this.onComplete);
        this.listClient_.sendRequest("/account/grabPotions", _local6);
    }

    private function onComplete(_arg1:Boolean, _arg2:*):void
    {
        this.getAssets(_arg2);
    }

    private function getAssets(_arg1:String):void
    {
        this.setAssets(XML(_arg1));
    }

    private function setAssets(_arg1:XML): void
    {
        var potions:String = _arg1;
        var parsed:Array = potions.split(",");
        for(var i:int = 0; i < 8; i++)
        {
            var container:PotionsContainer = new PotionsContainer(this, this.gs_.map.player_, i, parsed[i]);
            container.x = 13 + (container.width * int(i % 4)) + (i < 4 ? 8 * i : 8 * (i - 4));
            container.y = i < 4 ? 65 : 215;
            this.storageContainer.addChild(container);
            this.potionContainers.push(container);
        }
    }

    public function drawStorage():Sprite
    {
        var b:Sprite = new Sprite;
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0,0, 490, 390,8,[1,1,1,1],this.path_);
        b.graphics.drawGraphicsData(this.graphicsData_);
        addChild(b);
        return b;
    }

    public function draw():void {
        for (var i:int = 0; i < 8; i++)
            this.potionContainers[i].draw();
    }

    public function useStorage(type:int, action:int):void
    {
        this.gs_.gsc_.PotionInteraction(type, action);
    }

    public function onClose(arg1:Event):void {
        parent.removeChild(this);
    }
}
}
