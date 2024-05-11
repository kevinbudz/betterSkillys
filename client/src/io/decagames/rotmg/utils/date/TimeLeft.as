// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//io.decagames.rotmg.utils.date.TimeLeft

package io.decagames.rotmg.utils.date
{
    import com.company.assembleegameclient.util.TimeUtil;

    public class TimeLeft 
    {


        public static function parse(_arg_1:int, _arg_2:String):String
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            if (_arg_2.indexOf("%d") >= 0)
            {
                _local_3 = int(Math.floor((_arg_1 / 86400)));
                _arg_1 = (_arg_1 - (_local_3 * 86400));
                _arg_2 = _arg_2.replace("%d", _local_3);
            }
            if (_arg_2.indexOf("%h") >= 0)
            {
                _local_4 = int(Math.floor((_arg_1 / 3600)));
                _arg_1 = (_arg_1 - (_local_4 * 3600));
                _arg_2 = _arg_2.replace("%h", _local_4);
            }
            if (_arg_2.indexOf("%m") >= 0)
            {
                _local_5 = int(Math.floor((_arg_1 / 60)));
                _arg_1 = (_arg_1 - (_local_5 * 60));
                _arg_2 = _arg_2.replace("%m", _local_5);
            }
            return (_arg_2.replace("%s", _arg_1));
        }

        public static function getStartTimeString(_arg_1:Date):String
        {
            var _local_2:* = "";
            var _local_3:Date = new Date();
            var _local_4:Number = ((_arg_1.time - _local_3.time) / 1000);
            if (_local_4 <= 0)
            {
                return ("");
            }
            if (_local_4 > TimeUtil.DAY_IN_S)
            {
                _local_2 = (_local_2 + TimeLeft.parse(_local_4, "%dd %hh"));
            }
            else
            {
                if (_local_4 > TimeUtil.HOUR_IN_S)
                {
                    _local_2 = (_local_2 + TimeLeft.parse(_local_4, "%hh %mm"));
                }
                else
                {
                    if (_local_4 > TimeUtil.MIN_IN_S)
                    {
                        _local_2 = (_local_2 + TimeLeft.parse(_local_4, "%mm %ss"));
                    }
                    else
                    {
                        _local_2 = (_local_2 + TimeLeft.parse(_local_4, "%ss"));
                    }
                }
            }
            return (_local_2);
        }


    }
}//package io.decagames.rotmg.utils.date

