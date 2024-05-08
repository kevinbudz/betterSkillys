package kabam.rotmg.account.ui.components
{
   import com.company.ui.SimpleText;
   import flash.display.CapsStyle;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.TextEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import kabam.lib.util.DateValidator;
   
   public class DateField extends Sprite
   {
      
      private static const BACKGROUND_COLOR:uint = 3355443;
      
      private static const ERROR_BORDER_COLOR:uint = 16549442;
      
      private static const NORMAL_BORDER_COLOR:uint = 4539717;
      
      private static const TEXT_COLOR:uint = 11776947;
      
      private static const INPUT_RESTRICTION:String = "1234567890";
      
      private static const FORMAT_HINT_COLOR:uint = 5592405;
       
      
      public var label:SimpleText;
      
      public var days:SimpleText;
      
      public var months:SimpleText;
      
      public var years:SimpleText;
      
      private var dayFormatText:SimpleText;
      
      private var monthFormatText:SimpleText;
      
      private var yearFormatText:SimpleText;
      
      private var thisYear:int;
      
      private var validator:DateValidator;
      
      public function DateField()
      {
         super();
         this.validator = new DateValidator();
         this.thisYear = new Date().getFullYear();
         this.label = new SimpleText(18,11776947,false,0,0);
         this.label.setBold(true);
         this.label.text = name;
         this.label.updateMetrics();
         this.label.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.label);
         this.months = new SimpleText(20,TEXT_COLOR,true,35,30);
         this.months.restrict = INPUT_RESTRICTION;
         this.months.maxChars = 2;
         this.months.y = 30;
         this.months.x = 6;
         this.months.border = false;
         this.months.updateMetrics();
         this.months.addEventListener(TextEvent.TEXT_INPUT,this.onMonthInput);
         this.months.addEventListener(FocusEvent.FOCUS_OUT,this.onMonthFocusOut);
         this.months.addEventListener(Event.CHANGE,this.onEditMonth);
         this.monthFormatText = this.createFormatHint(this.months,"MM");
         addChild(this.monthFormatText);
         addChild(this.months);
         this.days = new SimpleText(20,TEXT_COLOR,true,35,30);
         this.days.restrict = INPUT_RESTRICTION;
         this.days.maxChars = 2;
         this.days.y = 30;
         this.days.x = 63;
         this.days.border = false;
         this.days.updateMetrics();
         this.days.addEventListener(TextEvent.TEXT_INPUT,this.onDayInput);
         this.days.addEventListener(FocusEvent.FOCUS_OUT,this.onDayFocusOut);
         this.days.addEventListener(Event.CHANGE,this.onEditDay);
         this.dayFormatText = this.createFormatHint(this.days,"DD");
         addChild(this.dayFormatText);
         addChild(this.days);
         this.years = new SimpleText(20,TEXT_COLOR,true,55,30);
         this.years.restrict = INPUT_RESTRICTION;
         this.years.maxChars = 4;
         this.years.y = 30;
         this.years.x = 118;
         this.years.border = false;
         this.years.updateMetrics();
         this.years.restrict = INPUT_RESTRICTION;
         this.years.addEventListener(TextEvent.TEXT_INPUT,this.onYearInput);
         this.years.addEventListener(Event.CHANGE,this.onEditYear);
         this.yearFormatText = this.createFormatHint(this.years,"YYYY");
         addChild(this.yearFormatText);
         addChild(this.years);
         this.setErrorHighlight(false);
      }
      
      public function setTitle(title:String) : void
      {
         this.label.text = title;
      }
      
      public function setErrorHighlight(hasError:Boolean) : void
      {
         this.drawSimpleTextBackground(this.months,0,0,hasError);
         this.drawSimpleTextBackground(this.days,0,0,hasError);
         this.drawSimpleTextBackground(this.years,0,0,hasError);
      }
      
      private function drawSimpleTextBackground(simpleText:SimpleText, hPadding:int, vPadding:int, hasError:Boolean) : void
      {
         var borderColor:uint = !!hasError?uint(ERROR_BORDER_COLOR):uint(NORMAL_BORDER_COLOR);
         graphics.lineStyle(2,borderColor,1,false,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         graphics.beginFill(BACKGROUND_COLOR,1);
         graphics.drawRect(simpleText.x - hPadding - 5,simpleText.y - vPadding,simpleText.width + hPadding * 2,simpleText.height + vPadding * 2);
         graphics.endFill();
         graphics.lineStyle();
      }
      
      private function createFormatHint(simpleText:SimpleText, hintText:String) : SimpleText
      {
         var formatHint:SimpleText = new SimpleText(16,FORMAT_HINT_COLOR,false,simpleText.width + 4,simpleText.height);
         formatHint.x = simpleText.x - 6;
         formatHint.y = simpleText.y + 3;
         formatHint.border = false;
         var format:TextFormat = formatHint.defaultTextFormat;
         format.align = TextFormatAlign.CENTER;
         formatHint.defaultTextFormat = format;
         formatHint.text = hintText;
         formatHint.updateMetrics();
         return formatHint;
      }
      
      private function onMonthInput(event:TextEvent) : void
      {
         var string:String = this.months.text + event.text;
         var value:int = int(string);
         if(string != "0" && !this.validator.isValidMonth(value))
         {
            event.preventDefault();
         }
      }
      
      private function onMonthFocusOut(event:FocusEvent) : void
      {
         var value:int = int(this.months.text);
         if(value < 10 && this.days.text != "")
         {
            this.months.text = "0" + value.toString();
         }
      }
      
      private function onEditMonth(e:Event) : void
      {
         this.monthFormatText.visible = !this.months.text;
      }
      
      private function onDayInput(event:TextEvent) : void
      {
         var string:String = this.days.text + event.text;
         var value:int = int(string);
         if(string != "0" && !this.validator.isValidDay(value))
         {
            event.preventDefault();
         }
      }
      
      private function onDayFocusOut(event:FocusEvent) : void
      {
         var value:int = int(this.days.text);
         if(value < 10 && this.days.text != "")
         {
            this.days.text = "0" + value.toString();
         }
      }
      
      private function onEditDay(e:Event) : void
      {
         this.dayFormatText.visible = !this.days.text;
      }
      
      private function onYearInput(event:TextEvent) : void
      {
         var string:String = this.years.text + event.text;
         var earliest:int = this.getEarliestYear(string);
         if(earliest > this.thisYear)
         {
            event.preventDefault();
         }
      }
      
      private function getEarliestYear(value:String) : int
      {
         while(value.length < 4)
         {
            value = value + "0";
         }
         return int(value);
      }
      
      private function onEditYear(e:Event) : void
      {
         this.yearFormatText.visible = !this.years.text;
      }
      
      public function isValidDate() : Boolean
      {
         var mm:int = int(this.months.text);
         var dd:int = int(this.days.text);
         var yyyy:int = int(this.years.text);
         return this.validator.isValidDate(mm,dd,yyyy,100);
      }
      
      public function getDate() : String
      {
         var mm:String = this.getFixedLengthString(this.months.text,2);
         var dd:String = this.getFixedLengthString(this.days.text,2);
         var yyyy:String = this.getFixedLengthString(this.years.text,4);
         return mm + "/" + dd + "/" + yyyy;
      }
      
      private function getFixedLengthString(value:String, length:int) : String
      {
         while(value.length < length)
         {
            value = "0" + value;
         }
         return value;
      }
   }
}
