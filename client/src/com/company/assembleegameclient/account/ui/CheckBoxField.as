package com.company.assembleegameclient.account.ui
{
   import com.company.ui.SimpleText;
   import flash.display.CapsStyle;
   import flash.display.Graphics;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   
   public class CheckBoxField extends Sprite
   {
      
      private static const BOX_SIZE:int = 20;
       
      
      public var checkBox_:Sprite;
      
      public var text_:SimpleText;
      
      public var errorText_:SimpleText;
      
      private var checked_:Boolean;
      
      private var hasError:Boolean;
      
      public function CheckBoxField(text:String, checked:Boolean, error:String, fontSize:uint = 16)
      {
         super();
         this.checked_ = checked;
         this.checkBox_ = new Sprite();
         this.checkBox_.x = 2;
         this.checkBox_.y = 2;
         this.redrawCheckBox();
         this.checkBox_.addEventListener(MouseEvent.CLICK,this.onClick);
         addChild(this.checkBox_);
         this.text_ = new SimpleText(fontSize,11776947,false,0,0);
         this.text_.x = this.checkBox_.x + BOX_SIZE + 8;
         this.text_.setBold(true);
         this.text_.multiline = true;
         this.text_.htmlText = text;
         this.text_.mouseEnabled = true;
         this.text_.updateMetrics();
         this.text_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.text_);
         this.errorText_ = new SimpleText(12,16549442,false,0,0);
         this.errorText_.x = this.text_.x;
         this.errorText_.y = this.text_.y + 20;
         this.errorText_.text = error;
         this.errorText_.updateMetrics();
         this.errorText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.errorText_);
      }
      
      public function isChecked() : Boolean
      {
         return this.checked_;
      }
      
      public function setError(error:String) : void
      {
         this.errorText_.text = error;
         this.errorText_.updateMetrics();
      }
      
      private function onClick(event:MouseEvent) : void
      {
         this.setError("");
         this.checked_ = !this.checked_;
         this.redrawCheckBox();
      }
      
      public function setErrorHighlight(value:Boolean) : void
      {
         this.hasError = value;
         this.redrawCheckBox();
      }
      
      private function redrawCheckBox() : void
      {
         var color:Number = NaN;
         var g:Graphics = this.checkBox_.graphics;
         g.clear();
         g.beginFill(3355443,1);
         g.drawRect(0,0,BOX_SIZE,BOX_SIZE);
         g.endFill();
         if(this.checked_)
         {
            g.lineStyle(4,11776947,1,false,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
            g.moveTo(2,2);
            g.lineTo(BOX_SIZE - 2,BOX_SIZE - 2);
            g.moveTo(2,BOX_SIZE - 2);
            g.lineTo(BOX_SIZE - 2,2);
            g.lineStyle();
            this.hasError = false;
         }
         if(this.hasError)
         {
            color = 16549442;
         }
         else
         {
            color = 4539717;
         }
         g.lineStyle(2,color,1,false,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         g.drawRect(0,0,BOX_SIZE,BOX_SIZE);
         g.lineStyle();
      }
   }
}
