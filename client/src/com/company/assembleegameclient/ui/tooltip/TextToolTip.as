package com.company.assembleegameclient.ui.tooltip
{
   import com.company.ui.SimpleText;
   import flash.filters.DropShadowFilter;
   
   public class TextToolTip extends ToolTip
   {
       
      
      public var titleText_:SimpleText;
      
      public var tipText_:SimpleText;
      
      public function TextToolTip(background:uint, outline:uint, title:String, text:String, maxWidth:int)
      {
         super(background,1,outline,1);
         if(title != null)
         {
            this.titleText_ = new SimpleText(20,16777215,false,maxWidth,0);
            this.titleText_.setBold(true);
            this.titleText_.wordWrap = true;
            this.titleText_.text = title;
            this.titleText_.updateMetrics();
            this.titleText_.filters = [new DropShadowFilter(0,0,0)];
            addChild(this.titleText_);
         }
         if(text != null)
         {
            this.tipText_ = new SimpleText(14,11776947,false,maxWidth,0);
            this.tipText_.wordWrap = true;
            this.tipText_.y = this.titleText_ != null?Number(this.titleText_.height + 8):Number(0);
            this.tipText_.text = text;
            this.tipText_.useTextDimensions();
            this.tipText_.filters = [new DropShadowFilter(0,0,0)];
            addChild(this.tipText_);
         }
      }
      
      public function setTitle(title:String) : void
      {
         this.titleText_.text = title;
         this.titleText_.updateMetrics();
         draw();
      }
      
      public function setText(text:String) : void
      {
         this.tipText_.text = text;
         this.tipText_.useTextDimensions();
         draw();
      }
   }
}
