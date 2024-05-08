package io.decagames.rotmg.ui.textField
{
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import io.decagames.rotmg.ui.labels.UILabel;
   
   public class InputTextField extends UILabel
   {
       
      
      private var _wasModified:Boolean;
      
      private var placeholder:String;
      
      public function InputTextField(param1:String = "")
      {
         super();
         this.placeholder = param1;
         this.text = param1;
         this.type = TextFieldType.INPUT;
         this.autoSize = TextFieldAutoSize.LEFT;
         this.selectable = true;
         this.wordWrap = true;
         this.multiline = false;
         this.addEventListener(FocusEvent.FOCUS_IN,this.onFocusHandler);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveEvent);
      }
      
      public function reset() : void
      {
         this.text = this.placeholder;
         this._wasModified = false;
      }
      
      private function onRemoveEvent(param1:Event) : void
      {
         this.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusHandler);
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveEvent);
      }
      
      private function onFocusHandler(param1:FocusEvent) : void
      {
         if(!this._wasModified)
         {
            this._wasModified = true;
            this.text = "";
         }
      }
      
      public function get wasModified() : Boolean
      {
         return this._wasModified;
      }
   }
}
