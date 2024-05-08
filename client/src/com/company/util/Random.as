package com.company.util
{
   public class Random
   {
       
      
      public var seed:uint;
      
      public function Random(mySeed:uint = 1)
      {
         super();
         this.seed = mySeed;
      }
      
      public static function randomSeed() : uint
      {
         return Math.round(Math.random() * (uint.MAX_VALUE - 1) + 1);
      }
      
      public function nextInt() : uint
      {
         return this.gen();
      }
      
      public function nextDouble() : Number
      {
         return this.gen() / 2147483647;
      }
      
      public function nextNormal(mean:Number = 0.0, stdDev:Number = 1.0) : Number
      {
         var u1:Number = this.gen() / 2147483647;
         var u2:Number = this.gen() / 2147483647;
         var r:Number = Math.sqrt(-2 * Math.log(u1)) * Math.cos(2 * u2 * Math.PI);
         return mean + r * stdDev;
      }
      
      public function nextIntRange(min:uint, max:uint) : uint
      {
         return min == max?uint(min):uint(min + this.gen() % (max - min));
      }
      
      public function nextDoubleRange(min:Number, max:Number) : Number
      {
         return min + (max - min) * this.nextDouble();
      }
      
      private function gen() : uint
      {
         var hi:uint = 0;
         var lo:uint = 0;
         lo = 16807 * (this.seed & 65535);
         hi = 16807 * (this.seed >> 16);
         lo = lo + ((hi & 32767) << 16);
         lo = lo + (hi >> 15);
         if(lo > 2147483647)
         {
            lo = lo - 2147483647;
         }
         return this.seed = lo;
      }
   }
}
