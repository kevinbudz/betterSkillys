package kabam.rotmg.characters.reskin.view
{
   import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextBox;
import com.company.assembleegameclient.ui.TextButton;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.ui.SimpleText;

import flash.events.Event;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class ReskinPanel extends Panel
   {
      
      private static const TITLE:String = "Change Skin";
      
      private static const CHOOSE:String = "Choose";
       
      
      private const title:SimpleText = makeTitle();
      
      private const button:TextButton = makeButton();
      
      public const reskin:Signal = new NativeMappedSignal(button,MouseEvent.CLICK);

      public const reskintwo:Signal = new Signal();
      
      public function ReskinPanel(gs:GameSprite)
      {
         super(gs);
         addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
      }

      protected function onAddedToStage(_arg1:Event):void {
         stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
      }

      protected function onRemovedFromStage(_arg1:Event):void {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
      }

      protected function onKeyDown(event:KeyboardEvent):void
      {
         if(event.keyCode == Parameters.data_.interact && !TextBox.isInputtingText){
            this.reskintwo.dispatch();
         }
      }

      private function makeTitle() : SimpleText
      {
         var title:SimpleText = null;
         title = new SimpleText(18,16777215,false,WIDTH,0);
         title.setBold(true);
         title.wordWrap = true;
         title.multiline = true;
         title.autoSize = TextFieldAutoSize.CENTER;
         title.filters = [new DropShadowFilter(0,0,0)];
         title.htmlText = "<p align=\"center\">" + TITLE + "</p>";
         addChild(title);
         return title;
      }
      
      private function makeButton() : TextButton
      {
         var button:TextButton = new TextButton(16,CHOOSE);
         button.x = WIDTH / 2 - button.width / 2;
         button.y = HEIGHT - button.height - 4;
         addChild(button);
         return button;
      }
   }
}
