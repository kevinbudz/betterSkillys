package kabam.rotmg.classes.view
{
   import com.company.assembleegameclient.util.Currency;
   import com.company.ui.SimpleText;
   import com.company.util.MoreColorUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.CharacterSkinState;
   import kabam.rotmg.util.components.RadioButton;
   import kabam.rotmg.util.components.api.BuyButton;
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class CharacterSkinListItem extends Sprite
   {
      public static const WIDTH:int = 420;
      public static const PADDING:int = 16;
      public static const HEIGHT:int = 60;
      private static const UNLOCK_TEXT:String = "Unlock at Level {LEVEL}";
      private static const HIGHLIGHTED_COLOR:uint = 8092539;
      private static const AVAILABLE_COLOR:uint = 5921370;
      private static const LOCKED_COLOR:uint = 2631720;

      private const grayscaleMatrix:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.greyscaleFilterMatrix);
      private const background:Shape = makeBackground();
      private const skinContainer:Sprite = makeSkinContainer();
      private const nameText:SimpleText = makeNameText();
      private const selectionButton:RadioButton = makeSelectionButton();
      private const lock:Bitmap = makeLock();
      private const lockText:SimpleText = makeLockText();
      private const buyButtonContainer:Sprite = makeBuyButtonContainer();
      public const buy:Signal = new NativeMappedSignal(buyButtonContainer,MouseEvent.CLICK);
      public const over:Signal = new Signal();
      public const out:Signal = new Signal();
      public const selected:Signal = selectionButton.changed;
      private var model:CharacterSkin;
      private var state:CharacterSkinState;
      private var isSelected:Boolean = false;
      private var skinIcon:Bitmap;
      private var buyButton:BuyButton;
      private var isOver:Boolean;
      
      public function CharacterSkinListItem()
      {
         this.state = CharacterSkinState.NULL;
         super();
      }
      
      private function makeBackground() : Shape
      {
         var shape:Shape = new Shape();
         this.drawBackground(shape.graphics,WIDTH);
         addChild(shape);
         return shape;
      }
      
      private function makeSkinContainer() : Sprite
      {
         var sprite:Sprite = new Sprite();
         sprite.x = 8;
         sprite.y = 4;
         addChild(sprite);
         return sprite;
      }
      
      private function makeNameText() : SimpleText
      {
         var text:SimpleText = new SimpleText(18,16777215,false,0,0);
         text.x = 75;
         text.y = 15;
         text.setBold(true);
         text.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         addChild(text);
         return text;
      }
      
      private function makeSelectionButton() : RadioButton
      {
         var button:RadioButton = new RadioButton();
         button.setSelected(false);
         button.x = WIDTH - button.width - 15;
         button.y = HEIGHT / 2 - button.height / 2;
         addChild(button);
         return button;
      }
      
      private function makeLock() : Bitmap
      {
         var bitmap:Bitmap = new Bitmap();
         bitmap.scaleX = 2;
         bitmap.scaleY = 2;
         bitmap.y = HEIGHT * 0.5 - 4;
         bitmap.visible = false;
         addChild(bitmap);
         return bitmap;
      }
      
      public function setLockIcon(data:BitmapData) : void
      {
         this.lock.bitmapData = data;
         this.lock.x = this.lockText.x - this.lock.width - 5;
      }
      
      private function makeLockText() : SimpleText
      {
         var text:SimpleText = new SimpleText(14,16777215,false,0,0);
         addChild(text);
         return text;
      }
      
      private function makeBuyButtonContainer() : Sprite
      {
         var container:Sprite = new Sprite();
         container.x = WIDTH - PADDING;
         container.y = HEIGHT * 0.5;
         addChild(container);
         return container;
      }
      
      public function setBuyButton(buyButton:BuyButton) : void
      {
         this.buyButton = buyButton;
         this.model && this.setCost();
         this.buyButtonContainer.addChild(buyButton);
         buyButton.x = -buyButton.width;
         buyButton.y = -buyButton.height * 0.5;
         this.buyButtonContainer.visible = this.state == CharacterSkinState.PURCHASABLE;
      }
      
      public function setSkin(icon:Bitmap) : void
      {
         this.skinIcon && this.skinContainer.removeChild(this.skinIcon);
         this.skinIcon = icon;
         this.skinIcon && this.skinContainer.addChild(this.skinIcon);
      }
      
      public function getModel() : CharacterSkin
      {
         return this.model;
      }
      
      public function setModel(value:CharacterSkin) : void
      {
         this.model && this.model.changed.remove(this.onModelChanged);
         this.model = value;
         this.model && this.model.changed.add(this.onModelChanged);
         this.onModelChanged(this.model);
         addEventListener(MouseEvent.MOUSE_OVER,this.onOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onOut);
      }
      
      private function onModelChanged(skin:CharacterSkin) : void
      {
         this.state = Boolean(this.model)?this.model.getState():CharacterSkinState.NULL;
         this.updateName();
         this.updateState();
         this.buyButton && this.setCost();
         this.updateUnlockText();
         this.setIsSelected(this.model && this.model.getIsSelected());
      }
      
      public function getState() : CharacterSkinState
      {
         return this.state;
      }
      
      private function updateName() : void
      {
         this.nameText.text = Boolean(this.model)?this.model.name:"";
         this.nameText.updateMetrics();
      }
      
      private function updateState() : void
      {
         this.setButtonVisibilities();
         this.updateBackground();
         this.setEventListeners();
         this.updateGrayFilter();
      }
      
      private function setButtonVisibilities() : void
      {
         var isOwned:Boolean = this.state == CharacterSkinState.OWNED;
         var isPurchasable:Boolean = this.state == CharacterSkinState.PURCHASABLE;
         var isPurchasing:Boolean = this.state == CharacterSkinState.PURCHASING;
         var isLocked:Boolean = this.state == CharacterSkinState.LOCKED;
         this.selectionButton.visible = isOwned;
         this.buyButtonContainer && (this.buyButtonContainer.visible = isPurchasable);
         this.lock.visible = isLocked;
         this.lockText.visible = isLocked || isPurchasing;
      }
      
      private function setEventListeners() : void
      {
         if(this.state == CharacterSkinState.OWNED)
         {
            this.addEventListeners();
         }
         else
         {
            this.removeEventListeners();
         }
      }
      
      private function setCost() : void
      {
         var cost:int = Boolean(this.model)?int(this.model.cost):int(300);
         this.buyButton.setPrice(cost, Currency.GOLD);
         this.buyButton.setWidth(120);
      }
      
      public function getIsSelected() : Boolean
      {
         return this.isSelected;
      }
      
      public function setIsSelected(value:Boolean) : void
      {
         this.isSelected = value && this.state == CharacterSkinState.OWNED;
         this.selectionButton.setSelected(value);
         this.updateBackground();
      }
      
      private function updateUnlockText() : void
      {
         this.lockText.text = this.state == CharacterSkinState.PURCHASING?"Purchasing...":this.makeUnlockText();
         this.lockText.updateMetrics();
         this.lockText.x = WIDTH - this.lockText.width - 15;
         this.lockText.y = HEIGHT / 2 - this.lockText.height / 2;
         this.lock.x = this.lockText.x - this.lock.width - 5;
      }
      
      private function makeUnlockText() : String
      {
         var level:String = Boolean(this.model)?this.model.unlockLevel.toString():"";
         return UNLOCK_TEXT.replace("{LEVEL}",level);
      }
      
      private function addEventListeners() : void
      {
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      internal function removeEventListeners() : void
      {
         removeEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(e:MouseEvent) : void
      {
         this.setIsSelected(true);
      }
      
      private function onOver(e:MouseEvent) : void
      {
         this.isOver = true;
         this.updateBackground();
         this.over.dispatch();
      }
      
      private function onOut(e:MouseEvent) : void
      {
         this.isOver = false;
         this.updateBackground();
         this.out.dispatch();
      }
      
      private function updateBackground() : void
      {
         var ct:ColorTransform = this.background.transform.colorTransform;
         ct.color = this.getColor();
         this.background.transform.colorTransform = ct;
      }
      
      private function getColor() : uint
      {
         if(this.state.isDisabled())
         {
            return LOCKED_COLOR;
         }
         if(this.isSelected || this.isOver)
         {
            return HIGHLIGHTED_COLOR;
         }
         return AVAILABLE_COLOR;
      }
      
      private function updateGrayFilter() : void
      {
         filters = this.state == CharacterSkinState.PURCHASING?[this.grayscaleMatrix]:[];
      }
      
      public function setWidth(width:int) : void
      {
         this.buyButtonContainer.x = width - PADDING;
         this.lockText.x = width - this.lockText.width - 15;
         this.lock.x = this.lockText.x - this.lock.width - 5;
         this.selectionButton.x = width - this.selectionButton.width - 15;
         this.drawBackground(this.background.graphics,width);
      }
      
      private function drawBackground(graphics:Graphics, width:int) : void
      {
         graphics.clear();
         graphics.beginFill(AVAILABLE_COLOR);
         graphics.drawRect(0,0,width,HEIGHT);
         graphics.endFill();
      }
   }
}
