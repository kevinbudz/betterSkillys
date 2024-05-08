package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.objects.Portal;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.tutorial.Tutorial;
   import com.company.assembleegameclient.tutorial.doneAction;
   import com.company.assembleegameclient.ui.TextBox;
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.ui.SimpleText;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import org.osflash.signals.Signal;
   
   public class PortalPanel extends Panel
   {
      public var owner_:Portal;
      private var nameText_:SimpleText;
      private var enterButton_:TextButton;
      private var fullText_:SimpleText;
      public const exitGameSignal:Signal = new Signal();
      
      public function PortalPanel(gs:GameSprite, owner:Portal)
      {
         super(gs);
         this.owner_ = owner;
         this.nameText_ = new SimpleText(18,16777215,false,WIDTH,0);
         this.nameText_.setBold(true);
         this.nameText_.htmlText = "<p align=\"center\">Portal</p>";
         this.nameText_.wordWrap = true;
         this.nameText_.multiline = true;
         this.nameText_.autoSize = TextFieldAutoSize.CENTER;
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.nameText_);
         this.enterButton_ = new TextButton(16,"Enter");
         addChild(this.enterButton_);
         this.fullText_ = new SimpleText(18,16711680,false,WIDTH,0);
         this.fullText_.setBold(true);
         if(this.owner_.lockedPortal_)
         {
            this.fullText_.htmlText = "<p align=\"center\">Locked</p>";
         }
         else
         {
            this.fullText_.htmlText = "<p align=\"center\">Full</p>";
         }
         this.fullText_.autoSize = TextFieldAutoSize.CENTER;
         this.fullText_.filters = [new DropShadowFilter(0,0,0)];
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         this.nameText_.y = 6;
         this.enterButton_.x = WIDTH / 2 - this.enterButton_.width / 2;
         this.enterButton_.y = HEIGHT - this.enterButton_.height - 4;
         this.fullText_.y = HEIGHT - this.fullText_.height - 12;
         this.enterButton_.addEventListener(MouseEvent.CLICK,this.onEnterSpriteClick);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onEnterSpriteClick(event:MouseEvent) : void
      {
         this.enterPortal();
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Parameters.data_.interact && !TextBox.isInputtingText)
         {
            this.enterPortal();
         }
      }
      
      private function enterPortal() : void
      {
         gs_.gsc_.usePortal(this.owner_.objectId_);
      }
      
      override public function draw() : void
      {
         var name:String = this.owner_.getName();
         var lockedStr:String = "Locked ";
         if(this.owner_.lockedPortal_ && name.indexOf(lockedStr) == 0)
         {
            name = name.substr(lockedStr.length);
         }
         this.nameText_.htmlText = "<p align=\"center\">" + name + "</p>";
         this.nameText_.useTextDimensions();
         if(this.nameText_.height > 30)
         {
            this.nameText_.y = 0;
         }
         else
         {
            this.nameText_.y = 6;
         }
         if(!this.owner_.lockedPortal_ && this.owner_.active_ && contains(this.fullText_))
         {
            removeChild(this.fullText_);
            addChild(this.enterButton_);
         }
         else if((this.owner_.lockedPortal_ || !this.owner_.active_) && contains(this.enterButton_))
         {
            removeChild(this.enterButton_);
            addChild(this.fullText_);
         }
      }
   }
}
