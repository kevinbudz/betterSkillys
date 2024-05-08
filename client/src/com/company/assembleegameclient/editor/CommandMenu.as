package com.company.assembleegameclient.editor
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.utils.Dictionary;
   
   public class CommandMenu extends Sprite
   {
       
      
      private var keyCodeDict_:Dictionary;
      
      private var yOffset_:int = 0;
      
      private var selected_:CommandMenuItem = null;
      
      public function CommandMenu()
      {
         this.keyCodeDict_ = new Dictionary();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      public function getCommand() : int
      {
         return this.selected_.command_;
      }
      
      public function setCommand(command:int) : void
      {
         var item:CommandMenuItem = null;
         for(var c:int = 0; c < numChildren; c++)
         {
            item = getChildAt(c) as CommandMenuItem;
            if(item != null)
            {
               if(item.command_ == command)
               {
                  this.setSelected(item);
                  break;
               }
            }
         }
      }
      
      protected function setSelected(item:CommandMenuItem) : void
      {
         if(this.selected_ != null)
         {
            this.selected_.setSelected(false);
         }
         this.selected_ = item;
         this.selected_.setSelected(true);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
      }
      
      private function onKeyDown(event:KeyboardEvent) : void
      {
         if(stage.focus != null)
         {
            return;
         }
         var item:CommandMenuItem = this.keyCodeDict_[event.keyCode];
         if(item == null)
         {
            return;
         }
         item.callback_(item);
      }
      
      protected function addCommandMenuItem(label:String, keyCode:int, callback:Function, command:int) : void
      {
         var commandMenuItem:CommandMenuItem = new CommandMenuItem(label,callback,command);
         commandMenuItem.y = this.yOffset_;
         addChild(commandMenuItem);
         this.keyCodeDict_[keyCode] = commandMenuItem;
         if(this.selected_ == null)
         {
            this.setSelected(commandMenuItem);
         }
         this.yOffset_ = this.yOffset_ + 30;
      }
      
      protected function addBreak() : void
      {
         this.yOffset_ = this.yOffset_ + 30;
      }
   }
}
