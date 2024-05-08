package com.company.assembleegameclient.ui.tooltip
{
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.ui.GameObjectListItem;
import com.company.ui.SimpleText;
import flash.filters.DropShadowFilter;

public class QuestToolTip extends ToolTip
{

   private var text_:SimpleText;

   public var enemyGOLI_:GameObjectListItem;

   public function QuestToolTip(go:GameObject)
   {
      this.updateRedraw_ = true;

      super(6036765,1,16549442,1,false);

      this.text_ = new SimpleText(22,16549442,false,0,0);
      this.text_.setBold(true);
      this.text_.text = "Quest!";
      this.text_.updateMetrics();
      this.text_.filters = [new DropShadowFilter(0,0,0)];
      this.text_.x = 0;
      this.text_.y = 0;
      addChild(this.text_);

      this.enemyGOLI_ = new GameObjectListItem(11776947,true, go);
      this.enemyGOLI_.x = 0;
      this.enemyGOLI_.y = 32;
      this.enemyGOLI_.portrait_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
      addChild(this.enemyGOLI_);

      filters = [];
   }
}
}
