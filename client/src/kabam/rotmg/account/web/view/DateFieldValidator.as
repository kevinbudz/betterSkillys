package kabam.rotmg.account.web.view
{
   import kabam.rotmg.account.ui.components.DateField;
   
   public class DateFieldValidator
   {
       
      
      public function DateFieldValidator()
      {
         super();
      }
      
      public static function getPlayerAge(dateField:DateField) : uint
      {
         var dob:Date = new Date(getBirthDate(dateField));
         var now:Date = new Date();
         var age:uint = Number(now.fullYear) - Number(dob.fullYear);
         if(dob.month > now.month || dob.month == now.month && dob.date > now.date)
         {
            age--;
         }
         return age;
      }
      
      public static function getBirthDate(dateField:DateField) : uint
      {
         var birthDateString:String = dateField.months.text + "/" + dateField.days.text + "/" + dateField.years.text;
         return Date.parse(birthDateString);
      }
   }
}
