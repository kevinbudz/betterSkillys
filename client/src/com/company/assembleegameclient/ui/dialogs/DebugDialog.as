package com.company.assembleegameclient.ui.dialogs
{
   import flash.events.Event;
   
   public class DebugDialog extends Dialog
   {
       
      
      public function DebugDialog(text:String)
      {
         super(text,"Debug","OK",null);
         addEventListener(Dialog.BUTTON1_EVENT,this.onDialogComplete);
      }
      
      private function onDialogComplete(event:Event) : void
      {
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
