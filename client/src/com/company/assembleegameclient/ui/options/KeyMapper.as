package com.company.assembleegameclient.ui.options
{
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.MoreColorUtil;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   
   public class KeyMapper extends Option
   {
       
      
      private var keyCodeBox_:KeyCodeBox;
      
      private var disabled_:Boolean;
      
      public function KeyMapper(paramName:String, desc:String, tooltipText:String, disabled:Boolean = false)
      {
         super(paramName,desc,tooltipText);
         this.keyCodeBox_ = new KeyCodeBox(Parameters.data_[paramName_]);
         this.keyCodeBox_.addEventListener(Event.CHANGE,this.onChange);
         addChild(this.keyCodeBox_);
         this.setDisabled(disabled);
      }
      
      public function setDisabled(disabled:Boolean) : void
      {
         this.disabled_ = disabled;
         transform.colorTransform = !!this.disabled_?MoreColorUtil.darkCT:MoreColorUtil.identity;
         mouseEnabled = !this.disabled_;
         mouseChildren = !this.disabled_;
      }
      
      override public function refresh() : void
      {
         this.keyCodeBox_.setKeyCode(Parameters.data_[paramName_]);
      }
      
      private function onChange(event:Event) : void
      {
         Parameters.setKey(paramName_,this.keyCodeBox_.value());
         Parameters.save();
      }
   }
}
