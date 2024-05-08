package kabam.rotmg.characters.reskin.view
{
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.ui.SimpleText;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.classes.view.CharacterSkinListView;
   import kabam.rotmg.util.components.DialogBackground;
   import kabam.rotmg.util.graphics.ButtonLayoutHelper;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class ReskinCharacterView extends Sprite
   {
      private static const CANCEL:String = "Cancel";
      private static const SELECT:String = "Select";
      private static const TITLE_TEXT:String = "Select a Skin";
      private static const MARGIN:int = 10;
      private static const DIALOG_WIDTH:int = CharacterSkinListView.WIDTH + MARGIN * 2;
      private static const BUTTON_WIDTH:int = 120;
      private static const BUTTON_FONT:int = 16;
      private static const BUTTONS_HEIGHT:int = 40;
      private static const TITLE_OFFSET:int = 27;

      private const background:DialogBackground = makeBackground();
      private const title:SimpleText = makeTitle();
      private const list:CharacterSkinListView = makeListView();
      private const cancel:TextButton = makeCancelButton();
      private const select:TextButton = makeSelectButton();
      public const cancelled:Signal = new NativeMappedSignal(cancel,MouseEvent.CLICK);
      public const selected:Signal = new NativeMappedSignal(select,MouseEvent.CLICK);
      public var viewHeight:int;
      
      public function ReskinCharacterView()
      {
         super();
      }
      
      private function makeBackground() : DialogBackground
      {
         var background:DialogBackground = new DialogBackground();
         addChild(background);
         return background;
      }
      
      private function makeTitle() : SimpleText
      {
         var text:SimpleText = null;
         text = new SimpleText(18,11974326,false,DIALOG_WIDTH,0);
         var format:TextFormat = text.defaultTextFormat;
         format.align = TextFormatAlign.CENTER;
         format.bold = true;
         text.defaultTextFormat = format;
         text.text = TITLE_TEXT;
         addChild(text);
         return text;
      }
      
      private function makeListView() : CharacterSkinListView
      {
         var list:CharacterSkinListView = new CharacterSkinListView();
         list.x = MARGIN;
         list.y = MARGIN + TITLE_OFFSET;
         addChild(list);
         return list;
      }
      
      private function makeCancelButton() : TextButton
      {
         var button:TextButton = new TextButton(BUTTON_FONT,CANCEL,BUTTON_WIDTH);
         addChild(button);
         return button;
      }
      
      private function makeSelectButton() : TextButton
      {
         var button:TextButton = new TextButton(BUTTON_FONT,SELECT,BUTTON_WIDTH);
         addChild(button);
         return button;
      }
      
      public function setList(items:Vector.<DisplayObject>) : void
      {
         this.list.setItems(items);
         this.getDialogHeight();
         this.resizeBackground();
         this.positionButtons();
      }
      
      private function getDialogHeight() : void
      {
         this.viewHeight = Math.min(CharacterSkinListView.HEIGHT + MARGIN,this.list.getListHeight());
         this.viewHeight = this.viewHeight + (BUTTONS_HEIGHT + MARGIN * 2 + TITLE_OFFSET);
      }
      
      private function resizeBackground() : void
      {
         this.background.draw(DIALOG_WIDTH,this.viewHeight);
         this.background.graphics.lineStyle(2,5987163,1,false,LineScaleMode.NONE,CapsStyle.NONE,JointStyle.BEVEL);
         this.background.graphics.moveTo(1,TITLE_OFFSET);
         this.background.graphics.lineTo(DIALOG_WIDTH - 1,TITLE_OFFSET);
      }
      
      private function positionButtons() : void
      {
         var helper:ButtonLayoutHelper = new ButtonLayoutHelper();
         helper.layout(DIALOG_WIDTH,this.cancel,this.select);
         this.cancel.y = this.select.y = this.viewHeight - this.cancel.height - MARGIN;
      }
   }
}
