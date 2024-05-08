package kabam.rotmg.minimap.view
{
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import org.osflash.signals.Signal;
   
   public class MiniMapZoomButtons extends Sprite
   {
       
      
      private const FADE:ColorTransform = new ColorTransform(0.5,0.5,0.5);
      
      private const NORM:ColorTransform = new ColorTransform(1,1,1);
      
      public const zoom:Signal = new Signal(int);
      
      private var zoomOut:Sprite;
      
      private var zoomIn:Sprite;
      
      private var zoomLevels:int;
      
      private var zoomLevel:int;
      
      public function MiniMapZoomButtons()
      {
         super();
         this.zoomLevel = 0;
         this.makeZoomOut();
         this.makeZoomIn();
         this.updateButtons();
      }
      
      public function getZoomLevel() : int
      {
         return this.zoomLevel;
      }
      
      public function setZoomLevel(value:int) : int
      {
         if(this.zoomLevels == 0)
         {
            return this.zoomLevel;
         }
         if(value < 0)
         {
            value = 0;
         }
         else if(value >= this.zoomLevels - 1)
         {
            value = this.zoomLevels - 1;
         }
         this.zoomLevel = value;
         this.updateButtons();
         return this.zoomLevel;
      }
      
      public function setZoomLevels(count:int) : int
      {
         this.zoomLevels = count;
         if(this.zoomLevel >= this.zoomLevels)
         {
            this.zoomLevel = this.zoomLevels - 1;
         }
         this.updateButtons();
         return this.zoomLevels;
      }
      
      private function makeZoomOut() : void
      {
         var data:BitmapData = AssetLibrary.getImageFromSet("lofiInterface",54);
         var bitmap:Bitmap = new Bitmap(data);
         bitmap.scaleX = 2;
         bitmap.scaleY = 2;
         this.zoomOut = new Sprite();
         this.zoomOut.x = 0;
         this.zoomOut.y = 4;
         this.zoomOut.addChild(bitmap);
         this.zoomOut.addEventListener(MouseEvent.CLICK,this.onZoomOut);
         addChild(this.zoomOut);
      }
      
      private function makeZoomIn() : void
      {
         var data:BitmapData = AssetLibrary.getImageFromSet("lofiInterface",55);
         var bitmap:Bitmap = new Bitmap(data);
         bitmap.scaleX = 2;
         bitmap.scaleY = 2;
         this.zoomIn = new Sprite();
         this.zoomIn.x = 0;
         this.zoomIn.y = 14;
         this.zoomIn.addChild(bitmap);
         this.zoomIn.addEventListener(MouseEvent.CLICK,this.onZoomIn);
         addChild(this.zoomIn);
      }
      
      private function onZoomOut(event:MouseEvent) : void
      {
         if(this.canZoomOut())
         {
            this.zoom.dispatch(--this.zoomLevel);
            this.zoomOut.transform.colorTransform = !!this.canZoomOut()?this.NORM:this.FADE;
         }
      }
      
      private function canZoomOut() : Boolean
      {
         return this.zoomLevel > 0;
      }
      
      private function onZoomIn(event:MouseEvent) : void
      {
         if(this.canZoomIn())
         {
            this.zoom.dispatch(++this.zoomLevel);
            this.zoomIn.transform.colorTransform = !!this.canZoomIn()?this.NORM:this.FADE;
         }
      }
      
      private function canZoomIn() : Boolean
      {
         return this.zoomLevel < this.zoomLevels - 1;
      }
      
      private function updateButtons() : void
      {
         this.zoomIn.transform.colorTransform = !!this.canZoomIn()?this.NORM:this.FADE;
         this.zoomOut.transform.colorTransform = !!this.canZoomOut()?this.NORM:this.FADE;
      }
   }
}
