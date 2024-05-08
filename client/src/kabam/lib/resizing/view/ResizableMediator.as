package kabam.lib.resizing.view
{
   import flash.display.DisplayObject;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import kabam.lib.resizing.signals.Resize;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class ResizableMediator extends Mediator
   {
       
      
      [Inject]
      public var view:Resizable;
      
      [Inject]
      public var resize:Resize;
      
      public function ResizableMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         var stage:Stage = (this.view as DisplayObject).stage;
         var rectangle:Rectangle = new Rectangle(0,0,stage.stageWidth,stage.stageHeight);
         this.resize.add(this.onResize);
         this.view.resize(rectangle);
      }
      
      override public function destroy() : void
      {
         this.resize.remove(this.onResize);
      }
      
      private function onResize(rectangle:Rectangle) : void
      {
         this.view.resize(rectangle);
      }
   }
}
