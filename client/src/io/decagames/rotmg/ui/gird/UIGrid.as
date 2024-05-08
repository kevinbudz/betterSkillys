package io.decagames.rotmg.ui.gird
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import io.decagames.rotmg.ui.scroll.UIScrollbar;
   import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class UIGrid extends Sprite
   {
       
      
      private var elements:Vector.<UIGridElement>;
      
      private var decors:Vector.<SliceScalingBitmap>;
      
      private var gridMargin:int;
      
      private var gridWidth:int;
      
      private var numberOfColumns:int;
      
      private var scrollHeight:int;
      
      public var scroll:UIScrollbar;
      
      private var gridContent:Sprite;
      
      private var gridMask:Sprite;
      
      private var _centerLastRow:Boolean;
      
      private var lastRenderedItemsNumber:int = 0;
      
      private var elementWidth:int;
      
      private var _decorBitmap:String = "";
      
      public function UIGrid(param1:int, param2:int, param3:int, param4:int = -1, param5:int = 0, param6:DisplayObject = null)
      {
         super();
         this.elements = new Vector.<UIGridElement>();
         this.decors = new Vector.<SliceScalingBitmap>();
         this.gridMargin = param3;
         this.gridWidth = param1;
         this.gridContent = new Sprite();
         this.addChild(this.gridContent);
         this.scrollHeight = param4;
         if(param4 > 0)
         {
            this.scroll = new UIScrollbar(param4);
            this.scroll.x = param1 + param5;
            addChild(this.scroll);
            this.scroll.content = this.gridContent;
            this.scroll.scrollObject = param6;
            this.gridMask = new Sprite();
         }
         this.numberOfColumns = param2;
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedHandler);
      }
      
      override public function set width(param1:Number) : void
      {
         this.gridWidth = param1;
         this.render();
      }
      
      public function get numberOfElements() : int
      {
         return this.elements.length;
      }
      
      private function onAddedHandler(param1:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHandler);
         this.addEventListener(Event.ENTER_FRAME,this.onUpdate);
         this.render();
      }
      
      public function addGridElement(param1:UIGridElement) : void
      {
         if(this.elements)
         {
            this.elements.push(param1);
            this.gridContent.addChild(param1);
            if(this.stage)
            {
               this.render();
            }
         }
      }
      
      private function addDecorToRow(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:SliceScalingBitmap = null;
         param3--;
         if(param3 == 0)
         {
            param3 = 1;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param3)
         {
            _loc5_ = TextureParser.instance.getSliceScalingBitmap("UI",this._decorBitmap);
            _loc5_.x = Math.round(_loc4_ * (this.gridMargin / 2) + (_loc4_ + 1) * (this.elementWidth + this.gridMargin / 2) - _loc5_.width / 2);
            _loc5_.y = Math.round(param1 + param2 - _loc5_.height / 2 + this.gridMargin / 2);
            this.gridContent.addChild(_loc5_);
            this.decors.push(_loc5_);
            _loc4_++;
         }
      }
      
      public function clearGrid() : void
      {
         var _loc1_:UIGridElement = null;
         var _loc2_:SliceScalingBitmap = null;
         for each(_loc1_ in this.elements)
         {
            this.gridContent.removeChild(_loc1_);
            _loc1_.dispose();
         }
         for each(_loc2_ in this.decors)
         {
            this.gridContent.removeChild(_loc2_);
            _loc2_.dispose();
         }
         if(this.elements)
         {
            this.elements.length = 0;
         }
         if(this.decors)
         {
            this.decors.length = 0;
         }
         this.lastRenderedItemsNumber = 0;
      }
      
      public function render() : void
      {
         var _loc8_:UIGridElement = null;
         var _loc9_:int = 0;
         if(this.lastRenderedItemsNumber == this.elements.length)
         {
            return;
         }
         this.elementWidth = (this.gridWidth - (this.numberOfColumns - 1) * this.gridMargin) / this.numberOfColumns;
         var _loc1_:int = 1;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = Math.ceil(this.elements.length / this.numberOfColumns);
         var _loc6_:int = 1;
         var _loc7_:int = 0;
         for each(_loc8_ in this.elements)
         {
            _loc8_.resize(this.elementWidth);
            if(_loc8_.height > _loc4_)
            {
               _loc4_ = _loc8_.height;
            }
            _loc8_.x = _loc2_;
            _loc8_.y = _loc3_;
            _loc1_++;
            if(_loc1_ > this.numberOfColumns)
            {
               if(this._decorBitmap != "")
               {
                  _loc7_ = _loc6_;
                  this.addDecorToRow(_loc3_,_loc4_,_loc1_ - 1);
               }
               _loc6_++;
               _loc2_ = 0;
               if(_loc6_ == _loc5_ && this._centerLastRow)
               {
                  _loc9_ = _loc6_ * this.numberOfColumns - this.elements.length;
                  _loc2_ = Math.round((_loc9_ * this.elementWidth + (_loc9_ - 1) * this.gridMargin) / 2);
               }
               _loc3_ = _loc3_ + (_loc4_ + this.gridMargin);
               _loc4_ = 0;
               _loc1_ = 1;
            }
            else
            {
               _loc2_ = _loc2_ + (this.elementWidth + this.gridMargin);
            }
         }
         if(this._decorBitmap != "" && _loc7_ != _loc6_)
         {
            this.addDecorToRow(_loc3_,_loc4_,_loc1_ - 1);
         }
         if(this.scrollHeight != -1)
         {
            this.gridMask.graphics.clear();
            this.gridMask.graphics.beginFill(16711680);
            this.gridMask.graphics.drawRect(0,0,this.gridWidth,this.scrollHeight);
            this.gridContent.mask = this.gridMask;
            addChild(this.gridMask);
         }
         this.lastRenderedItemsNumber = this.elements.length;
      }
      
      public function dispose() : void
      {
         var _loc1_:UIGridElement = null;
         var _loc2_:SliceScalingBitmap = null;
         this.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
         for each(_loc1_ in this.elements)
         {
            _loc1_.dispose();
         }
         for each(_loc2_ in this.decors)
         {
            _loc2_.dispose();
         }
         this.elements = null;
      }
      
      private function onUpdate(param1:Event) : void
      {
         var _loc2_:UIGridElement = null;
         for each(_loc2_ in this.elements)
         {
            _loc2_.update();
         }
      }
      
      public function get centerLastRow() : Boolean
      {
         return this._centerLastRow;
      }
      
      public function set centerLastRow(param1:Boolean) : void
      {
         this._centerLastRow = param1;
      }
      
      public function get decorBitmap() : String
      {
         return this._decorBitmap;
      }
      
      public function set decorBitmap(param1:String) : void
      {
         this._decorBitmap = param1;
      }
   }
}
