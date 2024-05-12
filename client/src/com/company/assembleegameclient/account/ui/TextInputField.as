package com.company.assembleegameclient.account.ui
{
   import com.company.ui.SimpleText;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   
   public class TextInputField extends Sprite
   {
      
      public static const HEIGHT:int = 88;
       
      
      public var nameText_:SimpleText;
      
      public var inputText_:SimpleText;
      
      public var errorText_:SimpleText;

      public var detailText_:SimpleText;
      
      public function TextInputField(name:String, isPassword:Boolean, error:String, detailText:String = "", width:int = 238)
      {
         super();
         this.nameText_ = new SimpleText(18,11776947,false,0,0);
         this.nameText_.setBold(true);
         this.nameText_.text = name;
         this.nameText_.updateMetrics();
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.nameText_);
         if (detailText != "")
         {
            this.detailText_ = new SimpleText(18,11776947,false,0,0);
            this.detailText_.setBold(true);
            this.detailText_.text = detailText;
            this.detailText_.updateMetrics();
            this.detailText_.filters = [new DropShadowFilter(0,0,0)];
            this.detailText_.x = -(this.detailText_.width + 5);
            this.detailText_.y = 32;
            addChild(this.detailText_);
         }
         this.inputText_ = new SimpleText(20,11776947,true,238,30);
         this.inputText_.y = 30;
         this.inputText_.x = 6;
         this.inputText_.border = false;
         this.inputText_.displayAsPassword = isPassword;
         this.inputText_.updateMetrics();
         addChild(this.inputText_);
         graphics.lineStyle(2,4539717,1,false,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         graphics.beginFill(3355443,1);
         graphics.drawRect(0,this.inputText_.y,width,30);
         graphics.endFill();
         graphics.lineStyle();
         this.inputText_.addEventListener(Event.CHANGE,this.onInputChange);
         this.errorText_ = new SimpleText(12,16549442,false,0,0);
         this.errorText_.y = this.inputText_.y + 32;
         this.errorText_.text = error;
         this.errorText_.updateMetrics();
         this.errorText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.errorText_);
      }
      
      public function text() : String
      {
         return this.inputText_.text;
      }
      
      public function setError(error:String) : void
      {
         this.errorText_.text = error;
         this.errorText_.updateMetrics();
      }
      
      public function onInputChange(event:Event) : void
      {
         this.setError("");
      }
   }
}
