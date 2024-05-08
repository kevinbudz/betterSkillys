package com.company.assembleegameclient.ui.dialogs
{
   import flash.events.Event;
   
   public class NotEnoughFameDialog extends Dialog
   {
       
      
      public function NotEnoughFameDialog()
      {
         super("You do not have enough Fame for this item.  " + "You gain Fame when your character dies after having " + "accomplished great things.","Not Enough Fame","Ok",null);
         addEventListener(BUTTON1_EVENT,this.onOk);
      }
      
      public function onOk(event:Event) : void
      {
         parent.removeChild(this);
      }
   }
}
