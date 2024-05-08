package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.ui.Scrollbar;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.util.BitmapUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class ScoringBox extends Sprite
   {
       
      
      private var rect_:Rectangle;
      
      private var mask_:Shape;
      
      private var linesSprite_:Sprite;
      
      private var scoreTextLines_:Vector.<ScoreTextLine>;
      
      private var scrollbar_:Scrollbar;
      
      private var startTime_:int;
      
      public function ScoringBox(rect:Rectangle, fameXML:XML)
      {
         var bonusXML:XML = null;
         this.mask_ = new Shape();
         this.linesSprite_ = new Sprite();
         this.scoreTextLines_ = new Vector.<ScoreTextLine>();
         super();
         this.rect_ = rect;
         graphics.lineStyle(1,4802889,2);
         graphics.drawRect(this.rect_.x + 1,this.rect_.y + 1,this.rect_.width - 2,this.rect_.height - 2);
         graphics.lineStyle();
         this.scrollbar_ = new Scrollbar(16,this.rect_.height);
         this.scrollbar_.addEventListener(Event.CHANGE,this.onScroll);
         this.mask_.graphics.beginFill(16777215,1);
         this.mask_.graphics.drawRect(this.rect_.x,this.rect_.y,this.rect_.width,this.rect_.height);
         this.mask_.graphics.endFill();
         addChild(this.mask_);
         mask = this.mask_;
         addChild(this.linesSprite_);
         this.addLine("Shots",null,fameXML.Shots,false,5746018);
         if(int(fameXML.Shots) != 0)
         {
            this.addLine("Accuracy",null,100 * Number(fameXML.ShotsThatDamage) / Number(fameXML.Shots),true,5746018,"","%");
         }
         this.addLine("Tiles Seen",null,fameXML.TilesUncovered,false,5746018);
         this.addLine("Monster Kills",null,fameXML.MonsterKills,false,5746018);
         this.addLine("God Kills",null,fameXML.GodKills,false,5746018);
         this.addLine("Oryx Kills",null,fameXML.OryxKills,false,5746018);
         this.addLine("Quests Completed",null,fameXML.QuestsCompleted,false,5746018);
         this.addLine("Dungeons Completed",null,int(fameXML.PirateCavesCompleted) + int(fameXML.UndeadLairsCompleted) + int(fameXML.AbyssOfDemonsCompleted) + int(fameXML.SnakePitsCompleted) + int(fameXML.SpiderDensCompleted) + int(fameXML.SpriteWorldsCompleted) + int(fameXML.TombsCompleted),false,5746018);
         this.addLine("Party Member Level Ups",null,fameXML.LevelUpAssists,false,5746018);
         var fameBD:BitmapData = FameUtil.getFameIcon();
         fameBD = BitmapUtil.cropToBitmapData(fameBD,6,6,fameBD.width - 12,fameBD.height - 12);
         this.addLine("Base Fame Earned",null,fameXML.BaseFame,true,16762880,"","",new Bitmap(fameBD));
         for each(bonusXML in fameXML.Bonus)
         {
            this.addLine("Bonus: " + bonusXML.@id,bonusXML.@desc,int(bonusXML),true,16762880,"+","",new Bitmap(fameBD));
         }
      }
      
      public function showScore() : void
      {
         var textLine:ScoreTextLine = null;
         this.animateScore();
         this.startTime_ = -int.MAX_VALUE;
         for each(textLine in this.scoreTextLines_)
         {
            textLine.skip();
         }
      }
      
      public function animateScore() : void
      {
         this.startTime_ = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onScroll(event:Event) : void
      {
         var v:Number = this.scrollbar_.pos();
         this.linesSprite_.y = v * (this.rect_.height - this.linesSprite_.height - 15) + 5;
      }
      
      private function addLine(name:String, desc:String, val:int, includeIfZero:Boolean, color:uint, numberPrefix:String = "", unit:String = "", unitIcon:DisplayObject = null) : void
      {
         if(val == 0 && !includeIfZero)
         {
            return;
         }
         this.scoreTextLines_.push(new ScoreTextLine(20,11776947,color,name,desc,val,numberPrefix,unit,unitIcon));
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var stl:ScoreTextLine = null;
         var endTime:Number = this.startTime_ + 2000 * (this.scoreTextLines_.length - 1) / 2;
         var time:Number = getTimer();
         var maxI:int = Math.min(this.scoreTextLines_.length,2 * (getTimer() - this.startTime_) / 2000 + 1);
         for(var i:int = 0; i < maxI; i++)
         {
            stl = this.scoreTextLines_[i];
            stl.y = 28 * i;
            this.linesSprite_.addChild(stl);
         }
         this.linesSprite_.y = this.rect_.height - this.linesSprite_.height - 10;
         if(time > endTime + 1000)
         {
            this.addScrollbar();
            dispatchEvent(new Event(Event.COMPLETE));
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function addScrollbar() : void
      {
         graphics.clear();
         graphics.lineStyle(1,4802889,2);
         graphics.drawRect(this.rect_.x + 1,this.rect_.y + 1,this.rect_.width - 26,this.rect_.height - 2);
         graphics.lineStyle();
         this.scrollbar_.x = this.rect_.width - 16;
         this.scrollbar_.setIndicatorSize(this.mask_.height,this.linesSprite_.height);
         this.scrollbar_.setPos(1);
         addChild(this.scrollbar_);
      }
   }
}
