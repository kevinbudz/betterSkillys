package kabam.rotmg.util.components
{
   import com.company.assembleegameclient.util.Currency;
   import com.company.ui.SimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.IGraphicsData;
   import flash.events.MouseEvent;
   import kabam.rotmg.assets.services.IconFactory;
   import kabam.rotmg.util.components.api.BuyButton;
   
   public class LegacyBuyButton extends BuyButton
   {
      private static const BEVEL:int = 4;
      private static const PADDING:int = 5;
      public static const coin:BitmapData = IconFactory.makeCoin();
      public static const fame:BitmapData = IconFactory.makeFame();
      public static const guildFame:BitmapData = IconFactory.makeGuildFame();

      public var prefix:String;
      public var text:SimpleText;
      public var icon:Bitmap;
      public var price:int = -1;
      public var currency:int = -1;
      public var _width:int = -1;
      private const enabledFill:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      private const disabledFill:GraphicsSolidFill = new GraphicsSolidFill(8355711,1);
      private const graphicsPath:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      private const graphicsData:Vector.<IGraphicsData> = new <IGraphicsData>[enabledFill,graphicsPath,GraphicsUtil.END_FILL];
      
      public function LegacyBuyButton(prefix:String, size:int, price:int, currency:int)
      {
         super();
         this.prefix = prefix;
         this.text = new SimpleText(size,3552822,false,0,0);
         this.text.setBold(true);
         addChild(this.text);
         this.icon = new Bitmap();
         addChild(this.icon);
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.setPrice(price,currency);
      }
      
      override public function setPrice(price:int, currency:int) : void
      {
         if(this.price != price || this.currency != currency)
         {
            this.price = price;
            this.currency = currency;
            this.updateUI();
         }
      }
      
      override public function setEnabled(enabled:Boolean) : void
      {
         if(enabled != mouseEnabled)
         {
            mouseEnabled = enabled;
            this.draw();
         }
      }
      
      override public function setWidth(value:int) : void
      {
         this._width = value;
         this.updateUI();
      }
      
      private function updateUI() : void
      {
         this.updateText();
         this.updateIcon();
         this.updateBackground();
         this.draw();
      }
      
      private function updateIcon() : void
      {
         switch(this.currency)
         {
            case Currency.GOLD:
               this.icon.bitmapData = coin;
               break;
            case Currency.FAME:
               this.icon.bitmapData = fame;
               break;
            case Currency.GUILD_FAME:
               this.icon.bitmapData = guildFame;
               break;
            default:
               this.icon.bitmapData = null;
         }
         this.updateIconPosition();
      }
      
      private function updateBackground() : void
      {
         GraphicsUtil.clearPath(this.graphicsPath);
         GraphicsUtil.drawCutEdgeRect(0,0,this.getWidth(),this.getHeight(),BEVEL,[1,1,1,1],this.graphicsPath);
      }
      
      private function updateText() : void
      {
         this.text.text = this.prefix + this.price.toString();
         this.text.updateMetrics();
         this.text.x = (this.getWidth() - this.icon.width - this.text.textWidth - PADDING) * 0.5;
         this.text.y = 1;
      }
      
      private function updateIconPosition() : void
      {
         this.icon.x = this.text.x + this.text.textWidth + PADDING;
         this.icon.y = (this.getHeight() - this.icon.height) * 0.5;
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.enabledFill.color = 16768133;
         this.draw();
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this.enabledFill.color = 16777215;
         this.draw();
      }
      
      private function draw() : void
      {
         this.graphicsData[0] = mouseEnabled?this.enabledFill:this.disabledFill;
         graphics.clear();
         graphics.drawGraphicsData(this.graphicsData);
      }
      
      private function getWidth() : int
      {
         return Math.max(this._width,this.text.width + this.icon.width + 3 * PADDING);
      }
      
      private function getHeight() : int
      {
         return this.text.textHeight + 8;
      }
   }
}
