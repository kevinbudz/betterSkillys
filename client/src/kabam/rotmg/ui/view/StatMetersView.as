package kabam.rotmg.ui.view
{
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.ui.StatusBar;
import flash.display.Sprite;
import flash.events.Event;

public class StatMetersView extends Sprite
{


   private var expBar_:StatusBar;

   private var fameBar_:StatusBar;

   private var hpBar_:StatusBar;

   private var mpBar_:StatusBar;

   public function StatMetersView()
   {
      super();
      this.expBar_ = new StatusBar(176,16,5931045,5526612,"Lvl X");
      this.fameBar_ = new StatusBar(176,16,14835456,5526612,"Fame");
      this.hpBar_ = new StatusBar(176,16,14693428,5526612,"HP");
      this.mpBar_ = new StatusBar(176,16,6325472,5526612,"MP");
      this.hpBar_.y = 24;
      this.mpBar_.y = 48;
      this.expBar_.visible = true;
      this.fameBar_.visible = false;
      addChild(this.expBar_);
      addChild(this.fameBar_);
      addChild(this.hpBar_);
      addChild(this.mpBar_);
   }

   public function update(player:Player) : void
   {
      var lvlText:String = "Lvl " + player.level_;
      if(lvlText != this.expBar_.labelText_.text)
      {
         this.expBar_.labelText_.text = lvlText;
         this.expBar_.labelText_.updateMetrics();
      }
      if(player.level_ != 20)
      {
         if(!this.expBar_.visible)
         {
            this.expBar_.visible = true;
            this.fameBar_.visible = false;
         }
         this.expBar_.draw(player.exp_,player.nextLevelExp_,0);
      }
      else
      {
         if(!this.fameBar_.visible)
         {
            this.fameBar_.visible = true;
            this.expBar_.visible = false;
         }
         this.fameBar_.draw(player.currFame_,player.nextClassQuestFame_,0);
      }
      this.hpBar_.draw(player.hp_,player.maxHP_,player.maxHPBoost_,player.maxHPMax_);
      this.mpBar_.draw(player.mp_,player.maxMP_,player.maxMPBoost_,player.maxMPMax_);
   }
}
}
