package kabam.rotmg.statIncrease {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.LineBreakDesign;
import com.company.assembleegameclient.util.FilterUtil;
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

public class StatIncreaseView extends Sprite {

    public var gs_:GameSprite;
    internal var player:Player;

    private var container:Sprite;
    private var inset:Sprite;

    private var increaseButtons:Vector.<StatIncreaseButton>;
    private var titleText:SimpleText;
    private var closeButton:DeleteXGraphic;

    public function StatIncreaseView(gs:GameSprite) {
        this.x = 275;
        this.y = 100;

        this.gs_ = gs;

        this.addBackgroundAndInset();
        this.addHeader();
        this.addButtons();
    }

    private function addBackgroundAndInset():void
    {
        this.container = GraphicsUtil.drawBackground(250, 400, 12);
        addChild(this.container);

        this.inset = GraphicsUtil.drawInset(230, 340, 12);
        this.inset.x = 10;
        this.inset.y = 50;
        addChild(this.inset);
    }

    private function addHeader():void
    {
        this.titleText = new SimpleText(24, 0xffffff, false);
        this.titleText.setBold(true);
        this.titleText.autoSize = "center";
        this.titleText.text = "Stat Increases";
        this.titleText.filters = FilterUtil.getTextOutlineFilter();
        this.titleText.x = 250 / 2 - this.titleText.width / 2;
        this.titleText.y = 10;
        addChild(this.titleText);

        this.closeButton = new DeleteXGraphic();
        this.closeButton.x = 242 - this.closeButton.width;
        this.closeButton.y = 8;
        this.closeButton.addEventListener("click", onClose);
        addChild(this.closeButton);
    }

    private function addButtons():void
    {
        this.increaseButtons = new Vector.<StatIncreaseButton>();
        for (var i:int = 0; i < 8; i++)
        {
            this.increaseButtons[i] = new StatIncreaseButton(this, i);
            this.increaseButtons[i].x = 10;
            this.increaseButtons[i].y = 10 + (41 * i);
            this.inset.addChild(this.increaseButtons[i]);
            this.increaseButtons.push(this.increaseButtons[i]);
        }
    }

    public function onPlus(statIndex:int, amount:int):void
    {
        this.gs_.gsc_.onIncrementStat(statIndex, amount);
    }

    private function onClose(e:Event):void
    {
        parent.removeChild(this);
        stage.focus = null;
        this.gs_.mui_.setEnablePlayerInput(true);
    }
}
}
