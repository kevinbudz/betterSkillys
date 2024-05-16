package com.company.assembleegameclient.screens
{
import com.company.assembleegameclient.ui.ClickableText;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.rotmg.graphics.ScreenGraphic;
import com.company.ui.SimpleText;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.game.view.CreditDisplay;
import kabam.rotmg.news.view.NewsView;
import kabam.rotmg.ui.view.components.ScreenBase;
import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeMappedSignal;

public class CharacterSelectionAndNewsScreen extends Sprite
{


    private const SCROLLBAR_REQUIREMENT_HEIGHT:Number = 400;

    private const DROP_SHADOW:DropShadowFilter = new DropShadowFilter(0,0,0,1,8,8);

    private var model:PlayerModel;

    private var isInitialized:Boolean;

    private var nameText:SimpleText;

    private var nameChooseLink_:ClickableText;

    private var creditDisplay:CreditDisplay;

    private var selectACharacterText:SimpleText;

    private var newsText:SimpleText;

    private var characterList:CharacterList;

    private var characterListHeight:Number;

    private var playButton:TitleMenuOption;

    private var backButton:TitleMenuOption;

    private var classesButton:TitleMenuOption;

    private var lines:Shape;

    private var scrollBar:Scrollbar;

    public var close:Signal;

    public var showClasses:Signal;

    public var newCharacter:Signal;

    public var chooseName:Signal;

    public var playGame:Signal;

    public function CharacterSelectionAndNewsScreen()
    {
        this.playButton = new TitleMenuOption("play",36,true);
        this.backButton = new TitleMenuOption("main",22,false);
        this.classesButton = new TitleMenuOption("classes",22,false);
        this.newCharacter = new Signal();
        this.chooseName = new Signal();
        this.playGame = new Signal();
        super();
        addChild(new ScreenBase());
        addChild(new AccountScreen());
        this.close = new NativeMappedSignal(this.backButton,MouseEvent.CLICK);
        this.showClasses = new NativeMappedSignal(this.classesButton,MouseEvent.CLICK);
    }

    public function initialize(model:PlayerModel) : void
    {
        if(this.isInitialized)
        {
            return;
        }
        this.isInitialized = true;
        this.model = model;
        this.createDisplayAssets(model);
    }

    private function createDisplayAssets(model:PlayerModel) : void
    {
        this.createNameText();
        this.createCreditDisplay();
        this.createSelectCharacterText();
        this.createNewsText();
        this.createNews();
        this.createBoundaryLines();
        this.createCharacterList();
        this.createButtons();
        this.positionButtons();
        if(this.characterListHeight > this.SCROLLBAR_REQUIREMENT_HEIGHT)
        {
            this.createScrollbar();
        }
    }

    private function createButtons() : void
    {
        var box:Sprite = new Sprite();
        var b:Graphics = box.graphics;
        b.clear();
        b.beginFill(0, 0.5);
        b.drawRect(0, 525, 800, 75);
        b.endFill();
        addChild(box);

        addChild(this.playButton);
        addChild(this.backButton);
        addChild(this.classesButton);
        this.playButton.addEventListener(MouseEvent.CLICK,this.onPlayClick);
    }

    private function positionButtons() : void
    {
        this.playButton.x = (this.getReferenceRectangle().width - this.playButton.width) / 2;
        this.playButton.y = 525;
        this.backButton.x = (this.getReferenceRectangle().width - this.backButton.width) / 2 - 94;
        this.backButton.y = 535;
        this.classesButton.x = (this.getReferenceRectangle().width - this.classesButton.width) / 2 + 96;
        this.classesButton.y = 535;
    }

    private function createNews() : void
    {
        var news:NewsView = null;
        news = new NewsView();
        news.x = 630;
        news.y = 117;
        addChild(news);
    }

    private function createScrollbar() : void
    {
        this.scrollBar = new Scrollbar(16,399);
        this.scrollBar.x = 543;
        this.scrollBar.y = 113;
        this.scrollBar.setIndicatorSize(399,this.characterList.height);
        this.scrollBar.addEventListener(Event.CHANGE,this.onScrollBarChange);
        addChild(this.scrollBar);
    }

    private function createCharacterList() : void
    {
        this.characterList = new CharacterList(this.model);
        this.characterList.x = 58;
        this.characterList.y = 105;
        this.characterListHeight = this.characterList.height;
        addChild(this.characterList);
    }

    private function createNewsText() : void
    {
        this.newsText = new SimpleText(18,11776947,false,0,0);
        this.newsText.setBold(true);
        this.newsText.text = "News";
        this.newsText.updateMetrics();
        this.newsText.filters = [this.DROP_SHADOW];
        this.newsText.x = 493;
        this.newsText.y = 74;
        //addChild(this.newsText);
    }

    private function createSelectCharacterText() : void
    {
        this.selectACharacterText = new SimpleText(18,11776947,false,0,0);
        this.selectACharacterText.setBold(true);
        this.selectACharacterText.text = "Characters";
        this.selectACharacterText.updateMetrics();
        this.selectACharacterText.filters = [this.DROP_SHADOW];
        this.selectACharacterText.x = 34;
        this.selectACharacterText.y = 74;
        addChild(this.selectACharacterText);
    }

    private function createCreditDisplay() : void
    {
        this.creditDisplay = new CreditDisplay();
        this.creditDisplay.draw(this.model.getCredits(),this.model.getFame());
        this.creditDisplay.x = this.getReferenceRectangle().width;
        this.creditDisplay.y = 32;
        addChild(this.creditDisplay);
    }

    private function createChooseNameLink() : void
    {
        this.nameChooseLink_ = new ClickableText(16,false,"choose name");
        this.nameChooseLink_.y = 50;
        this.nameChooseLink_.x = this.getReferenceRectangle().width / 2 - this.nameChooseLink_.width / 2;
        this.nameChooseLink_.addEventListener(MouseEvent.CLICK,this.onChooseName);
        addChild(this.nameChooseLink_);
    }

    private function createNameText() : void
    {
        this.nameText = new SimpleText(26,11776947,false,0,0);
        this.nameText.setBold(true);
        this.nameText.text = this.model.getName();
        this.nameText.updateMetrics();
        this.nameText.filters = [this.DROP_SHADOW];
        this.nameText.y = 24;
        this.nameText.x = (this.getReferenceRectangle().width - this.nameText.width) / 2;
        addChild(this.nameText);
    }

    private function getReferenceRectangle() : Rectangle
    {
        var rectangle:Rectangle = new Rectangle();
        if(stage)
        {
            rectangle = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
        }
        return rectangle;
    }

    private function createBoundaryLines() : void
    {
        this.lines = new Shape();
        this.lines.graphics.clear();
        this.lines.graphics.lineStyle(2,5526612);
        this.lines.graphics.moveTo(0,100);
        this.lines.graphics.lineTo(this.getReferenceRectangle().width,100);
        this.lines.graphics.moveTo(616,100);
        this.lines.graphics.lineTo(616,525);
        this.lines.graphics.lineStyle();
        addChild(this.lines);
    }

    private function onChooseName(event:MouseEvent) : void
    {
        this.chooseName.dispatch();
    }

    private function onScrollBarChange(event:Event) : void
    {
        this.characterList.setPos(-this.scrollBar.pos() * (this.characterListHeight - 400));
    }

    private function removeIfAble(object:DisplayObject) : void
    {
        if(object && contains(object))
        {
            removeChild(object);
        }
    }

    private function onPlayClick(event:Event) : void
    {
        if(this.model.getCharacterCount() == 0)
        {
            this.newCharacter.dispatch();
        }
        else
        {
            this.playGame.dispatch();
        }
    }

    public function setName(name:String) : void
    {
        this.nameText.text = name;
        this.nameText.updateMetrics();
        this.nameText.x = (this.getReferenceRectangle().width - this.nameText.width) * 0.5;
        if(this.nameChooseLink_)
        {
            removeChild(this.nameChooseLink_);
            this.nameChooseLink_ = null;
        }
    }
}
}
