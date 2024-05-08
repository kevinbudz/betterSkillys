package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.ui.SimpleText;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   
   public class TradeRequestPanel extends Panel
   {
       
      
      public var name_:String;
      
      private var title_:SimpleText;
      
      private var rejectButton_:TextButton;
      
      private var acceptButton_:TextButton;
      
      private var timer_:Timer;
      
      public function TradeRequestPanel(gs:GameSprite, name:String)
      {
         super(gs);
         this.name_ = name;
         this.title_ = new SimpleText(18,16777215,false,WIDTH,0);
         this.title_.setBold(true);
         this.title_.htmlText = "<p align=\"center\">" + name + " wants to trade with you</p>";
         this.title_.wordWrap = true;
         this.title_.multiline = true;
         this.title_.autoSize = TextFieldAutoSize.CENTER;
         this.title_.filters = [new DropShadowFilter(0,0,0)];
         this.title_.y = 0;
         addChild(this.title_);
         this.rejectButton_ = new TextButton(16,"Reject");
         this.rejectButton_.addEventListener(MouseEvent.CLICK,this.onRejectClick);
         this.rejectButton_.x = WIDTH / 4 - this.rejectButton_.width / 2;
         this.rejectButton_.y = HEIGHT - this.rejectButton_.height - 4;
         addChild(this.rejectButton_);
         this.acceptButton_ = new TextButton(16,"Accept");
         this.acceptButton_.addEventListener(MouseEvent.CLICK,this.onAcceptClick);
         this.acceptButton_.x = 3 * WIDTH / 4 - this.acceptButton_.width / 2;
         this.acceptButton_.y = HEIGHT - this.acceptButton_.height - 4;
         addChild(this.acceptButton_);
         this.timer_ = new Timer(20 * 1000,1);
         this.timer_.start();
         this.timer_.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onRejectClick(event:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onAcceptClick(event:MouseEvent) : void
      {
         gs_.gsc_.requestTrade(this.name_);
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
