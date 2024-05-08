package kabam.rotmg.game.view.components
{
import com.company.assembleegameclient.objects.Player;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import kabam.rotmg.game.model.StatModel;
import org.osflash.signals.natives.NativeSignal;

public class StatsView extends Sprite
{

   public static const ATTACK:int = 0;

   public static const DEFENSE:int = 1;

   public static const SPEED:int = 2;

   public static const DEXTERITY:int = 3;

   public static const VITALITY:int = 4;

   public static const WISDOM:int = 5;

   public static const NUM_STAT:int = 6;

   public static const STATE_UNDOCKED:String = "state_undocked";

   public static const STATE_DOCKED:String = "state_docked";

   public static const STATE_DEFAULT:String = STATE_DOCKED;

   private static const statsModel:Array = [new StatModel("ATT","Attack","This stat increases the amount of damage done.",true),new StatModel("DEF","Defense","This stat decreases the amount of damage taken.",false),new StatModel("SPD","Speed","This stat increases the speed at which the character moves.",true),new StatModel("DEX","Dexterity","This stat increases the speed at which the character attacks.",true),new StatModel("VIT","Vitality","This stat increases the speed at which hit points are recovered.",true),new StatModel("WIS","Wisdom","This stat increases the speed at which magic points are recovered.",true)];


   public var w_:int;

   public var h_:int;

   public var stats_:Vector.<StatView>;

   public var currentState:String;

   private var bgSprite:Sprite;

   public var containerSprite:Sprite;

   public var mouseDown:NativeSignal;

   public function StatsView(w:int, h:int)
   {
      var i:int = 0;
      var statModel:StatModel = null;
      var stat:StatView = null;
      this.stats_ = new Vector.<StatView>();
      this.containerSprite = new Sprite();
      super();
      this.w_ = w;
      this.h_ = h;
      this.mouseDown = new NativeSignal(this,MouseEvent.MOUSE_DOWN,MouseEvent);
      var rows:int = 0;
      this.drawBG();
      for(i = 0; i < statsModel.length; i++)
      {
         statModel = statsModel[i];
         stat = new StatView(statModel.name,statModel.abbreviation,statModel.description,statModel.redOnZero);
         stat.x = i % 2 * this.w_ / 2;
         stat.y = rows * (this.h_ / 3);
         this.containerSprite.addChild(stat);
         this.stats_.push(stat);
         rows = rows + i % 2;
      }
      addChild(this.containerSprite);
      this.currentState = STATE_DEFAULT;
   }

   public function dock() : void
   {
      this.currentState = STATE_DOCKED;
   }

   public function undock() : void
   {
      this.currentState = STATE_UNDOCKED;
   }

   public function draw(go:Player) : void
   {
      if(go != null)
      {
         this.checkBG();
         this.stats_[ATTACK].draw(go.attack_,go.attackBoost_,go.attackMax_);
         this.stats_[DEFENSE].draw(go.defense_,go.defenseBoost_,go.defenseMax_);
         this.stats_[SPEED].draw(go.speed_,go.speedBoost_,go.speedMax_);
         this.stats_[DEXTERITY].draw(go.dexterity_,go.dexterityBoost_,go.dexterityMax_);
         this.stats_[VITALITY].draw(go.vitality_,go.vitalityBoost_,go.vitalityMax_);
         this.stats_[WISDOM].draw(go.wisdom_,go.wisdomBoost_,go.wisdomMax_);
      }
      this.containerSprite.x = 30 + (191 - this.containerSprite.width) * 0.5;
   }

   private function drawBG() : void
   {
      this.bgSprite = new Sprite();
      var g:Graphics = this.bgSprite.graphics;
      g.clear();
      g.beginFill(3552822);
      g.drawRect(0,0,this.w_,this.h_);
      g.endFill();
      addChild(this.bgSprite);
   }

   private function checkBG() : void
   {
      if(this.currentState == STATE_UNDOCKED)
      {
         this.bgSprite.alpha = 1;
      }
      else if(this.currentState == STATE_DOCKED)
      {
         this.bgSprite.alpha = 0;
      }
   }
}
}
