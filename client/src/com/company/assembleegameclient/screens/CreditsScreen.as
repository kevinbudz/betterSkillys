package com.company.assembleegameclient.screens
{
   import com.company.rotmg.graphics.KabamLogo;
   import com.company.rotmg.graphics.ScreenGraphic;
   import com.company.rotmg.graphics.StackedLogoR;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import kabam.rotmg.ui.view.components.ScreenBase;
   import org.osflash.signals.Signal;
   
   public class CreditsScreen extends Sprite
   {
      
      private static const WILD_SHADOW_URL:String = "http://www.wildshadow.com/";
      
      private static const KABAM_URL:String = "http://www.kabam.com/";
       
      
      public var close:Signal;
      
      private var developedByText_:SimpleText;
      
      private var stackedLogoR_:StackedLogoR;
      
      private var kabamLogo_:KabamLogo;
      
      private var doneButton_:TitleMenuOption;
      
      public function CreditsScreen()
      {
         super();
         this.close = new Signal();
         addChild(new ScreenBase());
         addChild(new ScreenGraphic());
         this.developedByText_ = new SimpleText(16,11776947,false,0,0);
         this.developedByText_.setBold(true);
         this.developedByText_.text = "Developed by:";
         this.developedByText_.updateMetrics();
         this.developedByText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.developedByText_);
         this.stackedLogoR_ = new StackedLogoR();
         this.stackedLogoR_.scaleX = this.stackedLogoR_.scaleY = 1.2;
         this.stackedLogoR_.addEventListener(MouseEvent.CLICK,this.onWSLogoClick);
         this.stackedLogoR_.buttonMode = true;
         this.stackedLogoR_.useHandCursor = true;
         addChild(this.stackedLogoR_);
         this.kabamLogo_ = new KabamLogo();
         this.kabamLogo_.scaleX = this.kabamLogo_.scaleY = 1;
         this.kabamLogo_.addEventListener(MouseEvent.CLICK,this.onKabamLogoClick);
         this.kabamLogo_.buttonMode = true;
         this.kabamLogo_.useHandCursor = true;
         addChild(this.kabamLogo_);
         this.doneButton_ = new TitleMenuOption("close",36,false);
         this.doneButton_.addEventListener(MouseEvent.CLICK,this.onDoneClick);
         addChild(this.doneButton_);
      }
      
      public function initialize() : void
      {
         this.developedByText_.x = stage.stageWidth / 2 - this.developedByText_.width / 2;
         this.developedByText_.y = 10;
         this.stackedLogoR_.x = stage.stageWidth / 2 - this.stackedLogoR_.width / 2;
         this.stackedLogoR_.y = 50;
         this.kabamLogo_.x = stage.stageWidth / 2 - this.kabamLogo_.width / 2;
         this.kabamLogo_.y = 325;
         this.doneButton_.x = stage.stageWidth / 2 - this.doneButton_.width / 2;
         this.doneButton_.y = 524;
      }
      
      protected function onWSLogoClick(event:Event) : void
      {
         navigateToURL(new URLRequest(WILD_SHADOW_URL),"_blank");
      }
      
      protected function onKabamLogoClick(event:Event) : void
      {
         navigateToURL(new URLRequest(KABAM_URL),"_blank");
      }
      
      private function onDoneClick(event:Event) : void
      {
         this.close.dispatch();
      }
   }
}
