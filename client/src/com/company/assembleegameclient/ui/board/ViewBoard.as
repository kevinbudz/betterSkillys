package com.company.assembleegameclient.ui.board
{
   import com.company.assembleegameclient.ui.Scrollbar;
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.ui.SimpleText;
   import com.company.util.GraphicsUtil;
   import com.company.util.HTMLUtil;
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
   
   internal class ViewBoard extends Sprite
   {
      
      public static const TEXT_WIDTH:int = 400;
      
      public static const TEXT_HEIGHT:int = 400;
      
      private static const URL_REGEX:RegExp = /((https?|ftp):((\/\/)|(\\\\))+[\w\d:#@%\/;$()~_?\+-=\\\.&]*)/g;
       
      
      private var text_:String;
      
      public var w_:int;
      
      public var h_:int;
      
      private var boardText_:SimpleText;
      
      private var mainSprite_:Sprite;
      
      private var fullTextSprite_:Sprite;
      
      private var scrollBar_:Scrollbar;
      
      private var editButton_:TextButton;
      
      private var closeButton_:TextButton;
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(3355443,1);
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
      
      private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,backgroundFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      function ViewBoard(text:String, canEdit:Boolean)
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
         var viewText:String = HTMLUtil.escape(text);
         viewText = viewText.replace(URL_REGEX,"<font color=\"#7777EE\"><a href=\"$1\" target=\"_blank\">" + "$1</a></font>");
         this.boardText_ = new SimpleText(16,11776947,false,TEXT_WIDTH,0);
         this.boardText_.border = false;
         this.boardText_.mouseEnabled = true;
         this.boardText_.multiline = true;
         this.boardText_.wordWrap = true;
         this.boardText_.htmlText = viewText;
         this.boardText_.useTextDimensions();
         this.mainSprite_.addChild(this.boardText_);
         var showScrollbar:Boolean = this.boardText_.height > 400;
         if(showScrollbar)
         {
            this.scrollBar_ = new Scrollbar(16,TEXT_HEIGHT - 4);
            this.scrollBar_.x = TEXT_WIDTH + 6;
            this.scrollBar_.y = 0;
            this.scrollBar_.setIndicatorSize(400,this.boardText_.height);
            this.scrollBar_.addEventListener(Event.CHANGE,this.onScrollBarChange);
            addChild(this.scrollBar_);
         }
         this.w_ = TEXT_WIDTH + (!!showScrollbar?26:0);
         this.editButton_ = new TextButton(14,"Edit",120);
         this.editButton_.x = 4;
         this.editButton_.y = TEXT_HEIGHT + 4;
         this.editButton_.addEventListener(MouseEvent.CLICK,this.onEdit);
         addChild(this.editButton_);
         this.editButton_.visible = canEdit;
         this.closeButton_ = new TextButton(14,"Close",120);
         this.closeButton_.x = this.w_ - this.closeButton_.width - 4;
         this.closeButton_.y = TEXT_HEIGHT + 4;
         this.closeButton_.addEventListener(MouseEvent.CLICK,this.onClose);
         addChild(this.closeButton_);
         this.h_ = TEXT_HEIGHT + this.closeButton_.height + 8;
         graphics.clear();
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,this.w_ + 12,this.h_ + 12,4,[1,1,1,1],this.path_);
         graphics.drawGraphicsData(this.graphicsData_);
      }
      
      private function onScrollBarChange(event:Event) : void
      {
         this.boardText_.y = -this.scrollBar_.pos() * (this.boardText_.height - 400);
      }
      
      private function onEdit(event:Event) : void
      {
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function onClose(event:Event) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
