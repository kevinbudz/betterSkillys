package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.TextBox;
   import com.company.assembleegameclient.ui.panels.ButtonPanel;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import org.osflash.signals.Signal;
   
   public class MoneyChangerPanel extends ButtonPanel
   {
       
      
      public var triggered:Signal;
      
      public function MoneyChangerPanel(gs:GameSprite)
      {
         super(gs,"Buy Realm Gold","Buy");
         this.triggered = new Signal();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      override protected function onAddedToStage(event:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      override protected function onRemovedFromStage(event:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      override protected function onButtonClick(event:MouseEvent) : void
      {
         this.triggered.dispatch();
      }
      
      override protected function onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Parameters.data_.interact && !TextBox.isInputtingText)
         {
            this.triggered.dispatch();
         }
      }
   }
}
