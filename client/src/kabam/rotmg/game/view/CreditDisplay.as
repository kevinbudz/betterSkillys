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
   import org.osflash.signals.Signal;
   
   public class CreditDisplay extends Sprite
   {
      
      private static const FONT_SIZE:int = 18;
       
      
      private var creditsText_:SimpleText;
      
      private var fameText_:SimpleText;
      
      private var coinIcon_:Bitmap;
      
      private var fameIcon_:Bitmap;
      
      private var credits_:int = -1;
      
      private var fame_:int = -1;
      
      private var gs:GameSprite;
      
      public function CreditDisplay(gs:GameSprite = null)
      {
         super();
         this.gs = gs;
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
      }
   }
}
