package io.decagames.rotmg.ui.buttons
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.osflash.signals.Signal;
   
   public class BaseButton extends Sprite
   {
       
      
      protected var _disabled:Boolean;
      
      public var clickSignal:Signal;
      
      public var rollOverSignal:Signal;
      
      public var rollOutSignal:Signal;
      
      private var _instanceName:String;
      
      public function BaseButton()
      {
         this.clickSignal = new Signal();
         this.rollOverSignal = new Signal();
         this.rollOutSignal = new Signal();
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      protected function onAddedToStage(param1:Event) : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.addEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onRollOutHandler);
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onRollOverHandler);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
      }
      
      public function dispose() : void
      {
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.removeEventListener(MouseEvent.CLICK,this.onClickHandler);
         this.removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOutHandler);
         this.removeEventListener(MouseEvent.MOUSE_OVER,this.onRollOverHandler);
         this.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDownHandler);
         this.clickSignal.removeAll();
         this.rollOverSignal.removeAll();
         this.rollOutSignal.removeAll();
      }
      
      protected function onClickHandler(param1:MouseEvent) : void
      {
         if(!this._disabled)
         {
            this.clickSignal.dispatch(this);
         }
      }
      
      protected function onMouseDownHandler(param1:MouseEvent) : void
      {
      }
      
      protected function onRollOutHandler(param1:MouseEvent) : void
      {
         this.rollOutSignal.dispatch(this);
      }
      
      protected function onRollOverHandler(param1:MouseEvent) : void
      {
         this.rollOverSignal.dispatch(this);
      }
      
      public function set disabled(param1:Boolean) : void
      {
         this._disabled = param1;
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
      
      public function get instanceName() : String
      {
         return this._instanceName;
      }
      
      public function set instanceName(param1:String) : void
      {
         this._instanceName = param1;
      }
   }
}
