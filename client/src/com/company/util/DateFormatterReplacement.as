package com.company.util {
public class DateFormatterReplacement {

    private const months:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

    public var formatString:String;


    public function format(date:Date):String {
        var ret:String = this.formatString;
        ret = ret.replace("D", date.date);
        ret = ret.replace("YYYY", date.fullYear);
        return (ret.replace("MMMM", this.months[date.month]));
    }


}
}//package com.company.util
