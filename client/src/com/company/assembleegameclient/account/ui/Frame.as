package com.company.assembleegameclient.account.ui
{
   import com.company.assembleegameclient.ui.ClickableText;
   import com.company.ui.SimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.account.web.view.LabeledField;
   
   public class Frame extends Sprite
   {
       
      
      public var titleText_:SimpleText;
      
      public var leftButton_:ClickableText;
      
      public var rightButton_:ClickableText;
      
      public var textInputFields_:Vector.<TextInputField>;
      
      public var navigationLinks_:Vector.<ClickableText>;
      
      public var w_:int = 288;
      
      public var h_:int = 100;
      
      private var titleFill_:GraphicsSolidFill= new GraphicsSolidFill(5066061,1);
      
      private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(3552822,1);
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke = new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
      
      private var path1_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private var path2_:GraphicsPath= new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[backgroundFill_,path2_,GraphicsUtil.END_FILL,titleFill_,path1_,GraphicsUtil.END_FILL,lineStyle_,path2_,GraphicsUtil.END_STROKE];
      
      public function Frame(title:String, leftButton:String, rightButton:String, w:int = 288)
      {
         this.textInputFields_ = new Vector.<TextInputField>();
         this.navigationLinks_ = new Vector.<ClickableText>();
         super();
         this.w_ = w;
         this.titleText_ = new SimpleText(12,11776947,false,0,0);
         this.titleText_.text = title;
         this.titleText_.updateMetrics();
         this.titleText_.filters = [new DropShadowFilter(0,0,0)];
         this.titleText_.x = 5;
         this.titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addChild(this.titleText_);
         this.leftButton_ = new ClickableText(18,true,leftButton);
         if(leftButton != "")
         {
            this.leftButton_.buttonMode = true;
            this.leftButton_.x = 109;
            addChild(this.leftButton_);
         }
         this.rightButton_ = new ClickableText(18,true,rightButton);
         this.rightButton_.buttonMode = true;
         this.rightButton_.x = this.w_ - this.rightButton_.width - 26;
         addChild(this.rightButton_);
         filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function addLabeledField(labeledField:LabeledField) : void
      {
         addChild(labeledField);
         labeledField.y = this.h_ - 60;
         labeledField.x = 17;
         this.h_ = this.h_ + labeledField.getHeight();
      }
      
      public function addTextInputField(textInputField:TextInputField) : void
      {
         this.textInputFields_.push(textInputField);
         addChild(textInputField);
         textInputField.y = this.h_ - 60;
         textInputField.x = 17;
         this.h_ = this.h_ + TextInputField.HEIGHT;
      }
      
      public function addNavigationText(navigationLink:ClickableText) : void
      {
         this.navigationLinks_.push(navigationLink);
         addChild(navigationLink);
         navigationLink.y = this.h_ - 66;
         navigationLink.x = 17;
         this.h_ = this.h_ + 20;
      }
      
      public function addComponent(component:DisplayObject, offsetX:int = 8) : void
      {
         addChild(component);
         component.y = this.h_ - 66;
         component.x = offsetX;
         this.h_ = this.h_ + component.height;
      }
      
      public function addPlainText(plainText:String) : void
      {
         var text:SimpleText = new SimpleText(12,16777215,false,0,0);
         text.text = plainText;
         text.updateMetrics();
         text.filters = [new DropShadowFilter(0,0,0)];
         addChild(text);
         text.y = this.h_ - 66;
         text.x = 17;
         this.h_ = this.h_ + 20;
      }
      
      public function addTitle(title:String) : void
      {
         var text:SimpleText = null;
         text = new SimpleText(20,11711154,false,0,0);
         text.text = title;
         text.setBold(true);
         text.updateMetrics();
         text.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         addChild(text);
         text.y = this.h_ - 60;
         text.x = 15;
         this.h_ = this.h_ + 40;
      }
      
      public function addCheckBox(checkBox:CheckBoxField) : void
      {
         addChild(checkBox);
         checkBox.y = this.h_ - 66;
         checkBox.x = 17;
         this.h_ = this.h_ + 44;
      }
      
      public function addRadioBox(radioBox:PaymentMethodRadioButtons) : void
      {
         addChild(radioBox);
         radioBox.y = this.h_ - 66;
         radioBox.x = 18;
         this.h_ = this.h_ + radioBox.height;
      }
      
      public function addSpace(space:int) : void
      {
         this.h_ = this.h_ + space;
      }
      
      public function disable() : void
      {
         var navigationLink:ClickableText = null;
         mouseEnabled = false;
         mouseChildren = false;
         for each(navigationLink in this.navigationLinks_)
         {
            navigationLink.setDefaultColor(11776947);
         }
         this.leftButton_.setDefaultColor(11776947);
         this.rightButton_.setDefaultColor(11776947);
      }
      
      public function enable() : void
      {
         var navigationLink:ClickableText = null;
         mouseEnabled = true;
         mouseChildren = true;
         for each(navigationLink in this.navigationLinks_)
         {
            navigationLink.setDefaultColor(16777215);
         }
         this.leftButton_.setDefaultColor(16777215);
         this.rightButton_.setDefaultColor(16777215);
      }
      
      protected function onAddedToStage(event:Event) : void
      {
         this.draw();
         this.x = 400 - (this.w_ - 6) / 2;
         this.y = 300 - h_ / 2;
         if(this.textInputFields_.length > 0)
         {
            stage.focus = this.textInputFields_[0].inputText_;
         }
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
      }
      
      private function draw() : void
      {
         graphics.clear();
         GraphicsUtil.clearPath(this.path1_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,this.w_,20 + 12,4,[1,1,0,0],this.path1_);
         GraphicsUtil.clearPath(this.path2_);
         GraphicsUtil.drawCutEdgeRect(-6,-6,this.w_,this.h_,4,[1,1,1,1],this.path2_);
         this.leftButton_.y = this.h_ - 52;
         this.rightButton_.y = this.h_ - 52;
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}
