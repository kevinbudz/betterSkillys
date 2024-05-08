package com.company.assembleegameclient.game
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.game.model.AddTextLineVO;
   import kabam.rotmg.game.signals.AddTextLineSignal;
   
   public class IdleWatcher
   {
      
      private static const MINUTE_IN_MS:int = 60 * 1000;
      
      private static const FIRST_WARNING_MINUTES:int = 10;
      
      private static const SECOND_WARNING_MINUTES:int = 15;
      
      private static const KICK_MINUTES:int = 20;
       
      
      public var gs_:GameSprite = null;
      
      public var idleTime_:int = 0;
      
      private var addTextLine:AddTextLineSignal;
      
      public function IdleWatcher()
      {
         super();
         this.addTextLine = StaticInjectorContext.getInjector().getInstance(AddTextLineSignal);
      }
      
      public function start(gs:GameSprite) : void
      {
         this.gs_ = gs;
         this.idleTime_ = 0;
         if(this.gs_.stage){
            this.gs_.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.gs_.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }else{
            this.gs_.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.gs_.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
      }
      
      public function update(dt:int) : Boolean
      {
         var prevIdleTime:int = this.idleTime_;
         this.idleTime_ = this.idleTime_ + dt;
         if(this.idleTime_ < FIRST_WARNING_MINUTES * MINUTE_IN_MS)
         {
            return false;
         }
         if(this.idleTime_ >= FIRST_WARNING_MINUTES * MINUTE_IN_MS && prevIdleTime < FIRST_WARNING_MINUTES * MINUTE_IN_MS)
         {
            this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,"You have been idle for " + FIRST_WARNING_MINUTES + " minutes, you will be disconnected if you are idle for " + "more than " + KICK_MINUTES + " minutes."));
            return false;
         }
         if(this.idleTime_ >= SECOND_WARNING_MINUTES * MINUTE_IN_MS && prevIdleTime < SECOND_WARNING_MINUTES * MINUTE_IN_MS)
         {
            this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,"You have been idle for " + SECOND_WARNING_MINUTES + " minutes, you will be disconnected if you are idle for " + "more than " + KICK_MINUTES + " minutes."));
            return false;
         }
         if(this.idleTime_ >= KICK_MINUTES * MINUTE_IN_MS && prevIdleTime < KICK_MINUTES * MINUTE_IN_MS)
         {
            this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,"You have been idle for " + KICK_MINUTES + " minutes, disconnecting."));
            return true;
         }
         return false;
      }
      
      public function stop() : void
      {
         if(this.gs_ == null){
            return;
         }

         if(this.gs_.stage){
            this.gs_.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.gs_.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }else{
            this.gs_.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            this.gs_.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         }
         this.gs_ = null;
      }
      
      private function onMouseMove(event:MouseEvent) : void
      {
         this.idleTime_ = 0;
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         this.idleTime_ = 0;
      }
   }
}
