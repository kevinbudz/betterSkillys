package com.company.assembleegameclient.objects.animation
{
   import flash.display.BitmapData;
   
   public class Animations
   {
       
      
      public var animationsData_:AnimationsData;
      
      public var nextRun_:Vector.<int> = null;
      
      public var running_:RunningAnimation = null;
      
      public function Animations(animationsData:AnimationsData)
      {
         super();
         this.animationsData_ = animationsData;
      }
      
      public function getTexture(time:int) : BitmapData
      {
         var animationData:AnimationData = null;
         var texture:BitmapData = null;
         var start:int = 0;
         if(this.nextRun_ == null)
         {
            this.nextRun_ = new Vector.<int>();
            for each(animationData in this.animationsData_.animations)
            {
               this.nextRun_.push(animationData.getLastRun(time));
            }
         }
         if(this.running_ != null)
         {
            texture = this.running_.getTexture(time);
            if(texture != null)
            {
               return texture;
            }
            this.running_ = null;
         }
         for(var i:int = 0; i < this.nextRun_.length; i++)
         {
            if(time > this.nextRun_[i])
            {
               start = this.nextRun_[i];
               animationData = this.animationsData_.animations[i];
               this.nextRun_[i] = animationData.getNextRun(time);
               if(!(animationData.prob_ != 1 && Math.random() > animationData.prob_))
               {
                  this.running_ = new RunningAnimation(animationData,start);
                  return this.running_.getTexture(time);
               }
            }
         }
         return null;
      }
   }
}

import com.company.assembleegameclient.objects.animation.AnimationData;
import com.company.assembleegameclient.objects.animation.FrameData;
import flash.display.BitmapData;

class RunningAnimation
{
    
   
   public var animationData_:AnimationData;
   
   public var start_:int;
   
   public var frameId_:int;
   
   public var frameStart_:int;
   
   public var texture_:BitmapData;
   
   function RunningAnimation(animationData:AnimationData, start:int)
   {
      super();
      this.animationData_ = animationData;
      this.start_ = start;
      this.frameId_ = 0;
      this.frameStart_ = start;
      this.texture_ = null;
   }
   
   public function getTexture(time:int) : BitmapData
   {
      var frame:FrameData = this.animationData_.frames[this.frameId_];
      while(time - this.frameStart_ > frame.time_)
      {
         if(this.frameId_ >= this.animationData_.frames.length - 1)
         {
            return null;
         }
         this.frameStart_ = this.frameStart_ + frame.time_;
         this.frameId_++;
         frame = this.animationData_.frames[this.frameId_];
         this.texture_ = null;
      }
      if(this.texture_ == null)
      {
         this.texture_ = frame.textureData_.getTexture(Math.random() * 100);
      }
      return this.texture_;
   }
}
