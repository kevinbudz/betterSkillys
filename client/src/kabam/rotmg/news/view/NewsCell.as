package kabam.rotmg.news.view
{
   import com.company.ui.SimpleText;
   import flash.display.Loader;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.net.URLRequest;
   import kabam.rotmg.news.model.NewsCellVO;
   import org.osflash.signals.Signal;
   
   public class NewsCell extends Sprite
   {
      
      internal static var DefaultGraphicLarge:Class = NewsCell_DefaultGraphicLarge;
      
      internal static var DefaultGraphicSmall:Class = NewsCell_DefaultGraphicSmall;
      
      private static const BOX_HEIGHT:uint = 25;
      
      private static const LARGE:String = "LARGE";
      
      private static const SMALL:String = "SMALL";
       
      
      private var imageContainer:Sprite;
      
      private var maskShape:Shape;
      
      private var boxShape:Shape;
      
      private var textField:SimpleText;
      
      private var size:String;
      
      private var w:Number;
      
      private var h:Number;
      
      private var _vo:NewsCellVO;
      
      private var _loader:Loader;
      
      private var textSize:uint = 17;
      
      public var clickSignal:Signal;
      
      public function NewsCell(w:Number, h:Number)
      {
         this.clickSignal = new Signal(NewsCellVO);
         super();
         this.setSize(w,h);
         this.initImageContainer();
         this.initMask();
         this.initBox();
         this.initTextField();
      }
      
      private function setSize(w:Number, h:Number) : void
      {
         this.w = w;
         this.h = h;
         if(w == 306 && h == 194)
         {
            this.size = LARGE;
         }
         else if(w == 151 && h == 189)
         {
            this.size = SMALL;
         }
      }
      
      public function init(vo:NewsCellVO) : void
      {
         this._vo = vo;
         this.updateTextField();
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         buttonMode = true;
      }
      
      private function addDisplayAssets() : void
      {
         addChild(this.maskShape = new Shape());
         addChild(this.boxShape = new Shape());
      }
      
      private function initImageContainer() : void
      {
         this.imageContainer = new Sprite();
         addChild(this.imageContainer);
      }
      
      private function initMask() : void
      {
         this.maskShape = new Shape();
         this.maskShape.graphics.beginFill(16711935);
         this.maskShape.graphics.drawRect(0,0,this.w,this.h);
         this.imageContainer.mask = this.maskShape;
         addChild(this.maskShape);
      }
      
      private function initBox() : void
      {
         this.boxShape = new Shape();
         this.boxShape.graphics.beginFill(0,0.8);
         this.boxShape.graphics.drawRect(0,this.h - BOX_HEIGHT,this.w,BOX_HEIGHT);
         addChild(this.boxShape);
      }
      
      private function initTextField() : void
      {
         this.textField = new SimpleText(this.textSize,16777215,false,0,0);
         addChild(this.textField);
      }
      
      private function updateTextField() : void
      {
         this.textField.text = this._vo.headline;
         this.textField.setBold(true);
         this.textField.updateMetrics();
         this.resizeTextField();
         this.textField.x = (this.w - this.textField.width) * 0.5;
         this.textField.y = this.h - 13 - this.textField.height / 2;
         this.textField.filters = [new DropShadowFilter(0,0,0)];
      }
      
      private function resizeTextField() : void
      {
         if(this.textField.width > this.w - 10)
         {
            this.textSize = this.textSize - 2;
            this.textField.setSize(this.textSize).setColor(16777215).updateMetrics();
            this.resizeTextField();
         }
      }
      
      public function load() : void
      {
         this._loader = new Loader();
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onComplete);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onIOError);
         this._loader.load(new URLRequest(this._vo.imageURL));
      }
      
      private function onComplete(event:Event) : void
      {
         this.imageContainer.addChild(this._loader);
      }
      
      private function onIOError(event:IOErrorEvent) : void
      {
         switch(this.size)
         {
            case LARGE:
               this.imageContainer.addChild(new DefaultGraphicLarge());
               break;
            case SMALL:
               this.imageContainer.addChild(new DefaultGraphicSmall());
         }
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         this.clickSignal.dispatch(this._vo);
      }
   }
}
