package com.company.assembleegameclient.map.partyoverlay
{
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.menu.Menu;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.util.RectangleUtil;
import com.company.util.Trig;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;

public class GameObjectArrow extends Sprite
{

   public static const SMALL_SIZE:int = 8;

   public static const BIG_SIZE:int = 11;

   public static const DIST:int = 3;

   private static var menu_:Menu = null;


   public var menuLayer:DisplayObjectContainer;

   public var lineColor_:uint;

   public var fillColor_:uint;

   public var go_:GameObject = null;

   public var extraGOs_:Vector.<GameObject>;

   public var mouseOver_:Boolean = false;

   private var big_:Boolean;

   private var arrow_:Shape;

   protected var tooltip_:ToolTip = null;

   private var tempPoint:Point;

   public var map_:Map;

   public function GameObjectArrow(param1:uint, param2:uint, param3:Boolean)
   {
      this.extraGOs_ = new Vector.<GameObject>();
      this.arrow_ = new Shape();
      this.tempPoint = new Point();
      super();
      this.lineColor_ = param1;
      this.fillColor_ = param2;
      this.big_ = param3;
      addChild(this.arrow_);
      this.drawArrow();
      addEventListener("mouseOver",this.onMouseOver);
      addEventListener("mouseOut",this.onMouseOut);
      addEventListener("mouseDown",this.onMouseDown);
      filters = [new DropShadowFilter(0,0,0,1,8,8)];
      visible = false;
   }

   public static function removeMenu() : void
   {
      if(menu_ != null)
      {
         if(menu_.parent != null)
         {
            menu_.parent.removeChild(menu_);
         }
         menu_ = null;
      }
   }

   protected function onMouseOver(param1:MouseEvent) : void
   {
      this.mouseOver_ = true;
      this.drawArrow();
   }

   protected function onMouseOut(param1:MouseEvent) : void
   {
      this.mouseOver_ = false;
      this.drawArrow();
   }

   protected function onMouseDown(param1:MouseEvent) : void
   {
      if(Parameters.isGpuRender())
      {
         //this.map_.mapHitArea.dispatchEvent(param1);
      }
   }

   protected function setToolTip(param1:ToolTip) : void
   {
      this.removeTooltip();
      this.tooltip_ = param1;
      if(this.tooltip_ != null)
      {
         addChild(this.tooltip_);
         this.positionTooltip(this.tooltip_);
      }
   }

   protected function removeTooltip() : void
   {
      if(this.tooltip_ != null)
      {
         if(this.tooltip_.parent != null)
         {
            this.tooltip_.parent.removeChild(this.tooltip_);
         }
         this.tooltip_ = null;
      }
   }

   protected function setMenu(param1:Menu) : void
   {
      this.removeTooltip();
      menu_ = param1;
      this.menuLayer.addChild(menu_);
   }

   public function setGameObject(param1:GameObject) : void
   {
      if(this.go_ != param1)
      {
         this.go_ = param1;
      }
      this.extraGOs_.length = 0;
      if(this.go_ == null)
      {
         visible = false;
      }
   }

   public function addGameObject(param1:GameObject) : void
   {
      this.extraGOs_.push(param1);
   }

   public function correctQuestNote(param1:Rectangle) : Rectangle
   {
      var _loc2_:Rectangle = param1.clone();
      if(((stage.scaleMode == StageScaleMode.NO_SCALE) && (Parameters.data_.uiscale)))
      {
         if(Parameters.data_.uiscale)
         {
            var _loc3_:* = (stage.stageWidth < stage.stageHeight?stage.stageWidth:int(stage.stageHeight)) / Parameters.data_.mscale / 600;
            this.scaleX = _loc3_;
            this.scaleY = _loc3_;
         }
         else
         {
            this.scaleX = 1;
            this.scaleY = 1;
         }
         _loc2_.right = _loc2_.right - (800 - this.go_.map_.gs_.hudView.x) * stage.stageWidth / Parameters.data_.mscale / 800;
      }
      else
      {
         _loc3_ = 1;
         this.scaleY = _loc3_;
         this.scaleX = _loc3_;
      }
      return _loc2_;
   }

   public function draw(param1:int, param2:Camera) : void
   {
      var _loc3_:* = null;
      var _loc5_:Number = NaN;
      var _loc6_:Number = NaN;
      if(this.go_ == null)
      {
         visible = false;
         return;
      }
      this.go_.computeSortVal(param2);
      _loc3_ = this.correctQuestNote(param2.clipRect_);
      _loc5_ = this.go_.posS_[0];
      _loc6_ = this.go_.posS_[1];
      if(!RectangleUtil.lineSegmentIntersectXY(_loc3_,0,0,_loc5_,_loc6_,this.tempPoint))
      {
         this.go_ = null;
         visible = false;
         return;
      }
      x = this.tempPoint.x;
      y = this.tempPoint.y;
      var _loc4_:* = Number(Trig.boundTo180(270 - 57.2957795130823 * Math.atan2(_loc5_,_loc6_)));
      if(this.tempPoint.x < _loc3_.left + 5)
      {
         if(_loc4_ > 45)
         {
            _loc4_ = 45;
         }
         if(_loc4_ < -45)
         {
            _loc4_ = -45;
         }
      }
      else if(this.tempPoint.x > _loc3_.right - 5)
      {
         if(_loc4_ > 0)
         {
            if(_loc4_ < 135)
            {
               _loc4_ = Number(135);
            }
         }
         else if(_loc4_ > -135)
         {
            _loc4_ = Number(-135);
         }
      }
      if(this.tempPoint.y < _loc3_.top + 5)
      {
         if(_loc4_ < 45)
         {
            _loc4_ = 45;
         }
         if(_loc4_ > 135)
         {
            _loc4_ = Number(135);
         }
      }
      else if(this.tempPoint.y > _loc3_.bottom - 5)
      {
         if(_loc4_ > -45)
         {
            _loc4_ = -45;
         }
         if(_loc4_ < -135)
         {
            _loc4_ = Number(-135);
         }
      }
      this.arrow_.rotation = _loc4_;
      if(this.tooltip_)
      {
         this.positionTooltip(this.tooltip_);
      }
      visible = true;
   }

   private function positionTooltip(param1:ToolTip) : void
   {
      var _loc7_:Number = NaN;
      var _loc8_:Number = NaN;
      var _loc9_:Number = NaN;
      var _loc2_:Number = this.arrow_.rotation;
      var _loc3_:int = 26;
      var _loc6_:Number = _loc3_ * Math.cos(_loc2_ * 0.0174532925199433);
      _loc7_ = _loc3_ * Math.sin(_loc2_ * 0.0174532925199433);
      var _loc4_:Number = param1.contentWidth_;
      var _loc5_:Number = param1.contentHeight_;
      if(_loc2_ >= 45 && _loc2_ <= 135)
      {
         _loc8_ = _loc6_ + _loc4_ / Math.tan(_loc2_ * 0.0174532925199433);
         param1.x = (_loc6_ + _loc8_) / 2 - _loc4_ / 2;
         param1.y = _loc7_;
      }
      else if(_loc2_ <= -45 && _loc2_ >= -135)
      {
         _loc8_ = _loc6_ - _loc4_ / Math.tan(_loc2_ * 0.0174532925199433);
         param1.x = (_loc6_ + _loc8_) / 2 - _loc4_ / 2;
         param1.y = _loc7_ - _loc5_;
      }
      else if(_loc2_ < 45 && _loc2_ > -45)
      {
         param1.x = _loc6_;
         _loc9_ = _loc7_ + _loc5_ * Math.tan(_loc2_ * 0.0174532925199433);
         param1.y = (_loc7_ + _loc9_) / 2 - _loc5_ / 2;
      }
      else
      {
         param1.x = _loc6_ - _loc4_;
         _loc9_ = _loc7_ - _loc5_ * Math.tan(_loc2_ * 0.0174532925199433);
         param1.y = (_loc7_ + _loc9_) / 2 - _loc5_ / 2;
      }
   }

   private function drawArrow() : void
   {
      var _loc2_:Graphics = this.arrow_.graphics;
      _loc2_.clear();
      var _loc1_:int = this.big_ || this.mouseOver_?11:8;
      _loc2_.lineStyle(1,this.lineColor_);
      _loc2_.beginFill(this.fillColor_);
      _loc2_.moveTo(3,0);
      _loc2_.lineTo(_loc1_ + 3,_loc1_);
      _loc2_.lineTo(_loc1_ + 3,-_loc1_);
      _loc2_.lineTo(3,0);
      _loc2_.endFill();
      _loc2_.lineStyle();
   }
}
}
