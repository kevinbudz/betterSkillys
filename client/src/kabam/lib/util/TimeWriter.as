package kabam.lib.util
{
   public class TimeWriter
   {
       
      
      private var timeStringStarted:Boolean = false;
      
      private var seconds:int;
      
      private var minutes:int;
      
      private var hours:int;
      
      private var days:int;
      
      private var textValues:Array;
      
      public function TimeWriter()
      {
         super();
      }
      
      public function parseTime(time:Number) : String
      {
         this.seconds = Math.floor(time / 1000);
         this.minutes = Math.floor(this.seconds / 60);
         this.hours = Math.floor(this.minutes / 60);
         this.days = Math.floor(this.hours / 24);
         this.seconds = this.seconds % 60;
         this.minutes = this.minutes % 60;
         this.hours = this.hours % 24;
         this.timeStringStarted = false;
         this.textValues = [];
         this.formatUnit(this.days,"d");
         this.formatUnit(this.hours,"h");
         this.formatUnit(this.minutes,"m",2);
         this.formatUnit(this.seconds,"s",2);
         this.timeStringStarted = false;
         return this.textValues.join(" ");
      }
      
      private function formatUnit(value:int, measurement:String, stringLength:int = -1) : void
      {
         if(value == 0 && !this.timeStringStarted)
         {
            return;
         }
         this.timeStringStarted = true;
         var string:String = value.toString();
         if(stringLength == -1)
         {
            stringLength = string.length;
         }
         var prefix:String = "";
         for(var i:int = string.length; i < stringLength; i++)
         {
            prefix = prefix + "0";
         }
         string = prefix + string + measurement;
         this.textValues.push(string);
      }
   }
}
