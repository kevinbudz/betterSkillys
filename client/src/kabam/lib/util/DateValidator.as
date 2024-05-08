package kabam.lib.util
{
   public class DateValidator
   {
      
      private static const DAYS_IN_MONTH:Vector.<int> = Vector.<int>([31,-1,31,30,31,30,31,31,30,31,30,31]);
      
      private static const FEBRUARY:int = 2;
       
      
      private var thisYear:int;
      
      public function DateValidator()
      {
         super();
         this.thisYear = new Date().getFullYear();
      }
      
      public function isValidMonth(value:int) : Boolean
      {
         return value > 0 && value <= 12;
      }
      
      public function isValidDay(value:int, givenMonth:int = -1, givenYear:int = -1) : Boolean
      {
         return value > 0 && value <= this.getDaysInMonth(givenMonth,givenYear);
      }
      
      public function getDaysInMonth(givenMonth:int = -1, givenYear:int = -1) : int
      {
         if(givenMonth == -1)
         {
            return 31;
         }
         return givenMonth == FEBRUARY?int(this.getDaysInFebruary(givenYear)):int(DAYS_IN_MONTH[givenMonth - 1]);
      }
      
      private function getDaysInFebruary(givenYear:int) : int
      {
         if(givenYear == -1 || this.isLeapYear(givenYear))
         {
            return 29;
         }
         return 28;
      }
      
      public function isLeapYear(givenYear:int) : Boolean
      {
         var isDivisibleBy4:Boolean = givenYear % 4 == 0;
         var isDivisibleBy100:Boolean = givenYear % 100 == 0;
         var isDivisibleBy400:Boolean = givenYear % 400 == 0;
         return isDivisibleBy4 && (!isDivisibleBy100 || isDivisibleBy400);
      }
      
      public function isValidDate(month:int, day:int, year:int, maxYearsAgo:int) : Boolean
      {
         return this.isValidYear(year,maxYearsAgo) && this.isValidMonth(month) && this.isValidDay(day,month,year);
      }
      
      public function isValidYear(year:int, maxYearsAgo:int) : Boolean
      {
         return year <= this.thisYear && year > this.thisYear - maxYearsAgo;
      }
   }
}
