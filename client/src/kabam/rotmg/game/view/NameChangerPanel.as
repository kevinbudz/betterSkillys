package kabam.rotmg.game.view
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.RankText;
   import com.company.assembleegameclient.ui.TextButton;
   import com.company.assembleegameclient.ui.panels.Panel;
   import com.company.assembleegameclient.util.Currency;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import kabam.rotmg.util.components.LegacyBuyButton;
   import org.osflash.signals.Signal;
   
   public class NameChangerPanel extends Panel
   {
       
      
      public var chooseName:Signal;
      
      public var buy_:Boolean;
      
      private var title_:SimpleText;
      
      private var button_:Sprite;
      
      public function NameChangerPanel(gs:GameSprite, rankRequired:int)
      {
         var buyButton:LegacyBuyButton = null;
         var rankReqText:Sprite = null;
         var requiredText:SimpleText = null;
         var rankText:Sprite = null;
         this.chooseName = new Signal();
         super(gs);
         if(gs_.map == null || gs_.map.player_ == null)
         {
            return;
         }
         var p:Player = gs_.map.player_;
         this.buy_ = p.nameChosen_;
         var name:String = gs_.model.getName();
         this.title_ = new SimpleText(18,16777215,false,WIDTH,0);
         this.title_.setBold(true);
         this.title_.wordWrap = true;
         this.title_.multiline = true;
         this.title_.autoSize = TextFieldAutoSize.CENTER;
         this.title_.filters = [new DropShadowFilter(0,0,0)];
         if(this.buy_)
         {
            this.title_.htmlText = this.makeNameText(name);
            this.title_.y = 0;
            addChild(this.title_);
            buyButton = new LegacyBuyButton("Change ",16,Parameters.NAME_CHANGE_PRICE,Currency.GOLD);
            buyButton.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            buyButton.x = WIDTH / 2 - buyButton.width / 2;
            buyButton.y = HEIGHT - buyButton.height / 2 - 17;
            addChild(buyButton);
            this.button_ = buyButton;
         }
         else if(p.numStars_ < rankRequired)
         {
            this.title_.htmlText = "<p align=\"center\">Choose Account Name</p>";
            addChild(this.title_);
            rankReqText = new Sprite();
            requiredText = new SimpleText(16,16777215,false,0,0);
            requiredText.setBold(true);
            requiredText.text = "Rank Required:";
            requiredText.updateMetrics();
            requiredText.filters = [new DropShadowFilter(0,0,0)];
            rankReqText.addChild(requiredText);
            rankText = new RankText(rankRequired,false,false);
            rankText.x = requiredText.width + 4;
            rankText.y = requiredText.height / 2 - rankText.height / 2;
            rankReqText.addChild(rankText);
            rankReqText.x = WIDTH / 2 - rankReqText.width / 2;
            rankReqText.y = HEIGHT - rankReqText.height / 2 - 20;
            addChild(rankReqText);
         }
         else
         {
            this.title_.htmlText = "<p align=\"center\">Choose Account Name</p>";
            this.title_.y = 6;
            addChild(this.title_);
            this.button_ = new TextButton(16,"Choose");
            this.button_.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            this.button_.x = WIDTH / 2 - this.button_.width / 2;
            this.button_.y = HEIGHT - this.button_.height - 4;
            addChild(this.button_);
         }
      }
      
      private function makeNameText(name:String) : String
      {
         return "<p align=\"center\">Your name is: \n" + name + "</p>";
      }
      
      private function onButtonClick(event:MouseEvent) : void
      {
         this.chooseName.dispatch();
      }
      
      public function updateName(name:String) : void
      {
         if(this.title_.htmlText)
         {
            this.title_.htmlText = this.makeNameText(name);
            this.title_.y = 0;
         }
      }
   }
}
