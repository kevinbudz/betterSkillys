package kabam.rotmg.minimap.view
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.objects.Character;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.GuildHallPortal;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.objects.Portal;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.menu.PlayerGroupMenu;
   import com.company.assembleegameclient.ui.tooltip.PlayerGroupToolTip;
   import com.company.util.AssetLibrary;
   import com.company.util.PointUtil;
   import com.company.util.RectangleUtil;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class MiniMap extends Sprite
   {
      
      public static const MOUSE_DIST_SQ:int = 5 * 5;
      
      private static var objectTypeColorDict_:Dictionary = new Dictionary();
       
      
      public var map:Map;
      
      public var _width:int;
      
      public var _height:int;
      
      public var zoomIndex:int = 0;
      
      public var windowRect_:Rectangle;
      
      private var focus:GameObject;
      
      public var maxWH_:Point;
      
      public var miniMapData_:BitmapData;
      
      public var zoomLevels:Vector.<Number>;
      
      public var blueArrow_:BitmapData;
      
      public var groundLayer_:Shape;
      
      public var characterLayer_:Shape;
      
      private var zoomButtons:MiniMapZoomButtons;
      
      private var isMouseOver:Boolean = false;
      
      private var tooltip:PlayerGroupToolTip = null;
      
      private var menu:PlayerGroupMenu = null;
      
      private var mapMatrix_:Matrix;
      
      private var arrowMatrix_:Matrix;
      
      private var players_:Vector.<Player>;
      
      private var tempPoint:Point;
      
      public var active:Boolean = true;
      
      public function MiniMap(width:int, height:int)
      {
         this.zoomLevels = new Vector.<Number>();
         this.mapMatrix_ = new Matrix();
         this.arrowMatrix_ = new Matrix();
         this.players_ = new Vector.<Player>();
         this.tempPoint = new Point();
         super();
         this._width = width;
         this._height = height;
         this.makeVisualLayers();
         this.addMouseListeners();
      }
      
      public static function gameObjectToColor(go:GameObject) : uint
      {
         var objectType:* = go.objectType_;
         if(!objectTypeColorDict_.hasOwnProperty(objectType))
         {
            objectTypeColorDict_[objectType] = go.getColor();
         }
         return objectTypeColorDict_[objectType];
      }
      
      public function setMap(map:Map) : void
      {
         this.map = map;
         this.makeViewModel();
      }
      
      public function setFocus(focus:GameObject) : void
      {
         this.focus = focus;
      }
      
      private function makeViewModel() : void
      {
         this.windowRect_ = new Rectangle(-this._width / 2,-this._height / 2,this._width,this._height);
         this.maxWH_ = new Point(this.map.width_,this.map.height_);
         this.miniMapData_ = new BitmapData(this.maxWH_.x,this.maxWH_.y,false,0);
         var minZoom:Number = Math.max(this._width / this.maxWH_.x,this._height / this.maxWH_.y);
         for(var z:Number = 4; z > minZoom; z = z / 2)
         {
            this.zoomLevels.push(z);
         }
         this.zoomLevels.push(minZoom);
         this.zoomButtons && this.zoomButtons.setZoomLevels(this.zoomLevels.length);
      }
      
      private function makeVisualLayers() : void
      {
         this.blueArrow_ = AssetLibrary.getImageFromSet("lofiInterface",54).clone();
         this.blueArrow_.colorTransform(this.blueArrow_.rect,new ColorTransform(0,0,1));
         graphics.clear();
         graphics.beginFill(1776411);
         graphics.drawRect(0,0,this._width,this._height);
         graphics.endFill();
         this.groundLayer_ = new Shape();
         this.groundLayer_.x = this._width / 2;
         this.groundLayer_.y = this._height / 2;
         addChild(this.groundLayer_);
         this.characterLayer_ = new Shape();
         this.characterLayer_.x = this._width / 2;
         this.characterLayer_.y = this._height / 2;
         addChild(this.characterLayer_);
         this.zoomButtons = new MiniMapZoomButtons();
         this.zoomButtons.x = this._width - 20;
         this.zoomButtons.zoom.add(this.onZoomChanged);
         this.zoomButtons.setZoomLevels(this.zoomLevels.length);
         addChild(this.zoomButtons);
      }
      
      private function addMouseListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.CLICK,this.onMapClick);
      }
      
      public function dispose() : void
      {
         this.miniMapData_.dispose();
         this.miniMapData_ = null;
         this.removeDecorations();
      }
      
      private function onZoomChanged(zoomLevel:int) : void
      {
         this.zoomIndex = zoomLevel;
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.isMouseOver = true;
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.isMouseOver = false;
      }
      
      private function onMapClick(event:MouseEvent) : void
      {
         if(this.tooltip == null || this.tooltip.parent == null || this.tooltip.players_ == null || this.tooltip.players_.length == 0)
         {
            return;
         }
         this.removeMenu();
         this.addMenu();
         this.removeTooltip();
      }
      
      private function addMenu() : void
      {
         this.menu = new PlayerGroupMenu(this.map,this.tooltip.players_);
         this.menu.x = this.tooltip.x + 12;
         this.menu.y = this.tooltip.y;
         stage.addChild(this.menu);
      }
      
      public function setGroundTile(x:int, y:int, tileType:uint) : void
      {
         var color:uint = GroundLibrary.getColor(tileType);
         this.miniMapData_.setPixel(x,y,color);
      }
      
      public function setGameObjectTile(x:int, y:int, go:GameObject) : void
      {
         var color:uint = gameObjectToColor(go);
         this.miniMapData_.setPixel(x,y,color);
      }
      
      private function removeDecorations() : void
      {
         this.removeTooltip();
         this.removeMenu();
      }
      
      private function removeTooltip() : void
      {
         if(this.tooltip != null)
         {
            if(this.tooltip.parent != null)
            {
               this.tooltip.parent.removeChild(this.tooltip);
            }
            this.tooltip = null;
         }
      }
      
      private function removeMenu() : void
      {
         if(this.menu != null)
         {
            if(this.menu.parent != null)
            {
               this.menu.parent.removeChild(this.menu);
            }
            this.menu = null;
         }
      }
      
      public function draw() : void
      {
         var g:Graphics = null;
         var go:GameObject = null;
         var fillColor:uint = 0;
         var player:Player = null;
         var mmx:Number = NaN;
         var mmy:Number = NaN;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var distSq:Number = NaN;
         this.groundLayer_.graphics.clear();
         this.characterLayer_.graphics.clear();
         if(!this.focus)
         {
            return;
         }
         if(!this.active)
         {
            return;
         }
         var zoom:Number = this.zoomLevels[this.zoomIndex];
         this.mapMatrix_.identity();
         this.mapMatrix_.translate(-this.focus.x_,-this.focus.y_);
         this.mapMatrix_.scale(zoom,zoom);
         var upLeft:Point = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);
         var bottomRight:Point = this.mapMatrix_.transformPoint(this.maxWH_);
         var tx:Number = 0;
         if(upLeft.x > this.windowRect_.left)
         {
            tx = this.windowRect_.left - upLeft.x;
         }
         else if(bottomRight.x < this.windowRect_.right)
         {
            tx = this.windowRect_.right - bottomRight.x;
         }
         var ty:Number = 0;
         if(upLeft.y > this.windowRect_.top)
         {
            ty = this.windowRect_.top - upLeft.y;
         }
         else if(bottomRight.y < this.windowRect_.bottom)
         {
            ty = this.windowRect_.bottom - bottomRight.y;
         }
         this.mapMatrix_.translate(tx,ty);
         upLeft = this.mapMatrix_.transformPoint(PointUtil.ORIGIN);
         var drawRect:Rectangle = new Rectangle();
         drawRect.x = Math.max(this.windowRect_.x,upLeft.x);
         drawRect.y = Math.max(this.windowRect_.y,upLeft.y);
         drawRect.right = Math.min(this.windowRect_.right,upLeft.x + this.maxWH_.x * zoom);
         drawRect.bottom = Math.min(this.windowRect_.bottom,upLeft.y + this.maxWH_.y * zoom);
         g = this.groundLayer_.graphics;
         g.beginBitmapFill(this.miniMapData_,this.mapMatrix_,false);
         g.drawRect(drawRect.x,drawRect.y,drawRect.width,drawRect.height);
         g.endFill();
         g = this.characterLayer_.graphics;
         var mX:Number = mouseX - this._width / 2;
         var mY:Number = mouseY - this._height / 2;
         this.players_.length = 0;
         for each(go in this.map.goDict_)
         {
            if(!(go.props_.noMiniMap_ || go == this.focus))
            {
               player = go as Player;
               if(player != null)
               {
                  if(player.isPaused())
                  {
                     fillColor = 8355711;
                  }
                  else if(player.isPartyMember_)
                  {
                     fillColor = Parameters.PARTY_MEMBER_COLOR;
                  }
                  else if(player.isFellowGuild_)
                  {
                     fillColor = 65280;
                  }
                  else
                  {
                     fillColor = 16776960;
                  }
               }
               else if(go is Character)
               {
                  if(go.props_.isEnemy_)
                  {
                     fillColor = 16711680;
                     /*if(go.props_.isSpecialEnemy_)
                     {
                        if(go.objectType_ == 0x0935)
                           fillColor = 0x00FFFF;
                        else if(go.objectType_ == 0x734d)
                           fillColor = 0xDCDCDC;
                        else if(go.objectType_ == 0x4937)
                           fillColor = 0xFF8C00;
                     }*/
                  }
                  else
                  {
                     fillColor = gameObjectToColor(go);
                  }
               }
               else if(go is Portal || go is GuildHallPortal)
               {
                  fillColor = 255;
               }
               else
               {
                  continue;
               }
               mmx = this.mapMatrix_.a * go.x_ + this.mapMatrix_.c * go.y_ + this.mapMatrix_.tx;
               mmy = this.mapMatrix_.b * go.x_ + this.mapMatrix_.d * go.y_ + this.mapMatrix_.ty;
               if(mmx <= -this._width / 2 || mmx >= this._width / 2 || mmy <= -this._height / 2 || mmy >= this._height / 2)
               {
                  RectangleUtil.lineSegmentIntersectXY(this.windowRect_,0,0,mmx,mmy,this.tempPoint);
                  mmx = this.tempPoint.x;
                  mmy = this.tempPoint.y;
               }
               if(player != null && this.isMouseOver && (this.menu == null || this.menu.parent == null))
               {
                  dx = mX - mmx;
                  dy = mY - mmy;
                  distSq = dx * dx + dy * dy;
                  if(distSq < MOUSE_DIST_SQ)
                  {
                     this.players_.push(player);
                  }
               }
               g.beginFill(fillColor);
               g.drawRect(mmx - 2,mmy - 2,4,4);
               g.endFill();
            }
         }
         if(this.players_.length != 0)
         {
            if(this.tooltip == null)
            {
               this.tooltip = new PlayerGroupToolTip(this.players_);
               stage.addChild(this.tooltip);
            }
            else if(!this.areSamePlayers(this.tooltip.players_,this.players_))
            {
               this.tooltip.setPlayers(this.players_);
            }
         }
         else if(this.tooltip != null)
         {
            if(this.tooltip.parent != null)
            {
               this.tooltip.parent.removeChild(this.tooltip);
            }
            this.tooltip = null;
         }
         var px:Number = this.focus.x_;
         var py:Number = this.focus.y_;
         var ppx:Number = this.mapMatrix_.a * px + this.mapMatrix_.c * py + this.mapMatrix_.tx;
         var ppy:Number = this.mapMatrix_.b * px + this.mapMatrix_.d * py + this.mapMatrix_.ty;
         this.arrowMatrix_.identity();
         this.arrowMatrix_.translate(-4,-5);
         this.arrowMatrix_.scale(8 / this.blueArrow_.width,32 / this.blueArrow_.height);
         this.arrowMatrix_.rotate(Parameters.data_.cameraAngle);
         this.arrowMatrix_.translate(ppx,ppy);
         g.beginBitmapFill(this.blueArrow_,this.arrowMatrix_,false);
         g.drawRect(ppx - 16,ppy - 16,32,32);
         g.endFill();
      }
      
      private function areSamePlayers(players0:Vector.<Player>, players1:Vector.<Player>) : Boolean
      {
         var count:int = players0.length;
         if(count != players1.length)
         {
            return false;
         }
         for(var i:int = 0; i < count; i++)
         {
            if(players0[i] != players1[i])
            {
               return false;
            }
         }
         return true;
      }
      
      public function zoomIn() : void
      {
         this.zoomIndex = this.zoomButtons.setZoomLevel(this.zoomIndex - 1);
      }
      
      public function zoomOut() : void
      {
         this.zoomIndex = this.zoomButtons.setZoomLevel(this.zoomIndex + 1);
      }
      
      public function deactivate() : void
      {
         this.active = false;
         this.removeDecorations();
      }
   }
}
