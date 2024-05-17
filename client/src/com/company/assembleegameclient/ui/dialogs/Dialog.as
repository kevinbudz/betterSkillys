package com.company.assembleegameclient.ui.dialogs
{
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.ui.SimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
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
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;

import kabam.rotmg.stage3D.Renderer;

public class Dialog extends Sprite
   {
      
      public static const BUTTON1_EVENT:String = "DIALOG_BUTTON1";
      
      public static const BUTTON2_EVENT:String = "DIALOG_BUTTON2";
      
      private static const WIDTH:int = 300;
       
      
      public var box_:Sprite;
      
      public var rect_:Shape;
      
      public var textText_:SimpleText;
      
      public var titleText_:SimpleText = null;
      
      public var button1_:TextButton = null;
      
      public var button2_:TextButton = null;
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
      
      private var backgroundFill_:GraphicsSolidFill= new GraphicsSolidFill(3552822,1);
      
      protected var path_:GraphicsPath= new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      protected const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,backgroundFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      public var offsetX:Number = 0;
      
      public var offsetY:Number = 0;

      private var background:Sprite;

      
      public function Dialog(text:String, title:String, button1:String, button2:String, background:Boolean = false)
      {
         this.box_ = new Sprite();
         this.background = new Sprite();
         super();

         if (background)
         {
            this.background = this.drawBackground();
            addChild(this.background);
         }
         this.initText(text);
         this.initTitleText(title);
         if(button1 != null)
         {
            this.button1_ = new TextButton(16,button1,120);
            this.button1_.addEventListener(MouseEvent.CLICK,this.onButton1Click);
         }
         if(button2 != null)
         {
            this.button2_ = new TextButton(16,button2,120);
            this.button2_.addEventListener(MouseEvent.CLICK,this.onButton2Click);
         }
         this.draw();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.positionAssets();
         if (WebMain.STAGE)
            WebMain.STAGE.addEventListener(Event.RESIZE, positionAssets);
      }

      public function positionAssets(e:Event = null)
      {
         var width:int = WebMain.STAGE.stageWidth;
         var height:int = WebMain.STAGE.stageHeight;
         if (!Renderer.inGame)
         {
            this.background.width = width;
            this.background.height = height;
            this.box_.x = width / 2 - this.box_.width / 2;
            this.box_.y = height / 2 - this.box_.height / 2;
         } else
         {
            var sWidth:* = 800 / width;
            var sHeight:* = 600 / height;
            var result:* = sHeight / sWidth;
            this.background.width = 800 * result;
            this.background.height = 600 * result;
            this.box_.scaleX = 800 / width;
            this.box_.scaleY = 600 / height;
            this.box_.x = 400 - this.box_.width / 2;
            this.box_.y = 300 - this.box_.height / 2;
         }
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
      
      protected function initText(text:String) : void
      {
         this.textText_ = new SimpleText(14,11776947,false,WIDTH - 40,0);
         this.textText_.x = 20;
         this.textText_.multiline = true;
         this.textText_.wordWrap = true;
         this.textText_.htmlText = "<p align=\"center\">" + text + "</p>";
         this.textText_.autoSize = TextFieldAutoSize.CENTER;
         this.textText_.mouseEnabled = true;
         this.textText_.updateMetrics();
         this.textText_.filters = [new DropShadowFilter(0,0,0,1,6,6,1)];
      }
      
      private function initTitleText(title:String) : void
      {
         if(title != null)
         {
            this.titleText_ = new SimpleText(18,5746018,false,WIDTH,0);
            this.titleText_.setBold(true);
            this.titleText_.htmlText = "<p align=\"center\">" + title + "</p>";
            this.titleText_.updateMetrics();
            this.titleText_.filters = [new DropShadowFilter(0,0,0,1,8,8,1)];
         }
      }
      
      protected function draw() : void
      {
         var by:int = 0;
         if(this.titleText_ != null)
         {
            this.titleText_.y = 2;
            this.box_.addChild(this.titleText_);
            this.textText_.y = this.box_.height + 8;
         }
         else
         {
            this.textText_.y = 4;
         }
         this.box_.addChild(this.textText_);
         if(this.button1_ != null)
         {
            by = this.box_.height + 16;
            this.box_.addChild(this.button1_);
            this.button1_.y = by;
            if(this.button2_ == null)
            {
               this.button1_.x = WIDTH / 2 - this.button1_.width / 2;
            }
            else
            {
               this.button1_.x = WIDTH / 4 - this.button1_.width / 2;
               this.box_.addChild(this.button2_);
               this.button2_.x = 3 * WIDTH / 4 - this.button2_.width / 2;
               this.button2_.y = by;
            }
         }
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,this.box_.height + 10,4,[1,1,1,1],this.path_);
         this.rect_ = new Shape();
         var g:Graphics = this.rect_.graphics;
         g.drawGraphicsData(this.graphicsData_);
         this.box_.addChildAt(this.rect_,0);
         this.box_.filters = [new DropShadowFilter(0,0,0,1,16,16,1)];
         addChild(this.box_);
      }

      private function onAddedToStage(event:Event) : void
      {
      }
      
      private function onButton1Click(event:MouseEvent) : void
      {
         dispatchEvent(new Event(BUTTON1_EVENT));
      }
      
      private function onButton2Click(event:Event) : void
      {
         dispatchEvent(new Event(BUTTON2_EVENT));
      }

      public function addFullDim() : void {
         graphics.beginFill(0,0.5);
         graphics.drawRect(0,0,800,600);
         graphics.endFill();
      }
      
      public function setBaseAlpha(value:Number) : void
      {
         this.rect_.alpha = value > 1?Number(1):value < 0?Number(0):Number(value);
      }
   }
}
