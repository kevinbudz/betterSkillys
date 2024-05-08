package com.company.assembleegameclient.ui.board
{
   import com.company.assembleegameclient.ui.Scrollbar;
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
   
   internal class EditBoard extends Sprite
   {
      
      public static const TEXT_WIDTH:int = 400;
      
      public static const TEXT_HEIGHT:int = 400;
       
      
      private var text_:String;
      
      public var w_:int;
      
      public var h_:int;
      
      private var boardText_:SimpleText;
      
      private var mainSprite_:Sprite;
      
      private var fullTextSprite_:Sprite;
      
      private var scrollBar_:Scrollbar;
      
      private var cancelButton_:TextButton;
      
      private var saveButton_:TextButton;
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(3355443,1);
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,backgroundFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      function EditBoard(text:String)
      {
         super();
         this.text_ = text;
         this.mainSprite_ = new Sprite();
         var shape:Shape = new Shape();
         var g:Graphics = shape.graphics;
         g.beginFill(0);
         g.drawRect(0,0,TEXT_WIDTH,TEXT_HEIGHT);
         g.endFill();
         this.mainSprite_.addChild(shape);
         this.mainSprite_.mask = shape;
         addChild(this.mainSprite_);
         this.boardText_ = new SimpleText(16,11776947,true,TEXT_WIDTH,TEXT_HEIGHT);
         this.boardText_.border = false;
         this.boardText_.mouseEnabled = true;
         this.boardText_.multiline = true;
         this.boardText_.wordWrap = true;
         this.boardText_.text = text;
         this.boardText_.useTextDimensions();
         this.boardText_.addEventListener(Event.CHANGE,this.onTextChange);
         this.boardText_.addEventListener(Event.SCROLL,this.onTextChange);
         this.mainSprite_.addChild(this.boardText_);
         this.scrollBar_ = new Scrollbar(16,TEXT_HEIGHT - 4);
         this.scrollBar_.x = TEXT_WIDTH + 6;
         this.scrollBar_.y = 0;
         this.scrollBar_.setIndicatorSize(400,this.boardText_.height);
         this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
         addChild(this.scrollBar_);
         this.w_ = TEXT_WIDTH + 26;
         this.cancelButton_ = new TextButton(14,"Cancel",120);
         this.cancelButton_.x = 4;
         this.cancelButton_.y = TEXT_HEIGHT + 4;
         this.cancelButton_.addEventListener(MouseEvent.CLICK,this.onCancel);
         addChild(this.cancelButton_);
         this.saveButton_ = new TextButton(14,"Save",120);
         this.saveButton_.x = this.w_ - this.saveButton_.width - 4;
         this.saveButton_.y = TEXT_HEIGHT + 4;
         this.saveButton_.addEventListener(MouseEvent.CLICK,this.onSave);
         addChild(this.saveButton_);
         this.h_ = TEXT_HEIGHT + this.saveButton_.height + 8;
         graphics.clear();
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,this.w_ + 12,this.h_ + 12,4,[1,1,1,1],this.path_);
         graphics.drawGraphicsData(this.graphicsData_);
         this.scrollBar_.setIndicatorSize(TEXT_HEIGHT,this.boardText_.textHeight,false);
      }
      
      public function getText() : String
      {
         return this.boardText_.text;
      }
      
      private function onScrollBarChange(event:Event) : void
      {
         this.boardText_.scrollV = 1 + this.scrollBar_.pos() * this.boardText_.maxScrollV;
      }
      
      private function onCancel(event:Event) : void
      {
         dispatchEvent(new Event(Event.CANCEL));
      }
      
      private function onSave(event:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function onTextChange(event:Event) : void
      {
         if(this.scrollBar_ == null)
         {
            return;
         }
         this.scrollBar_.setIndicatorSize(TEXT_HEIGHT,this.boardText_.textHeight,false);
         if(this.boardText_.maxScrollV == 1)
         {
            this.scrollBar_.setPos(0);
         }
         else
         {
            this.scrollBar_.setPos((this.boardText_.scrollV - 1) / (this.boardText_.maxScrollV - 1));
         }
      }
   }
}
