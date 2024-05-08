package com.company.assembleegameclient.objects.animation
{
   public class AnimationData
   {
       
      
      public var prob_:Number = 1.0;
      
      public var period_:int;
      
      public var periodJitter_:int;
      
      public var sync_:Boolean = false;
      
      public var frames:Vector.<FrameData>;
      
      public function AnimationData(xml:XML)
      {
         var frameXML:XML = null;
         this.frames = new Vector.<FrameData>();
         super();
         if("@prob" in xml)
         {
            this.prob_ = Number(xml.@prob);
         }
         this.period_ = int(Number(xml.@period) * 1000);
         this.periodJitter_ = int(Number(xml.@periodJitter) * 1000);
         this.sync_ = String(xml.@sync) == "true";
         for each(frameXML in xml.Frame)
         {
            this.frames.push(new FrameData(frameXML));
         }
      }
      
      private function getPeriod() : int
      {
         if(this.periodJitter_ == 0)
         {
            return this.period_;
         }
         return this.period_ - this.periodJitter_ + 2 * Math.random() * this.periodJitter_;
      }
      
      public function getLastRun(time:int) : int
      {
         if(this.sync_)
         {
            return int(time / this.period_) * this.period_;
         }
         return time + this.getPeriod() + 200 * Math.random();
      }
      
      public function getNextRun(time:int) : int
      {
         if(this.sync_)
         {
            return int(time / this.period_) * this.period_ + this.period_;
         }
         return time + this.getPeriod();
      }
   }
}
