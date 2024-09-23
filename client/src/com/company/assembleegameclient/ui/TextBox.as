package com.company.assembleegameclient.ui
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.tutorial.Tutorial;
import com.company.assembleegameclient.tutorial.doneAction;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.engine.TextBlock;
import flash.text.engine.TextLine;
import flash.ui.Keyboard;
import flash.utils.Timer;
import flash.utils.getTimer;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.ui.model.HUDModel;

import org.hamcrest.text.re;

import org.osflash.signals.Signal;
import org.osflash.signals.natives.NativeSignal;

public class TextBox extends Sprite
{

   private static const MAX_LINES:int = 7;

   private static const LINE_TIME:int = 20000;

   private static const INDENT:int = 20;

   private static const MIN_LINE_HEIGHT:int = 16;

   private static const LINE_SPACING:int = 0;

   private static const BLOCK_SPACING:int = 4;

   private static var lines_:Vector.<TextBoxLine> = new Vector.<TextBoxLine>(0);

   public static var isInputtingText:Boolean = false;


   private var gs_:GameSprite;

   public var w_:int;

   public var h_:int;

   public var textSprite_:Sprite;

   private var textSpriteYPos_:Number;

   private var inputField_:TextField;

   private var showMax_:Boolean = false;

   private var lc_:int = 0;

   private var tellers_:Array;

   private var currentTeller_:int = 0;

   private var timer_:Timer;

   private var isInputAllowed:Boolean = true;

   private var speechBubbleIcon_:Bitmap;

   private var speechBubbleContainer:Sprite;

   private var inputNotAllowedMessage:String;

   public var inputTextClicked:NativeSignal;

   public const message:Signal = new Signal(String);

   private var hudModel:HUDModel;
   private var player:Player;

   public var speechBubbleClicked:NativeSignal;
   public var _nameColor:int;
   public var _textColor:int;

   public function TextBox(gs:GameSprite, w:int, h:int)
   {
      this.tellers_ = [];
      this.timer_ = new Timer(1000);
      super();
      this.gs_ = gs;
      this.w_ = w;
      this.h_ = h;
      this.textSprite_ = new Sprite();
      this.textSprite_.x = 2;
      this.textSprite_.filters = [new GlowFilter(0,1,3,3,2,1)];
      //this.textSprite_.mouseEnabled = true;
      //this.textSprite_.mouseChildren = false;
      addChild(this.textSprite_);
      var format:TextFormat = new TextFormat();
      format.font = "Myriad Pro";
      format.size = 14;
      format.color = 16777215;
      format.bold = true;
      this.inputField_ = new TextField();
      this.inputField_.embedFonts = true;
      this.inputField_.defaultTextFormat = format;
      this.inputField_.type = TextFieldType.INPUT;
      this.inputField_.border = true;
      this.inputField_.borderColor = 16777215;
      this.inputField_.maxChars = 128;
      this.inputField_.filters = [new GlowFilter(0,1,3,3,2,1)];
      this.inputField_.addEventListener(KeyboardEvent.KEY_UP,this.onInputFieldKeyUp);
      this.inputField_.width = this.w_ - 2;
      this.inputField_.height = 18;
      this.inputNotAllowedMessage = "Please REGISTER to see in-game chat.";
      this.speechBubbleContainer = new Sprite();
      addChild(this.speechBubbleContainer);
      var bubbleBD:BitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig",21);
      bubbleBD = TextureRedrawer.redraw(bubbleBD,20,true,0,false);
      this.speechBubbleIcon_ = new Bitmap(bubbleBD);
      this.speechBubbleIcon_.x = this.speechBubbleIcon_.x - 5;
      addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      this.inputTextClicked = new NativeSignal(this.inputField_,MouseEvent.CLICK,MouseEvent);
      this.speechBubbleClicked = new NativeSignal(this.speechBubbleContainer,MouseEvent.CLICK,MouseEvent);
   }

   public function setInputNotAllowedMessage(message:String) : void
   {
      this.inputNotAllowedMessage = message;
   }

   public function setInputTextAllowed(isInputAllowed:Boolean) : void
   {
      if(this.isInputAllowed != isInputAllowed)
      {
         this.isInputAllowed = isInputAllowed;
         if(isInputAllowed)
         {
            this.inputField_.border = true;
            this.inputField_.borderColor = 16777215;
            this.inputField_.type = TextFieldType.INPUT;
            this.inputField_.selectable = true;
            if(this.speechBubbleContainer.contains(this.speechBubbleIcon_))
            {
               this.speechBubbleContainer.removeChild(this.speechBubbleIcon_);
            }
            this.inputField_.x = this.inputField_.x - 29;
            this.inputField_.addEventListener(KeyboardEvent.KEY_UP,this.onInputFieldKeyUp);
            stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            this.inputField_.text = "";
            removeChild(this.inputField_);
         }
         else
         {
            this.inputField_.border = false;
            this.inputField_.type = TextFieldType.DYNAMIC;
            this.inputField_.removeEventListener(KeyboardEvent.KEY_UP,this.onInputFieldKeyUp);
            this.inputField_.text = this.inputNotAllowedMessage;
            this.inputField_.x = this.inputField_.x + 29;
            this.inputField_.selectable = false;
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
            addChild(this.inputField_);
            this.speechBubbleContainer.addChild(this.speechBubbleIcon_);
            this.placeTextField();
         }
      }
   }

   public function addText(name:String, text:String) : void
   {
      var textBoxLine:TextBoxLine = new TextBoxLine(getTimer(),name,-1,-1,"",false,text, _nameColor, _textColor);
      lines_.push(textBoxLine);
      this.refreshStatusBox();
   }

   public function addTextFull(name:String, objectId:int, numStars:int, recipient:String, text:String, nameColor:int, textColor:int) : void
   {
      this._nameColor = nameColor;
      this._textColor = textColor;
      var fromMe:Boolean = recipient != "" && name == this.gs_.model.getName();
      var toMe:Boolean = recipient == this.gs_.model.getName();
      var textBoxLine:TextBoxLine = new TextBoxLine(getTimer(),name,objectId,numStars,recipient,toMe,text, nameColor, textColor);
      lines_.push(textBoxLine);
      this.refreshStatusBox();
      if(toMe)
      {
         if(this.tellers_.length == 0 || this.tellers_[this.tellers_.length - 1] != name)
         {
            this.tellers_.push(name);
         }
      }
      else if(recipient != Parameters.GUILD_CHAT_NAME || recipient != Parameters.PARTY_CHAT_NAME)
      {
         if(fromMe)
         {
            if(this.tellers_.length == 0 || this.tellers_[this.tellers_.length - 1] != recipient)
            {
               this.tellers_.push(recipient);
            }
         }
      }
   }

   private function onTimer(event:TimerEvent) : void
   {
      this.refreshStatusBox();
   }

   private function clearTextSprite() : void
   {
      while(this.textSprite_.numChildren > 0)
      {
         this.textSprite_.removeChildAt(0);
      }
      this.textSprite_.graphics.clear();
      this.textSpriteYPos_ = 0;
   }

   private function addTextBlock(textBlock:TextBlock, line:TextBoxLine) : void
   {
      var blockSprite:Sprite = null;
      blockSprite = new Sprite();
      var textLine:TextLine = null;
      var yPos:Number = 0;
      while(textLine = textBlock.createTextLine(textLine,yPos == 0?Number(this.w_ - 4):Number(this.w_ - 4 - INDENT)))
      {
         textLine.x = yPos == 0?Number(0):Number(INDENT);
         textLine.y = textLine.ascent + yPos;
         yPos = yPos + Math.max(MIN_LINE_HEIGHT,textLine.height);
         blockSprite.addChild(textLine);
         blockSprite.addEventListener(MouseEvent.RIGHT_CLICK,this.onRightMouseDown(line));
      }
      if(this.textSpriteYPos_ != 0)
      {
         this.textSpriteYPos_ = this.textSpriteYPos_ + BLOCK_SPACING;
      }
      blockSprite.y = this.textSpriteYPos_;
      this.textSprite_.addChild(blockSprite);
      this.textSpriteYPos_ = this.textSpriteYPos_ + yPos;
   }

   public function onRightMouseDown(line:TextBoxLine) : Function
   {
      var textLine:TextBoxLine = line;
      return function(line:MouseEvent):void
      {
         hudModel = StaticInjectorContext.getInjector().getInstance(HUDModel);
         if(hudModel.gameSprite.map.goDict_[textLine.playerObjectId] != null && hudModel.gameSprite.map.goDict_[textLine.playerObjectId] is Player && hudModel.gameSprite.map.player_.objectId_ != textLine.playerObjectId)
         {
            player = hudModel.gameSprite.map.goDict_[textLine.playerObjectId] as Player;
            hudModel.gameSprite.addChatPlayerMenu(player,line.stageX,line.stageY);
         }
         else if(textLine.name_ != null && textLine.name_ != "" && hudModel.gameSprite.map.player_.name_ != textLine.name_)
         {
            hudModel.gameSprite.addChatPlayerMenu(null,line.stageX,line.stageY);
         }
         else if(textLine.name_ != null && textLine.name_ != "" && hudModel.gameSprite.map.player_.name_ != textLine.name_)
         {
            hudModel.gameSprite.addChatPlayerMenu(null,line.stageX,line.stageY);
         }
      };
   }

   private function refreshStatusBox() : void
   {
      var line:TextBoxLine = null;
      var textBlock:TextBlock = null;
      this.clearTextSprite();
      var now:int = getTimer();
      var startL:int = Math.max(0,lines_.length - 1 - this.lc_ - MAX_LINES);
      var endL:int = Math.min(lines_.length,startL + MAX_LINES + 1);
      for(var l:int = startL; l < endL; l++)
      {
         line = lines_[l];
         if(!(!this.showMax_ && now > line.time_ + 20000))
         {
            textBlock = line.getTextBlock();
            this.addTextBlock(textBlock, line);
         }
      }
      this.placeTextField();
   }

   private function onAddedToStage(event:Event) : void
   {
      var yMod:uint = 0;
      if(this.isInputAllowed)
      {
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         yMod = 20;
      }
      else
      {
         yMod = 25;
      }
      this.inputField_.y = this.h_ - yMod;
      this.speechBubbleIcon_.y = this.inputField_.y - 8;
      this.placeTextField();
      this.timer_.addEventListener(TimerEvent.TIMER,this.onTimer);
      this.timer_.start();
   }

   private function onRemovedFromStage(event:Event) : void
   {
      if (stage) {
         stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
      }
      this.timer_.stop();
      this.timer_.removeEventListener(TimerEvent.TIMER,this.onTimer);
   }

   private function onKeyUp(event:KeyboardEvent) : void
   {
      switch(event.keyCode)
      {
         case Parameters.data_.chatCommand:
            if(stage.focus == null)
            {
               this.selectInput();
               this.inputField_.text = "/";
               this.inputField_.setSelection(this.inputField_.length,this.inputField_.length);
            }
            break;
         case Parameters.data_.chat:
            if(stage.focus == null)
            {
               this.selectInput();
            }
            break;
         case Parameters.data_.tell:
            if(stage.focus == null)
            {
               this.selectInput();
            }
            this.insertTellPrefix(event.shiftKey);
            break;
         case Parameters.data_.guildChat:
            if(stage.focus == null)
            {
               this.selectInput();
               this.inputField_.text = "/g ";
               this.inputField_.setSelection(this.inputField_.length,this.inputField_.length);
            }
            break;
         case Parameters.data_.partyChat:
            if(stage.focus == null)
            {
               this.selectInput();
               this.inputField_.text = "/p ";
               this.inputField_.setSelection(this.inputField_.length,this.inputField_.length);
            }
            break;
         case Parameters.data_.scrollChatUp:
            if(!this.showMax_)
            {
               this.showMax_ = true;
            }
            else
            {
               this.lc_ = Math.max(0,Math.min(lines_.length - MAX_LINES,this.lc_ + MAX_LINES));
            }
            this.refreshStatusBox();
            break;
         case Parameters.data_.scrollChatDown:
            if(this.lc_ == 0)
            {
               this.showMax_ = false;
            }
            else
            {
               this.lc_ = Math.max(0,this.lc_ - MAX_LINES);
            }
            this.refreshStatusBox();
      }
   }

   public function insertTellPlayerPrefix(name:String) : void
   {
      if(stage.focus == null)
      {
         this.selectInput();
      }
      this.inputField_.text = "/tell " + name + " ";
      this.inputField_.setSelection(this.inputField_.length,this.inputField_.length);
   }

   private function insertTellPrefix(backward:Boolean) : void
   {
      this.inputField_.text = "/tell ";
      if(this.tellers_.length != 0)
      {
         if(backward)
         {
            this.currentTeller_++;
         }
         else
         {
            this.currentTeller_--;
         }
         if(this.currentTeller_ <= 0)
         {
            this.currentTeller_ = 0;
         }
         if(this.currentTeller_ >= this.tellers_.length)
         {
            this.currentTeller_ = this.tellers_.length - 1;
         }
         this.inputField_.appendText(this.tellers_[this.currentTeller_] + " ");
      }
      this.inputField_.setSelection(this.inputField_.length,this.inputField_.length);
   }

   private function onInputFieldKeyUp(event:KeyboardEvent) : void
   {
      if(!this.gs_.mui_.setHotkeysInput_ || !this.gs_.mui_.enablePlayerInput_){
         return;
      }
      switch(event.keyCode)
      {
         case Keyboard.ENTER:
            if(this.inputField_.text.length != 0)
            {
               if(this.inputField_.text.indexOf("/mscale") >= 0){
                  this.message.dispatch(this.inputField_.text);
                  doneAction(this.gs_,Tutorial.TEXT_ACTION);
                  this.inputField_.text = "";
                  this.unselectInput();
                  event.stopImmediatePropagation();
                  return;
               }
               if(this.gs_.map.player_ != null)
               {
                  this.gs_.gsc_.playerText(this.inputField_.text);
                  doneAction(this.gs_,Tutorial.TEXT_ACTION);
               }
               this.inputField_.text = "";
            }
            this.unselectInput();
            event.stopImmediatePropagation();
      }
   }

   public function selectInput(text:String = "") : void
   {
      this.inputField_.type = TextFieldType.INPUT;
      this.inputField_.border = true;
      this.inputField_.borderColor = 16777215;
      this.inputField_.text = text;
      TextBox.isInputtingText = true;
      addChild(this.inputField_);
      if(stage != null)
      {
         stage.focus = this.inputField_;
      }
      this.placeTextField();
      this.currentTeller_ = this.tellers_.length;
   }

   private function unselectInput() : void
   {
      if(stage != null)
      {
         stage.focus = null;
      }
      if(contains(this.inputField_))
      {
         TextBox.isInputtingText = false;
         removeChild(this.inputField_);
      }
      this.placeTextField();
   }

   private function placeTextField() : void
   {
      if(contains(this.inputField_))
      {
         this.textSprite_.y = this.h_ - 8 - this.inputField_.height - this.textSpriteYPos_;
      }
      else
      {
         this.textSprite_.y = this.h_ - 4 - this.textSpriteYPos_;
      }
   }
}
}
