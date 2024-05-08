package com.company.assembleegameclient.ui.options
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.Event;
   
   public class ChoiceOption extends Option
   {
       
      
      private var callback_:Function;
      
      private var choiceBox_:ChoiceBox;
      
      public function ChoiceOption(paramName:String, labels:Vector.<String>, values:Array, desc:String, tooltipText:String, callback:Function)
      {
         super(paramName,desc,tooltipText);
         this.callback_ = callback;
         this.choiceBox_ = new ChoiceBox(labels,values,Parameters.data_[paramName_]);
         this.choiceBox_.addEventListener(Event.CHANGE,this.onChange);
         addChild(this.choiceBox_);
      }
      
      override public function refresh() : void
      {
         this.choiceBox_.setValue(Parameters.data_[paramName_]);
      }
      
      private function onChange(event:Event) : void
      {
         Parameters.data_[paramName_] = this.choiceBox_.value();
         Parameters.save();
         if(this.callback_ != null)
         {
            this.callback_();
         }
      }
   }
}
