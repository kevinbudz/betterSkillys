package io.decagames.rotmg.ui.tabs
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import io.decagames.rotmg.social.signals.TabSelectedSignal;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import org.osflash.signals.Signal;
   
   public class UITabs extends Sprite
   {
       
      
      public var buttonsRenderedSignal:Signal;
      
      public var tabSelectedSignal:TabSelectedSignal;
      
      private var tabsXSpace:int = 3;
      
      private var tabsButtonMargin:int = 14;
      
      private var content:Vector.<UITab>;
      
      private var buttons:Vector.<TabButton>;
      
      private var tabsWidth:int;
      
      private var background:TabContentBackground;
      
      private var currentContent:UITab;
      
      private var defaultSelectedIndex:int;
      
      private var borderlessMode:Boolean;
      
      public function UITabs(param1:int, param2:Boolean = false)
      {
         this.buttonsRenderedSignal = new Signal();
         this.tabSelectedSignal = new TabSelectedSignal();
         super();
         this.tabsWidth = param1;
         this.borderlessMode = param2;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedHandler);
         this.content = new Vector.<UITab>(0);
         this.buttons = new Vector.<TabButton>(0);
         if(!param2)
         {
            this.background = new TabContentBackground();
            this.background.addMargin(0,3);
            this.background.width = param1;
            this.background.height = 405;
            this.background.x = 0;
            this.background.y = 41;
            addChild(this.background);
         }
         else
         {
            this.tabsButtonMargin = 3;
         }
      }
      
      public function addTab(param1:UITab, param2:Boolean = false) : void
      {
         this.content.push(param1);
         param1.y = !!this.borderlessMode?Number(34):Number(56);
         if(param2)
         {
            this.defaultSelectedIndex = this.content.length - 1;
            this.currentContent = param1;
            addChild(param1);
         }
      }
      
      private function createTabButtons() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:TabButton = null;
         var _loc4_:UITab = null;
         var _loc5_:TabButton = null;
         _loc1_ = 1;
         var _loc6_:int = int((this.tabsWidth - (this.content.length - 1) * this.tabsXSpace - this.tabsButtonMargin * 2) / this.content.length);
         for each(_loc4_ in this.content)
         {
            if(_loc1_ == 1)
            {
               _loc2_ = TabButton.LEFT;
            }
            else if(_loc1_ == this.content.length)
            {
               _loc2_ = TabButton.RIGHT;
            }
            else
            {
               _loc2_ = TabButton.CENTER;
            }
            _loc5_ = this.createTabButton(_loc4_.tabName,_loc2_);
            _loc5_.width = _loc6_;
            _loc5_.selected = this.defaultSelectedIndex == _loc1_ - 1;
            if(_loc5_.selected)
            {
               _loc3_ = _loc5_;
            }
            _loc5_.y = 3;
            _loc5_.x = this.tabsButtonMargin + _loc6_ * (_loc1_ - 1) + this.tabsXSpace * (_loc1_ - 1);
            addChild(_loc5_);
            _loc5_.clickSignal.add(this.onButtonSelected);
            this.buttons.push(_loc5_);
            _loc1_++;
         }
         if(this.background)
         {
            this.background.addDecor(_loc3_.x - 4,_loc3_.x + _loc3_.width - 12,this.defaultSelectedIndex,this.buttons.length);
         }
         this.onButtonSelected(_loc3_);
         this.buttonsRenderedSignal.dispatch();
      }
      
      private function onButtonSelected(param1:TabButton) : void
      {
         var _loc2_:TabButton = null;
         var _loc3_:int = 0;
         _loc3_ = this.buttons.indexOf(param1);
         param1.y = 0;
         this.tabSelectedSignal.dispatch(param1.label.text);
         for each(_loc2_ in this.buttons)
         {
            if(_loc2_ != param1)
            {
               _loc2_.selected = false;
               _loc2_.y = 3;
               this.updateTabButtonGraphicState(_loc2_,_loc3_);
            }
            else
            {
               _loc2_.selected = true;
            }
         }
         if(this.currentContent)
         {
            this.currentContent.alpha = 0;
            this.currentContent.mouseChildren = false;
            this.currentContent.mouseEnabled = false;
         }
         this.currentContent = this.content[_loc3_];
         if(this.background)
         {
            this.background.addDecor(param1.x - 5,param1.x + param1.width - 12,_loc3_,this.buttons.length);
         }
         addChild(this.currentContent);
         this.currentContent.alpha = 1;
         this.currentContent.mouseChildren = true;
         this.currentContent.mouseEnabled = true;
      }
      
      private function updateTabButtonGraphicState(param1:TabButton, param2:int) : void
      {
         var _loc3_:int = this.buttons.indexOf(param1);
         if(Math.abs(_loc3_ - param2) <= 1)
         {
            if(this.borderlessMode)
            {
               param1.changeBitmap("tab_button_borderless_idle",new Point(0,!!this.borderlessMode?Number(0):Number(TabButton.SELECTED_MARGIN)));
               param1.bitmap.alpha = 0;
            }
            else if(_loc3_ > param2)
            {
               param1.changeBitmap("tab_button_right_idle",new Point(0,!!this.borderlessMode?Number(0):Number(TabButton.SELECTED_MARGIN)));
            }
            else
            {
               param1.changeBitmap("tab_button_left_idle",new Point(0,!!this.borderlessMode?Number(0):Number(TabButton.SELECTED_MARGIN)));
            }
         }
      }
      
      public function getTabButtonByLabel(param1:String) : TabButton
      {
         var _loc2_:TabButton = null;
         for each(_loc2_ in this.buttons)
         {
            if(_loc2_.label.text == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function createTabButton(param1:String, param2:String) : TabButton
      {
         var _loc3_:TabButton = new TabButton(!!this.borderlessMode?TabButton.BORDERLESS:param2);
         _loc3_.setLabel(param1,DefaultLabelFormat.defaultInactiveTab);
         return _loc3_;
      }
      
      private function onAddedHandler(param1:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHandler);
         this.createTabButtons();
      }
      
      public function dispose() : void
      {
         var _loc1_:TabButton = null;
         var _loc2_:UITab = null;
         if(this.background)
         {
            this.background.dispose();
         }
         for each(_loc1_ in this.buttons)
         {
            _loc1_.dispose();
         }
         for each(_loc2_ in this.content)
         {
            _loc2_.dispose();
         }
         this.currentContent.dispose();
         this.content = null;
         this.buttons = null;
      }
   }
}
