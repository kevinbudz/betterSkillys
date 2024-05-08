package io.decagames.rotmg.ui.tabs
{
   import flash.display.Sprite;
   import flash.geom.Point;
   import org.osflash.signals.Signal;
   
   public class UITab extends Sprite
   {
       
      
      private var _tabName:String;
      
      private var _transparentBackgroundFix:Boolean;
      
      private var _content:Sprite;
      
      private var lastSize:Point;
      
      public var displaySignal:Signal;
      
      public function UITab(param1:String, param2:Boolean = false)
      {
         this.lastSize = new Point(0,0);
         this.displaySignal = new Signal(Boolean);
         super();
         this._tabName = param1;
         this._transparentBackgroundFix = param2;
      }
      
      public function addContent(param1:Sprite) : void
      {
         if(this._content && this._content.parent)
         {
            removeChild(this._content);
         }
         this._content = param1;
         addChild(this._content);
      }
      
      public function drawTransparentBackground() : void
      {
         if(this.lastSize.x != this.content.width || this.lastSize.y != this._content.height)
         {
            this.content.graphics.clear();
            this.content.graphics.beginFill(16711680,0);
            this.content.graphics.drawRect(0,0,this._content.width,this._content.height);
            this.lastSize.x = this._content.width;
            this.lastSize.y = this._content.height;
         }
      }
      
      public function get tabName() : String
      {
         return this._tabName;
      }
      
      public function set tabName(param1:String) : void
      {
         this._tabName = param1;
      }
      
      public function dispose() : void
      {
      }
      
      public function get transparentBackgroundFix() : Boolean
      {
         return this._transparentBackgroundFix;
      }
      
      public function get content() : Sprite
      {
         return this._content;
      }
   }
}
