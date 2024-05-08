package com.company.assembleegameclient.ui.tooltip
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.ui.LineBreakDesign;
   import com.company.assembleegameclient.util.FameUtil;
   import com.company.rotmg.graphics.StarGraphic;
   import com.company.ui.SimpleText;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   
   public class RankToolTip extends ToolTip
   {
       
      
      private var earnedText_:SimpleText;
      
      private var star_:StarGraphic;
      
      private var howToText_:SimpleText;
      
      private var lineBreak_:LineBreakDesign;
      
      private var legendLines_:Vector.<LegendLine>;
      
      public function RankToolTip(numStars:int)
      {
         var line:LegendLine = null;
         super(3552822,1,16777215,1);
         this.earnedText_ = new SimpleText(13,11776947,false,0,0);
         this.earnedText_.setBold(true);
         this.earnedText_.text = "You have earned " + numStars;
         this.earnedText_.updateMetrics();
         this.earnedText_.filters = [new DropShadowFilter(0,0,0)];
         this.earnedText_.x = 6;
         this.earnedText_.y = 2;
         addChild(this.earnedText_);
         this.star_ = new StarGraphic();
         this.star_.transform.colorTransform = new ColorTransform(179 / 255,179 / 255,179 / 255);
         this.star_.x = this.earnedText_.width + 7;
         this.star_.y = this.earnedText_.y + 4;
         addChild(this.star_);
         this.howToText_ = new SimpleText(13,11776947,false,174,0);
         this.howToText_.wordWrap = true;
         this.howToText_.multiline = true;
         this.howToText_.text = "You can earn more by completing Class Quests.";
         this.howToText_.updateMetrics();
         this.howToText_.filters = [new DropShadowFilter(0,0,0)];
         this.howToText_.x = 6;
         this.howToText_.y = 30;
         addChild(this.howToText_);
         this.lineBreak_ = new LineBreakDesign(100,0x151515);
         this.lineBreak_.x = 6;
         this.lineBreak_.y = height + 10;
         addChild(this.lineBreak_);
         var yOffset:int = this.lineBreak_.y + 4;
         for(var i:int = 0; i < FameUtil.COLORS.length; i++)
         {
            line = new LegendLine(i * ObjectLibrary.playerChars_.length,(i + 1) * ObjectLibrary.playerChars_.length - 1,FameUtil.COLORS[i]);
            line.x = 6;
            line.y = yOffset;
            addChild(line);
            yOffset = yOffset + line.height;
         }
         line = new LegendLine(FameUtil.maxStars(),FameUtil.maxStars(),new ColorTransform());
         line.x = 6;
         line.y = yOffset;
         addChild(line);
         height = height + 6;
      }
      
      override public function draw() : void
      {
         this.lineBreak_.setWidthColor(width - 10,1842204);
         super.draw();
      }
   }
}

import com.company.rotmg.graphics.StarGraphic;
import com.company.ui.SimpleText;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

class LegendLine extends Sprite
{
    
   
   private var coloredStar_:StarGraphic;
   
   private var rangeText_:SimpleText;
   
   private var star_:StarGraphic;
   
   function LegendLine(minStars:int, maxStars:int, ct:ColorTransform)
   {
      super();
      this.coloredStar_ = new StarGraphic();
      this.coloredStar_.transform.colorTransform = ct;
      this.coloredStar_.y = 4;
      addChild(this.coloredStar_);
      this.rangeText_ = new SimpleText(13,11776947,false,0,0);
      this.rangeText_.setBold(true);
      this.rangeText_.text = ": " + (minStars == maxStars?minStars.toString():minStars + " - " + maxStars);
      this.rangeText_.updateMetrics();
      this.rangeText_.filters = [new DropShadowFilter(0,0,0)];
      this.rangeText_.x = this.coloredStar_.width;
      addChild(this.rangeText_);
      this.star_ = new StarGraphic();
      this.star_.transform.colorTransform = new ColorTransform(179 / 255,179 / 255,179 / 255);
      this.star_.x = this.rangeText_.x + this.rangeText_.width + 2;
      this.star_.y = 4;
      addChild(this.star_);
   }
}
