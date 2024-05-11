package kabam.rotmg.ui.view.components
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import com.company.util.GraphicsUtil;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeSignal;
   
   public class PotionSlotView extends Sprite
   {
      public static var BUTTON_WIDTH:int = 84;
      private static var BUTTON_HEIGHT:int = 24;
      private static var SMALL_SIZE:int = 4;
      private static var CENTER_ICON_X:int = 13;
      private static var LEFT_ICON_X:int = -6;
      private static const DOUBLE_CLICK_PAUSE:uint = 250;
      private static const DRAG_DIST:int = 3;
      
      public var position:int;
      public var objectType:int;
      public var click:NativeSignal;
      public var buyUse:Signal;
      public var drop:Signal;
      private var lightGrayFill:GraphicsSolidFill;
      private var midGrayFill:GraphicsSolidFill;
      private var darkGrayFill:GraphicsSolidFill;
      private var outerPath:GraphicsPath;
      private var innerPath:GraphicsPath;
      private var useGraphicsData:Vector.<IGraphicsData>;
      private var buyOuterGraphicsData:Vector.<IGraphicsData>;
      private var buyInnerGraphicsData:Vector.<IGraphicsData>;
      private var text:SimpleText;
      private var textTwo:SimpleText;
      private var potionIconDraggableSprite:Sprite;
      private var potionIcon:Bitmap;
      private var bg:Sprite;
      private var grayscaleMatrix:ColorMatrixFilter;
      private var available:Boolean = false;
      private var doubleClickTimer:Timer;
      private var dragStart:Point;
      private var pendingSecondClick:Boolean;
      private var isDragging:Boolean;
      private var showPots:Boolean;
      
      public function PotionSlotView(cuts:Array, position:int)
      {
         this.lightGrayFill = new GraphicsSolidFill(5526612,1);
         this.midGrayFill = new GraphicsSolidFill(4078909,1);
         this.darkGrayFill = new GraphicsSolidFill(2368034,1);
         this.outerPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
         this.innerPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
         this.useGraphicsData = new <IGraphicsData>[this.lightGrayFill,this.outerPath,GraphicsUtil.END_FILL];
         this.buyOuterGraphicsData = new <IGraphicsData>[this.midGrayFill,this.outerPath,GraphicsUtil.END_FILL];
         this.buyInnerGraphicsData = new <IGraphicsData>[this.darkGrayFill,this.innerPath,GraphicsUtil.END_FILL];
         super();
         mouseChildren = false;
         this.position = position;
         this.grayscaleMatrix = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);
         this.text = new SimpleText(16,0xfffff,false,BUTTON_HEIGHT,BUTTON_WIDTH);
         this.text.setBold(true);
         this.text.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
         this.textTwo = new SimpleText(12,0xb3b3b3,false,BUTTON_HEIGHT,BUTTON_WIDTH);
         this.textTwo.y = 7;
         this.textTwo.x = (BUTTON_WIDTH / 2) + 25;
         this.textTwo.setText("/6");
         this.textTwo.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
         this.bg = new Sprite();
         GraphicsUtil.clearPath(this.outerPath);
         GraphicsUtil.drawCutEdgeRect(0,0,BUTTON_WIDTH,BUTTON_HEIGHT,4,cuts,this.outerPath);
         GraphicsUtil.drawCutEdgeRect(2,2,BUTTON_WIDTH - SMALL_SIZE,BUTTON_HEIGHT - SMALL_SIZE,4,cuts,this.innerPath);
         this.bg.graphics.drawGraphicsData(this.buyOuterGraphicsData);
         this.bg.graphics.drawGraphicsData(this.buyInnerGraphicsData);
         addChild(this.bg);
         addChild(this.text);
         addChild(this.textTwo);
         this.potionIconDraggableSprite = new Sprite();
         this.doubleClickTimer = new Timer(DOUBLE_CLICK_PAUSE,1);
         this.doubleClickTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onDoubleClickTimerComplete);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         this.click = new NativeSignal(this,MouseEvent.CLICK,MouseEvent);
         this.buyUse = new Signal();
         this.drop = new Signal(DisplayObject);
      }

      public function setData(potions:int, available:Boolean, objectType:int = -1):void
      {
         var iconX:int;
         var iconBD:BitmapData;
         var potionIconBig:Bitmap;
         if (objectType != -1)
         {
            this.objectType = objectType;
            if (this.potionIcon != null)
            {
               removeChild(this.potionIcon);
            }
            iconBD = ObjectLibrary.getRedrawnTextureFromType(objectType, 40, false);
            this.potionIcon = new Bitmap(iconBD);
            this.potionIcon.y = -7;
            addChild(this.potionIcon);
            iconBD = ObjectLibrary.getRedrawnTextureFromType(objectType, 80, true);
            potionIconBig = new Bitmap(iconBD);
            potionIconBig.x = potionIconBig.x - 20;
            potionIconBig.y = potionIconBig.y - 30;
            this.potionIconDraggableSprite.addChild(potionIconBig);
         }
         this.setTextString(String(potions));
         iconX = CENTER_ICON_X;
         this.bg.graphics.clear();
         this.bg.graphics.drawGraphicsData(this.useGraphicsData);
         this.text.x = (BUTTON_WIDTH / 2) + 16;
         if (this.potionIcon) {
            this.potionIcon.x = iconX + 15;
         }
         if (potions <= 1)
         {
            this.text.setColor(16589603);
         }
         else
         {
            if (potions <= 4)
            {
               this.text.setColor(16611363);
            }
            else
            {
               if (potions >= 4)
               {
                  this.text.setColor(3007543);
               }
            }
         }
      }

      public function setTextString(_arg1:String):void
      {
         this.text.setText(_arg1);
         this.text.updateMetrics();
      }
      
      private function onMouseOut(e:MouseEvent) : void
      {
         this.setPendingDoubleClick(false);
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
            this.buyUse.dispatch();
         }
         else if(!this.pendingSecondClick)
         {
            this.setPendingDoubleClick(true);
         }
         else
         {
            this.setPendingDoubleClick(false);
            this.buyUse.dispatch();
         }
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         if(showPots)
         {
            this.beginDragCheck(e);
         }
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
            this.beginDrag();
         }
      }
      
      private function onDoubleClickTimerComplete(e:TimerEvent) : void
      {
         this.setPendingDoubleClick(false);
      }
      
      private function beginDrag() : void
      {
         this.isDragging = true;
         this.potionIconDraggableSprite.startDrag(true);
         stage.addChild(this.potionIconDraggableSprite);
         this.potionIconDraggableSprite.addEventListener(MouseEvent.MOUSE_UP,this.endDrag);
      }
      
      private function endDrag(e:MouseEvent) : void
      {
         this.isDragging = false;
         this.potionIconDraggableSprite.stopDrag();
         this.potionIconDraggableSprite.x = this.dragStart.x;
         this.potionIconDraggableSprite.y = this.dragStart.y;
         stage.removeChild(this.potionIconDraggableSprite);
         this.potionIconDraggableSprite.removeEventListener(MouseEvent.MOUSE_UP,this.endDrag);
         this.drop.dispatch(this.potionIconDraggableSprite.dropTarget);
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         this.setPendingDoubleClick(false);
         this.cancelDragCheck(null);
         if(this.isDragging)
         {
            this.potionIconDraggableSprite.stopDrag();
         }
      }
   }
}
