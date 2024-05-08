package com.company.assembleegameclient.screens
{
   import com.company.ui.SimpleText;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import org.osflash.signals.Signal;
   
   public class GraveyardLine extends Sprite
   {
      
      public static const WIDTH:int = 430;
      
      public static const HEIGHT:int = 52;
      
      public static const COLOR:uint = 11776947;
      
      public static const OVER_COLOR:uint = 16762880;
       
      
      public var viewCharacterFame:Signal;
      
      public var icon_:Bitmap;
      
      public var titleText_:SimpleText;
      
      public var taglineText_:SimpleText;
      
      public var dtText_:SimpleText;
      
      public var link:String;
      
      public var accountId:int;
      
      public function GraveyardLine(icon:BitmapData, title:String, tagLine:String, link:String, time:int, accountId:int)
      {
         this.viewCharacterFame = new Signal(int);
         super();
         this.link = link;
         this.accountId = accountId;
         buttonMode = true;
         useHandCursor = true;
         tabEnabled = false;
         this.icon_ = new Bitmap();
         this.icon_.bitmapData = icon;
         this.icon_.x = 12;
         this.icon_.y = HEIGHT / 2 - icon.height / 2 - 3;
         addChild(this.icon_);
         this.titleText_ = new SimpleText(18,COLOR,false,0,0);
         this.titleText_.text = title;
         this.titleText_.updateMetrics();
         this.titleText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.titleText_.x = 73;
         addChild(this.titleText_);
         this.taglineText_ = new SimpleText(14,COLOR,false,0,0);
         this.taglineText_.text = tagLine;
         this.taglineText_.updateMetrics();
         this.taglineText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.taglineText_.x = 73;
         this.taglineText_.y = 24;
         addChild(this.taglineText_);
         this.dtText_ = new SimpleText(16,COLOR,false,0,0);
         this.dtText_.text = this.getTimeDiff(time);
         this.dtText_.updateMetrics();
         this.dtText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.dtText_.x = WIDTH - this.dtText_.width;
         addChild(this.dtText_);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      protected function onMouseOver(event:MouseEvent) : void
      {
         this.titleText_.setColor(OVER_COLOR);
         this.taglineText_.setColor(OVER_COLOR);
         this.dtText_.setColor(OVER_COLOR);
      }
      
      protected function onRollOut(event:MouseEvent) : void
      {
         this.titleText_.setColor(COLOR);
         this.taglineText_.setColor(COLOR);
         this.dtText_.setColor(COLOR);
      }
      
      protected function onMouseDown(event:MouseEvent) : void
      {
         var parts:Array = this.link.split(":",2);
         switch(parts[0])
         {
            case "fame":
               this.viewCharacterFame.dispatch(int(parts[1]));
               break;
            case "http":
            case "https":
            default:
               navigateToURL(new URLRequest(this.link),"_blank");
         }
      }
      
      private function getTimeDiff(time:int) : String
      {
         var now:Number = new Date().getTime() / 1000;
         var dt:int = now - time;
         if(dt <= 0)
         {
            return "now";
         }
         if(dt < 60)
         {
            return dt + " secs";
         }
         if(dt < 60 * 60)
         {
            return int(dt / 60) + " mins";
         }
         if(dt < 60 * 60 * 24)
         {
            return int(dt / (60 * 60)) + " hours";
         }
         return int(dt / (60 * 60 * 24)) + " days";
      }
   }
}
