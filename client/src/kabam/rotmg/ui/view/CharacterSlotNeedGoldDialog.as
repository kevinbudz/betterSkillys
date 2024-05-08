package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.osflash.signals.Signal;
   
   public class CharacterSlotNeedGoldDialog extends Sprite
   {
      
      private static const TEXT:String = "Another character slot costs ${price} Gold. ";
      
      private static const TITLE:String = "Not Enough Gold";
      
      private static const CANCEL:String = "Cancel";
      
      public const cancel:Signal = new Signal();
      
      private var dialog:Dialog;
      
      private var price:int;
      
      public function CharacterSlotNeedGoldDialog()
      {
         super();
      }
      
      public function setPrice(price:int) : void
      {
         this.price = price;
         this.dialog && contains(this.dialog) && removeChild(this.dialog);
         this.makeDialog();
         this.dialog.addEventListener(Dialog.BUTTON1_EVENT,this.onCancel);
      }
      
      private function makeDialog() : void
      {
         var text:String = TEXT.replace("${price}",this.price);
         this.dialog = new Dialog(text,TITLE,CANCEL,null);
         addChild(this.dialog);
      }
      
      public function onCancel(event:Event) : void
      {
         this.cancel.dispatch();
      }
   }
}
