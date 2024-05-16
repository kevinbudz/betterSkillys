package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.ui.SimpleText;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;

import io.decagames.rotmg.fame.FameContentPopup;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.ui.view.SignalWaiter;

import org.osflash.signals.Signal;
import org.swiftsuspenders.Injector;

public class CreditDisplay extends Sprite
   {

      private static const FONT_SIZE:int = 18;


      private var creditsText_:SimpleText;

      private var fameText_:SimpleText;

      private var coinIcon_:Bitmap;

      private var fameIcon_:Bitmap;

      private var credits_:int = -1;

      private var fame_:int = -1;

      public var _fameButton:SliceScalingButton;

      public var displayFameTooltip:Signal = new Signal();

      public var showButton:Boolean;

      public var gs:GameSprite;

      public static const waiter:SignalWaiter = new SignalWaiter();

      public function CreditDisplay(gs:GameSprite = null, fameButton:Boolean = false)
      {
         super();
         this.gs = gs;
         this.showButton = fameButton;
         this.creditsText_ = new SimpleText(FONT_SIZE,16777215,false,0,0);
         this.creditsText_.setBold(true);
         this.creditsText_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         addChild(this.creditsText_);
         var coinBD:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",225);
         coinBD = TextureRedrawer.redraw(coinBD,40,true,0);
         this.coinIcon_ = new Bitmap(coinBD);
         addChild(this.coinIcon_);
         this.fameText_ = new SimpleText(FONT_SIZE,16777215,false,0,0);
         this.fameText_.setBold(true);
         this.fameText_.filters = [new DropShadowFilter(0,0,0,1,4,4,2)];
         addChild(this.fameText_);
         this.fameIcon_ = new Bitmap(FameUtil.getFameIcon());
         addChild(this.fameIcon_);
         this.draw(0,0);
         mouseEnabled = false;
         doubleClickEnabled = false;
      }

      public function addResourceButtons():void
      {
         this._fameButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "tab_info_button"));
         addChild(this._fameButton);
      }

      public function removeResourceButtons():void
      {
         if (this._fameButton)
         {
            removeChild(this._fameButton);
         }
      }

      public function onFameClick(_arg_1:MouseEvent):void
      {
         this.onFameMask();
      }

      private function onFameMask():void
      {
         var _local_1:Injector = StaticInjectorContext.getInjector();
         var _local_2:OpenDialogSignal = _local_1.getInstance(OpenDialogSignal);
         this.gs.scaledLayer.addChild(new FameContentPopup());
      }

      public function draw(credits:int, fame:int) : void
      {
         if(credits == this.credits_ && fame == this.fame_)
         {
            return;
         }
         this.credits_ = credits;
         this.fame_ = fame;
         this.coinIcon_.x = -this.coinIcon_.width;
         this.fameIcon_.x = -this.fameIcon_.width;
         this.creditsText_.text = this.credits_.toString();
         this.creditsText_.updateMetrics();
         this.fameText_.text = this.fame_.toString();
         this.fameText_.updateMetrics();
         this.creditsText_.x = this.coinIcon_.x - this.creditsText_.width + 8;
         this.creditsText_.y = (this.coinIcon_.height / 2 - this.creditsText_.height / 2);
         this.fameText_.x = this.fameIcon_.x - this.fameText_.width + 8;
         this.fameText_.y = (creditsText_.height + 4 + this.fameIcon_.height / 2 - this.fameText_.height / 2) - 5;
         this.fameIcon_.y = 35 - this.fameIcon_.height /2 + 8;
         if (this._fameButton)
         {
            this._fameButton.x = ((this.fameIcon_.x - this.fameText_.width) - 16);
            this._fameButton.y = 19;
         }
      }
   }
}
