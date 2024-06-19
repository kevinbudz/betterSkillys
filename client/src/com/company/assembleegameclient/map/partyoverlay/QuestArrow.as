package com.company.assembleegameclient.map.partyoverlay
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.map.Quest;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.ui.tooltip.PortraitToolTip;
   import com.company.assembleegameclient.ui.tooltip.QuestToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class QuestArrow extends GameObjectArrow
   {

      public function QuestArrow(map:Map)
      {
         super(16352321,12919330,true);
         this.map_ = map;
      }
      
      public function refreshToolTip() : void
      {
         setToolTip(this.getToolTip(go_,getTimer()));
      }
      
      override protected function onMouseOver(event:MouseEvent) : void
      {
         super.onMouseOver(event);
         this.refreshToolTip();
      }
      
      override protected function onMouseOut(event:MouseEvent) : void
      {
         super.onMouseOut(event);
         this.refreshToolTip();
      }
      
      private function getToolTip(go:GameObject, time:int) : ToolTip
      {
         if(go == null || go.texture_ == null)
         {
            return null;
         }
         if(this.shouldShowFullQuest(time))
         {
            return new QuestToolTip(go_);
         }
         if(Parameters.data_.showQuestPortraits)
         {
            return new PortraitToolTip(go);
         }
         return null;
      }
      
      private function shouldShowFullQuest(time:int) : Boolean
      {
         var quest:Quest = this.map_.quest_;
         return mouseOver_ || quest.isNew(time);
      }
      
      override public function draw(time:int, camera:Camera) : void
      {
         var isFull:Boolean = false;
         var shouldBeFull:Boolean = false;
         var questObj:GameObject = this.map_.quest_.getObject(time);
         if(questObj != go_)
         {
            if (this.map_.gs_.bossHealthBar != null)
               this.map_.gs_.bossHealthBar.setGameObject(questObj);
            setGameObject(questObj);
            setToolTip(this.getToolTip(questObj,time));
         }
         else if(go_ != null)
         {
            isFull = tooltip_ is QuestToolTip;
            shouldBeFull = this.shouldShowFullQuest(time);
            if(isFull != shouldBeFull)
            {
               setToolTip(this.getToolTip(questObj,time));
            }
         }
         super.draw(time,camera);
      }
   }
}
