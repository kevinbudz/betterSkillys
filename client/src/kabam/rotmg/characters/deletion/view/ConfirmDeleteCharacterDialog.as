package kabam.rotmg.characters.deletion.view
{
   import com.company.assembleegameclient.ui.dialogs.Dialog;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.osflash.signals.Signal;
   
   public class ConfirmDeleteCharacterDialog extends Sprite
   {
       
      
      private const TEXT_TEMPLATE:String = "Are you really sure you want to delete ${NAME} the ${DISPLAYID}?";
      
      private const CANCEL_EVENT:String = Dialog.BUTTON1_EVENT;
      
      private const DELETE_EVENT:String = Dialog.BUTTON2_EVENT;
      
      public var deleteCharacter:Signal;
      
      public var cancel:Signal;
      
      public function ConfirmDeleteCharacterDialog()
      {
         super();
         this.deleteCharacter = new Signal();
         this.cancel = new Signal();
      }
      
      public function setText(name:String, displayId:String) : void
      {
         var text:String = this.TEXT_TEMPLATE.replace("${NAME}",name).replace("${DISPLAYID}",displayId);
         var dialog:Dialog = new Dialog(text,"Verify Deletion","Cancel","Delete");
         dialog.addEventListener(this.CANCEL_EVENT,this.onCancel);
         dialog.addEventListener(this.DELETE_EVENT,this.onDelete);
         addChild(dialog);
      }
      
      private function onCancel(event:Event) : void
      {
         this.cancel.dispatch();
      }
      
      private function onDelete(event:Event) : void
      {
         this.deleteCharacter.dispatch();
      }
   }
}
