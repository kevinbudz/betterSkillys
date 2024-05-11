package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
   import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   
   public class InteractiveItemTile extends ItemTile
   {
      
      private static const DOUBLE_CLICK_PAUSE:uint = 250;
      
      private static const DRAG_DIST:int = 3;
       
      
      private var doubleClickTimer:Timer;
      
      private var dragStart:Point;
      
      private var pendingSecondClick:Boolean;
      
      private var isDragging:Boolean;
      
      public function InteractiveItemTile(id:int, parentGrid:ItemGrid, isInteractive:Boolean)
      {
         super(id,parentGrid);
         mouseChildren = false;
         this.doubleClickTimer = new Timer(DOUBLE_CLICK_PAUSE,1);
         this.doubleClickTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDoubleClickTimerComplete);
         this.setInteractive(isInteractive);
      }
      
      public function setInteractive(isInteractive:Boolean) : void
      {
         if(isInteractive)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onRightMouseUp);
            addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onRightMouseDown);
            addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
            addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            removeEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onRightMouseUp);
            removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onRightMouseDown);
            removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         }
      }
      
      public function getDropTarget() : DisplayObject
      {
         return itemSprite.dropTarget;
      }
      
      protected function beginDragCallback() : void
      {
      }
      
      protected function endDragCallback() : void
      {
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         this.setPendingDoubleClick(false);
      }

      private function onRightMouseUp(e:MouseEvent) : void {

      }

      private function onRightMouseDown(e:MouseEvent) : void {
         if (e.ctrlKey) {
            dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_RIGHT_CTRL_CLICK, this));
         }
      }

      private function onMouseUp(e:MouseEvent) : void
      {
         if(this.isDragging)
         {
            return;
         }
         if(e.shiftKey)
         {
            this.setPendingDoubleClick(false);
            dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_SHIFT_CLICK,this));
         }
         else if(e.ctrlKey)
         {
            this.setPendingDoubleClick(false);
            dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_CTRL_CLICK,this));
         }
         else if(!this.pendingSecondClick)
         {
            this.setPendingDoubleClick(true);
         }
         else
         {
            this.setPendingDoubleClick(false);
            dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_DOUBLE_CLICK,this));
         }
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         this.beginDragCheck(e);
      }
      
      private function setPendingDoubleClick(isPending:Boolean) : void
      {
         this.pendingSecondClick = isPending;
         if(this.pendingSecondClick)
         {
            this.doubleClickTimer.reset();
            this.doubleClickTimer.start();
         }
         else
         {
            this.doubleClickTimer.stop();
         }
      }
      
      private function beginDragCheck(e:MouseEvent) : void
      {
         this.dragStart = new Point(e.stageX,e.stageY);
         addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveCheckDrag);
         addEventListener(MouseEvent.MOUSE_OUT,this.cancelDragCheck);
         addEventListener(MouseEvent.MOUSE_UP,this.cancelDragCheck);
      }
      
      private function cancelDragCheck(e:MouseEvent) : void
      {
         removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMoveCheckDrag);
         removeEventListener(MouseEvent.MOUSE_OUT,this.cancelDragCheck);
         removeEventListener(MouseEvent.MOUSE_UP,this.cancelDragCheck);
      }
      
      private function onMouseMoveCheckDrag(e:MouseEvent) : void
      {
         var dx:Number = e.stageX - this.dragStart.x;
         var dy:Number = e.stageY - this.dragStart.y;
         var distance:Number = Math.sqrt(dx * dx + dy * dy);
         if(distance > DRAG_DIST)
         {
            this.cancelDragCheck(null);
            this.setPendingDoubleClick(false);
            this.beginDrag(e);
         }
      }
      
      private function onDoubleClickTimerComplete(e:TimerEvent) : void
      {
         this.setPendingDoubleClick(false);
         dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_CLICK,this));
      }
      
      private function beginDrag(e:MouseEvent) : void
      {
         this.isDragging = true;
         stage.addChild(itemSprite);
         toggleDragState(false);
         itemSprite.startDrag(true);
         itemSprite.x = e.stageX;
         itemSprite.y = e.stageY;
         itemSprite.addEventListener(MouseEvent.MOUSE_UP,this.endDrag);
         this.beginDragCallback();
      }
      
      private function endDrag(e:MouseEvent) : void
      {
         this.isDragging = false;
         toggleDragState(true);
         itemSprite.stopDrag();
         itemSprite.removeEventListener(MouseEvent.MOUSE_UP,this.endDrag);
         dispatchEvent(new ItemTileEvent(ItemTileEvent.ITEM_MOVE,this));
         this.endDragCallback();
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         this.setPendingDoubleClick(false);
         this.cancelDragCheck(null);
         if(this.isDragging)
         {
            itemSprite.stopDrag();
         }
      }
   }
}
