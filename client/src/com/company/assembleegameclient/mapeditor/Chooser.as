package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.ui.Scrollbar;
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   internal class Chooser extends Sprite
   {
      
      public static const WIDTH:int = 136;
      
      public static const HEIGHT:int = 480;
      
      private static const SCROLLBAR_WIDTH:int = 20;
       
      
      public var layer_:int;
      
      private var elementSprite_:Sprite;
      
      public var selected_:Element;
      
      private var scrollBar_:Scrollbar;
      
      private var mask_:Shape;
      
      private var elements_:Vector.<Element>;
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke= new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(3552822,1);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,backgroundFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      function Chooser(layer:int)
      {
         this.elements_ = new Vector.<Element>();
         super();
         this.layer_ = layer;
         this.drawBackground();
         this.elementSprite_ = new Sprite();
         this.elementSprite_.x = 4;
         this.elementSprite_.y = 6;
         addChild(this.elementSprite_);
         this.scrollBar_ = new Scrollbar(SCROLLBAR_WIDTH,HEIGHT - 8);
         this.scrollBar_.x = WIDTH - SCROLLBAR_WIDTH - 6;
         this.scrollBar_.y = 4;
         this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
         var maskShape:Shape = new Shape();
         maskShape.graphics.beginFill(0);
         maskShape.graphics.drawRect(0,2,Chooser.WIDTH - SCROLLBAR_WIDTH - 4,Chooser.HEIGHT - 4);
         addChild(maskShape);
         this.elementSprite_.mask = maskShape;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function selectedType() : int
      {
         return this.selected_.type_;
      }
      
      public function setSelectedType(type:int) : void
      {
         var element:Element = null;
         for each(element in this.elements_)
         {
            if(element.type_ == type)
            {
               this.setSelected(element);
               return;
            }
         }
      }

      protected function removeElements():void {
         this.elements_ = new Vector.<Element>();
         removeChild(this.elementSprite_);
         this.elementSprite_ = new Sprite();
         this.elementSprite_.x = 4;
         this.elementSprite_.y = 6;
         var _local1:Shape = new Shape();
         _local1.graphics.beginFill(0);
         _local1.graphics.drawRect(0, 2, ((Chooser.WIDTH - SCROLLBAR_WIDTH) - 4), (Chooser.HEIGHT - 4));
         addChild(_local1);
         this.elementSprite_.mask = _local1;
         addChild(this.elementSprite_);
      }
      
      protected function addElement(element:Element) : void
      {
         var i:int = 0;
         i = this.elements_.length;
         element.x = i % 2 == 0?Number(0):Number(2 + Element.WIDTH);
         element.y = int(i / 2) * Element.HEIGHT + 6;
         this.elementSprite_.addChild(element);
         if(i == 0)
         {
            this.setSelected(element);
         }
         element.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.elements_.push(element);
      }
      
      protected function onMouseDown(event:MouseEvent) : void
      {
         var element:Element = event.currentTarget as Element;
         this.setSelected(element);
      }
      
      protected function setSelected(element:Element) : void
      {
         if(this.selected_ != null)
         {
            this.selected_.setSelected(false);
         }
         this.selected_ = element;
         this.selected_.setSelected(true);
      }
      
      protected function onScrollBarChange(event:Event) : void
      {
         this.elementSprite_.y = 6 - this.scrollBar_.pos() * (this.elementSprite_.height + 12 - HEIGHT);
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         this.scrollBar_.setIndicatorSize(HEIGHT,this.elementSprite_.height);
         addChild(this.scrollBar_);
      }

      protected function onRemovedFromStage(event:Event) : void
      {
      }

      private function drawBackground() : void
      {
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,[1,1,1,1],this.path_);
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}
