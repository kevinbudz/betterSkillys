package kabam.rotmg.storage {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.util.GraphicsUtil;
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
import flash.filters.GlowFilter;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.popups.header.PopupHeader;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.AddTextLineSignal;

import org.osflash.signals.Signal;

public class PotionsView extends Sprite {

    public var gs_:GameSprite;
    public var gO_:GameObject;

    internal var player:Player;
    internal var text_:String;

    public var storageContainer:Sprite;
    public var potionContainers:Vector.<PotionsContainer>;
    private var closeButton_:TitleMenuOption;

    private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(0x484848,1);
    private var lineStyle_:GraphicsStroke = new GraphicsStroke(3,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
    private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0x323232,1);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,backgroundFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];

    public function PotionsView(gs:GameSprite, gm:GameObject) {
        this.x = 50;
        this.y = 100;

        this.gs_ = gs;
        this.gO_ = gm;
        this.player = gm as Player;
        this.gs_.map.player_.SPS_Modal = this;

        this.alpha = 0;
        new GTween(this, 0.2, {"alpha": 1});

        this.storageContainer = this.drawStorage();
        this.potionContainers = new Vector.<PotionsContainer>();
        for(var i:int = 0; i < 8; i++)
        {
            var container:PotionsContainer = new PotionsContainer(this, this.gs_, i, this.player);
            container.x = 20 + (container.width * int(i % 4)) + (i < 4 ? 5 * i : 5 * (i - 4));
            container.y = i < 4 ? 20 : 200;
            this.storageContainer.addChild(container);
            this.potionContainers.push(container);
        }

        this.makeScreenGraphic();
        this.closeButton_ = new TitleMenuOption("close",36,false);
        this.closeButton_.x = 400 - this.closeButton_.width / 2;
        this.closeButton_.y = 525;
        this.closeButton_.addEventListener(MouseEvent.CLICK, onClose);
        addChild(this.closeButton_);
    }

    public function drawStorage():Sprite
    {
        var b:Sprite = new Sprite;
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0,0, 500, 400,8,[1,1,1,1],this.path_);
        b.graphics.drawGraphicsData(this.graphicsData_);
        addChild(b);
        return b;
    }

    private function makeScreenGraphic():void
    {
        var box:Sprite = new Sprite();
        var b:Graphics = box.graphics;
        b.clear();
        b.beginFill(0, 0.5);
        b.drawRect(0, 525, 800, 75);
        b.endFill();
        addChild(box);
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
        this.gs_.map.player_.SPS_Modal = null;
        parent.removeChild(this);
    }
}
}
