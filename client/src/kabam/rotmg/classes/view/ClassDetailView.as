package kabam.rotmg.classes.view
{
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.ui.SimpleText;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import kabam.rotmg.assets.model.Animation;
   import kabam.rotmg.util.components.StarsView;
   
   public class ClassDetailView extends Sprite
   {
      
      private static const RIGHT_JUSTIFICATION_STATS:int = 205;
      
      private static const WIDTH:int = 344;
      
      private static const TEXT_WIDTH:int = 188;
       
      
      private var classNameText:SimpleText;
      
      private var classDescriptionText:SimpleText;
      
      private var questCompletionText:SimpleText;
      
      private var levelTitleText:SimpleText;
      
      private var levelText:SimpleText;
      
      private var fameTitleText:SimpleText;
      
      private var fameText:SimpleText;
      
      private var fameIcon:Bitmap;
      
      private var nextGoalText:SimpleText;
      
      private var nextGoalDetailText:SimpleText;
      
      private var questCompletedStars:StarsView;
      
      private var animContainer:Sprite;
      
      private var animation:Animation;
      
      public function ClassDetailView()
      {
         var dropShadowFilter:DropShadowFilter = null;
         super();
         dropShadowFilter = new DropShadowFilter(0,0,0,1,8,8);
         this.animContainer = new Sprite();
         this.animContainer.x = (WIDTH - 104) * 0.5;
         addChild(this.animContainer);
         this.classNameText = new SimpleText(20,16777215,false,0,0);
         this.classNameText.setBold(true);
         this.classNameText.filters = [dropShadowFilter];
         this.classNameText.width = TEXT_WIDTH;
         this.classNameText.autoSize = TextFieldAutoSize.CENTER;
         addChild(this.classNameText);
         this.classDescriptionText = new SimpleText(14,16777215,false,0,0);
         this.classDescriptionText.filters = [dropShadowFilter];
         this.classDescriptionText.width = TEXT_WIDTH;
         this.classDescriptionText.wordWrap = true;
         var tf:TextFormat = this.classDescriptionText.getTextFormat();
         tf.align = TextFormatAlign.CENTER;
         this.classDescriptionText.defaultTextFormat = tf;
         this.classDescriptionText.setTextFormat(tf);
         addChild(this.classDescriptionText);
         this.questCompletionText = new SimpleText(14,16777215,false,0,0);
         this.questCompletionText.filters = [dropShadowFilter];
         this.questCompletionText.text = "Class Quests Completed";
         this.questCompletionText.setBold(true);
         this.questCompletionText.updateMetrics();
         addChild(this.questCompletionText);
         this.levelTitleText = new SimpleText(14,16777215,false,0,0);
         this.levelTitleText.filters = [dropShadowFilter];
         this.levelTitleText.text = "Highest Level Achieved";
         this.levelTitleText.setBold(true);
         this.levelTitleText.updateMetrics();
         addChild(this.levelTitleText);
         this.levelText = new SimpleText(16,16777215,false,0,0);
         this.levelText.filters = [dropShadowFilter];
         this.levelText.setBold(true);
         addChild(this.levelText);
         this.fameTitleText = new SimpleText(14,16777215,false,0,0);
         this.fameTitleText.filters = [dropShadowFilter];
         this.fameTitleText.text = "Most Fame Achieved";
         this.fameTitleText.setBold(true);
         this.fameTitleText.updateMetrics();
         addChild(this.fameTitleText);
         this.fameText = new SimpleText(16,15387756,false,0,0);
         this.fameText.filters = [dropShadowFilter];
         this.fameText.setBold(true);
         addChild(this.fameText);
         this.fameIcon = new Bitmap(FameUtil.getFameIcon());
         this.fameIcon.filters = [dropShadowFilter];
         addChild(this.fameIcon);
         this.nextGoalText = new SimpleText(14,16777215,false,0,0);
         this.nextGoalText.setBold(true);
         this.nextGoalText.filters = [dropShadowFilter];
         this.nextGoalText.text = "Next Goal:";
         this.nextGoalText.updateMetrics();
         this.nextGoalText.visible = false;
         addChild(this.nextGoalText);
         this.nextGoalDetailText = new SimpleText(14,16777215,false,0,0);
         this.nextGoalDetailText.filters = [dropShadowFilter];
         this.nextGoalDetailText.visible = false;
         addChild(this.nextGoalDetailText);
         this.questCompletedStars = new StarsView();
         addChild(this.questCompletedStars);
      }
      
      public function setData(name:String, description:String, stars:int, highestLevel:int, highestFame:int) : void
      {
         this.classNameText.text = name;
         this.classDescriptionText.text = description;
         this.levelText.text = String(highestLevel);
         this.levelText.updateMetrics();
         this.questCompletedStars.setStars(stars);
         this.fameText.text = String(highestFame);
         this.fameText.updateMetrics();
         this.layout();
      }
      
      public function setNextGoal(name:String, nextGoal:int) : void
      {
         this.nextGoalText.visible = nextGoal != -1;
         this.nextGoalDetailText.visible = nextGoal != -1;
         if(nextGoal != -1)
         {
            this.nextGoalDetailText.text = "Earn " + String(nextGoal) + " Fame with a " + String(name);
            this.nextGoalDetailText.updateMetrics();
            this.nextGoalDetailText.y = this.nextGoalText.y + this.nextGoalText.height;
            this.nextGoalDetailText.x = WIDTH / 2 - this.nextGoalDetailText.width / 2;
         }
      }
      
      public function setWalkingAnimation(value:Animation) : void
      {
         this.animation && this.removeAnimation(this.animation);
         this.animation = value;
         this.animation && this.addAnimation(this.animation);
         this.layout();
      }
      
      private function removeAnimation(animation:Animation) : void
      {
         animation.stop();
         this.animContainer.removeChild(animation);
      }
      
      private function addAnimation(animation:Animation) : void
      {
         this.animContainer.addChild(animation);
         animation.start();
      }
      
      private function layout() : void
      {
         this.classNameText.x = WIDTH / 2 - this.classNameText.width / 2;
         this.classNameText.y = 110;
         this.classDescriptionText.y = this.classNameText.y + this.classNameText.textHeight + 5;
         this.classDescriptionText.x = WIDTH / 2 - this.classDescriptionText.width / 2;
         this.questCompletionText.y = this.classDescriptionText.y + this.classDescriptionText.textHeight + 20;
         this.questCompletionText.x = RIGHT_JUSTIFICATION_STATS - this.questCompletionText.width;
         this.questCompletedStars.y = this.questCompletionText.y;
         this.questCompletedStars.x = RIGHT_JUSTIFICATION_STATS + 18;
         this.levelTitleText.y = this.questCompletionText.y + this.questCompletionText.height + 5;
         this.levelTitleText.x = RIGHT_JUSTIFICATION_STATS - this.levelTitleText.width;
         this.levelText.y = this.levelTitleText.y;
         this.levelText.x = RIGHT_JUSTIFICATION_STATS + 18;
         this.fameTitleText.y = this.levelTitleText.y + this.levelTitleText.height + 5;
         this.fameTitleText.x = RIGHT_JUSTIFICATION_STATS - this.fameTitleText.width;
         this.fameText.y = this.fameTitleText.y;
         this.fameText.x = RIGHT_JUSTIFICATION_STATS + 18;
         this.fameIcon.y = this.fameTitleText.y - 7;
         this.fameIcon.x = this.fameText.x + this.fameText.textWidth - 3;
         this.nextGoalText.y = this.fameTitleText.y + this.fameTitleText.height + 17;
         this.nextGoalText.x = WIDTH / 2 - this.nextGoalText.width / 2;
         this.nextGoalDetailText.y = this.nextGoalText.y + this.nextGoalText.height;
         this.nextGoalDetailText.x = WIDTH / 2 - this.nextGoalDetailText.width / 2;
      }
   }
}
