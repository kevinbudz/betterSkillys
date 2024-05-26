package kabam.rotmg.market {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.TextButton;
import com.company.assembleegameclient.ui.options.Options;
import com.company.assembleegameclient.ui.options.OptionsTabTitle;
import com.company.rotmg.graphics.ScreenGraphic;
import com.company.ui.SimpleText;
import com.gskinner.motion.GTween;

import flash.display.Graphics;

import flash.display.Sprite;
import flash.display3D.textures.Texture;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.system.System;
import flash.text.TextFieldAutoSize;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.popups.header.PopupHeader;
import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.utils.colors.GreyScale;

import kabam.rotmg.market.tabs.MemMarketBuyTab;

import kabam.rotmg.market.tabs.MemMarketSellTab;

import kabam.rotmg.market.tabs.MemMarketTab;
import kabam.rotmg.ui.view.components.MenuOptionsBar;

public class MemMarket extends Sprite
{
    private var gameSprite_:GameSprite;
    private var titleText_:SimpleText;
    private var closeButton_:TitleMenuOption;
    private var buyButton_:TitleMenuOption;
    private var sellButton_:TitleMenuOption;
    private var content_:Vector.<MemMarketTab>;
    private var selectedTab_:OptionsTabTitle;
    private var screenGraphic_:Sprite;
    private var background:Sprite;
    private var lines:Sprite;

    public function MemMarket(gameSprite:GameSprite)
    {
        this.gameSprite_ = gameSprite;
        this.alpha = 0;
        new GTween(this, 0.2, {"alpha": 1});

        this.background = this.drawBackground();
        addChild(this.background);

        this.lines = this.drawLine();
        addChild(this.lines);

        this.screenGraphic_ = this.makeScreenGraphic();
        addChild(this.screenGraphic_);

        /* Draw title */
        this.titleText_ = new SimpleText(24, 0xFFFFFF, false, 800, 0);
        this.titleText_.setBold(true);
        this.titleText_.setText("Marketplace");
        this.titleText_.autoSize = TextFieldAutoSize.LEFT;
        this.titleText_.filters = [new DropShadowFilter(0,0,0)];
        this.titleText_.updateMetrics();
        this.titleText_.x = 50;
        this.titleText_.y = 40;
        addChild(this.titleText_);

        this.closeButton_ = new TitleMenuOption("close",36,false);
        this.closeButton_.y = 525;
        this.closeButton_.addEventListener(MouseEvent.CLICK, onClose);
        addChild(this.closeButton_);

        this.buyButton_ = new TitleMenuOption("buy",22,false);
        this.buyButton_.addEventListener(MouseEvent.CLICK,this.onBuyClick);
        this.buyButton_.y = 535;
        addChild(this.buyButton_);

        this.sellButton_ = new TitleMenuOption("sell",22,false);
        this.sellButton_.addEventListener(MouseEvent.CLICK,this.onSellClick);
        this.sellButton_.y = 535;
        addChild(this.sellButton_);

        this.content_ = new Vector.<MemMarketTab>();
        this.addContent(new MemMarketBuyTab(this.gameSprite_));
        this.positionAssets();
        if (WebMain.STAGE)
            WebMain.STAGE.addEventListener(Event.RESIZE, positionAssets);
    }

    private function positionAssets(e:Event = null):void
    {
        var width:int = WebMain.STAGE.stageWidth;
        var height:int = WebMain.STAGE.stageHeight;
        var sWidth:* = 800 / width;
        var sHeight:* = 600 / height;
        var result:* = sHeight / sWidth;
        this.background.width = 800 * result;
        this.screenGraphic_.width = 800 * result;
        this.lines.width = 800 * result;
        this.closeButton_.x = (400 * result) - this.closeButton_.width / 2;
        this.buyButton_.x = this.closeButton_.x - 160;
        this.sellButton_.x = this.closeButton_.x + 200;
    }

    private function drawBackground():Sprite
    {
        var box:Sprite = new Sprite();
        var b:Graphics = box.graphics;
        b.clear();
        b.beginFill(2829099,0.8);
        b.drawRect(0,0,800,600);
        b.endFill();
        addChild(box);
        return box;
    }

    private function drawLine():Sprite
    {   var box:Sprite = new Sprite();
        var b:Graphics = box.graphics;
        b.lineStyle(2,6184542);
        b.moveTo(0,112);
        b.lineTo(800,112);
        b.lineStyle();
        addChild(box);
        return box;
    }

    private function makeScreenGraphic():Sprite
    {
        var box:Sprite = new Sprite();
        var b:Graphics = box.graphics;
        b.clear();
        b.beginFill(0, 0.5);
        b.drawRect(0, 525, 800, 75);
        b.endFill();
        addChild(box);
        return box;
    }

    private function onBuyClick(e:Event):void
    {
        for each (var i:MemMarketTab in this.content_)
        {
            i.dispose(); /* Clear the tab */
            removeChild(i); /* Remove it */
        }
        this.content_.length = 0;
        this.addContent(new MemMarketBuyTab(this.gameSprite_));
    }

    private function onSellClick(e:Event):void
    {
        for each (var i:MemMarketTab in this.content_)
        {
            i.dispose(); /* Clear the tab */
            removeChild(i); /* Remove it */
        }
        this.content_.length = 0;
        this.addContent(new MemMarketSellTab(this.gameSprite_));
    }

    private function addContent(content:MemMarketTab) : void
    {
        this.addChild(content);
        this.content_.push(content);
    }

    /* Remove */
    private function onClose(event:Event) : void
    {
        if (WebMain.STAGE)
            WebMain.STAGE.removeEventListener(Event.RESIZE, positionAssets);
        this.gameSprite_.mui_.setEnableHotKeysInput(true); /* Enable Hotkeys */
        this.gameSprite_.mui_.setEnablePlayerInput(true); /* Enable player movement */
        this.gameSprite_ = null;
        this.titleText_ = null;
        this.closeButton_.removeEventListener(MouseEvent.CLICK, this.onClose);
        this.closeButton_ = null;

        for each (var content:MemMarketTab in this.content_)
        {
            content.dispose(); /* Clear the tab */
            content = null;
        }
        this.content_.length = 0;
        this.content_ = null;

        this.selectedTab_ = null;

        /* Remove all children */
        for (var i:int = numChildren - 1; i >= 0; i--)
        {
            removeChildAt(i);
        }

        stage.focus = null;
        parent.removeChild(this);
    }
}
}
