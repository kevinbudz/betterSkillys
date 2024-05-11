// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//mx.formatters.DateBase

package mx.formatters
{
    import mx.core.mx_internal;
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    import flash.events.Event;

    use namespace mx_internal;

    public class DateBase 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        private static var initialized:Boolean = false;
        private static var _resourceManager:IResourceManager;
        private static var _dayNamesLong:Array;
        private static var dayNamesLongOverride:Array;
        private static var _dayNamesShort:Array;
        private static var dayNamesShortOverride:Array;
        private static var _monthNamesLong:Array;
        private static var monthNamesLongOverride:Array;
        private static var _monthNamesShort:Array;
        private static var monthNamesShortOverride:Array;
        private static var _timeOfDay:Array;
        private static var timeOfDayOverride:Array;


        private static function get resourceManager():IResourceManager
        {
            if (!_resourceManager)
            {
                _resourceManager = ResourceManager.getInstance();
            }
            return (_resourceManager);
        }

        public static function get dayNamesLong():Array
        {
            initialize();
            return (_dayNamesLong);
        }

        public static function set dayNamesLong(_arg_1:Array):void
        {
            dayNamesLongOverride = _arg_1;
            _dayNamesLong = ((_arg_1 != null) ? _arg_1 : resourceManager.getStringArray("SharedResources", "dayNames"));
        }

        public static function get dayNamesShort():Array
        {
            initialize();
            return (_dayNamesShort);
        }

        public static function set dayNamesShort(_arg_1:Array):void
        {
            dayNamesShortOverride = _arg_1;
            _dayNamesShort = ((_arg_1 != null) ? _arg_1 : resourceManager.getStringArray("formatters", "dayNamesShort"));
        }

        mx_internal static function get defaultStringKey():Array
        {
            initialize();
            return (monthNamesLong.concat(timeOfDay));
        }

        public static function get monthNamesLong():Array
        {
            initialize();
            return (_monthNamesLong);
        }

        public static function set monthNamesLong(_arg_1:Array):void
        {
            var _local_2:String;
            var _local_3:int;
            var _local_4:int;
            monthNamesLongOverride = _arg_1;
            _monthNamesLong = ((_arg_1 != null) ? _arg_1 : resourceManager.getStringArray("SharedResources", "monthNames"));
            if (_arg_1 == null)
            {
                _local_2 = resourceManager.getString("SharedResources", "monthSymbol");
                if (_local_2 != " ")
                {
                    _local_3 = ((_monthNamesLong) ? _monthNamesLong.length : 0);
                    _local_4 = 0;
                    while (_local_4 < _local_3)
                    {
                        _monthNamesLong[_local_4] = (_monthNamesLong[_local_4] + _local_2);
                        _local_4++;
                    }
                }
            }
        }

        public static function get monthNamesShort():Array
        {
            initialize();
            return (_monthNamesShort);
        }

        public static function set monthNamesShort(_arg_1:Array):void
        {
            var _local_2:String;
            var _local_3:int;
            var _local_4:int;
            monthNamesShortOverride = _arg_1;
            _monthNamesShort = ((_arg_1 != null) ? _arg_1 : resourceManager.getStringArray("formatters", "monthNamesShort"));
            if (_arg_1 == null)
            {
                _local_2 = resourceManager.getString("SharedResources", "monthSymbol");
                if (_local_2 != " ")
                {
                    _local_3 = ((_monthNamesShort) ? _monthNamesShort.length : 0);
                    _local_4 = 0;
                    while (_local_4 < _local_3)
                    {
                        _monthNamesShort[_local_4] = (_monthNamesShort[_local_4] + _local_2);
                        _local_4++;
                    }
                }
            }
        }

        public static function get timeOfDay():Array
        {
            initialize();
            return (_timeOfDay);
        }

        public static function set timeOfDay(_arg_1:Array):void
        {
            timeOfDayOverride = _arg_1;
            var _local_2:String = resourceManager.getString("formatters", "am");
            var _local_3:String = resourceManager.getString("formatters", "pm");
            _timeOfDay = ((_arg_1 != null) ? _arg_1 : [_local_2, _local_3]);
        }

        private static function initialize():void
        {
            if (!initialized)
            {
                resourceManager.addEventListener(Event.CHANGE, static_resourceManager_changeHandler, false, 0, true);
                static_resourcesChanged();
                initialized = true;
            }
        }

        private static function static_resourcesChanged():void
        {
            dayNamesLong = dayNamesLongOverride;
            dayNamesShort = dayNamesShortOverride;
            monthNamesLong = monthNamesLongOverride;
            monthNamesShort = monthNamesShortOverride;
            timeOfDay = timeOfDayOverride;
        }

        mx_internal static function extractTokenDate(_arg_1:Date, _arg_2:Object):String
        {
            var _local_5:int;
            var _local_6:int;
            var _local_7:String;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            initialize();
            var _local_3:* = "";
            var _local_4:int = (int(_arg_2.end) - int(_arg_2.begin));
            switch (_arg_2.token)
            {
                case "Y":
                    _local_7 = _arg_1.getFullYear().toString();
                    if (_local_4 < 3)
                    {
                        return (_local_7.substr(2));
                    }
                    if (_local_4 > 4)
                    {
                        return (setValue(Number(_local_7), _local_4));
                    }
                    return (_local_7);
                case "M":
                    _local_8 = int(_arg_1.getMonth());
                    if (_local_4 < 3)
                    {
                        return (_local_3 + setValue(++_local_8, _local_4));
                    }
                    if (_local_4 == 3)
                    {
                        return (monthNamesShort[_local_8]);
                    }
                    return (monthNamesLong[_local_8]);
                case "D":
                    _local_5 = int(_arg_1.getDate());
                    return (_local_3 + setValue(_local_5, _local_4));
                case "E":
                    _local_5 = int(_arg_1.getDay());
                    if (_local_4 < 3)
                    {
                        return (_local_3 + setValue(_local_5, _local_4));
                    }
                    if (_local_4 == 3)
                    {
                        return (dayNamesShort[_local_5]);
                    }
                    return (dayNamesLong[_local_5]);
                case "A":
                    _local_6 = int(_arg_1.getHours());
                    if (_local_6 < 12)
                    {
                        return (timeOfDay[0]);
                    }
                    return (timeOfDay[1]);
                case "H":
                    _local_6 = int(_arg_1.getHours());
                    if (_local_6 == 0)
                    {
                        _local_6 = 24;
                    }
                    return (_local_3 + setValue(_local_6, _local_4));
                case "J":
                    _local_6 = int(_arg_1.getHours());
                    return (_local_3 + setValue(_local_6, _local_4));
                case "K":
                    _local_6 = int(_arg_1.getHours());
                    if (_local_6 >= 12)
                    {
                        _local_6 = (_local_6 - 12);
                    }
                    return (_local_3 + setValue(_local_6, _local_4));
                case "L":
                    _local_6 = int(_arg_1.getHours());
                    if (_local_6 == 0)
                    {
                        _local_6 = 12;
                    }
                    else
                    {
                        if (_local_6 > 12)
                        {
                            _local_6 = (_local_6 - 12);
                        }
                    }
                    return (_local_3 + setValue(_local_6, _local_4));
                case "N":
                    _local_9 = int(_arg_1.getMinutes());
                    return (_local_3 + setValue(_local_9, _local_4));
                case "S":
                    _local_10 = int(_arg_1.getSeconds());
                    return (_local_3 + setValue(_local_10, _local_4));
                case "Q":
                    _local_11 = int(_arg_1.getMilliseconds());
                    return (_local_3 + setValue(_local_11, _local_4));
            }
            return (_local_3);
        }

        private static function setValue(_arg_1:Object, _arg_2:int):String
        {
            var _local_5:int;
            var _local_6:int;
            var _local_3:* = "";
            var _local_4:int = _arg_1.toString().length;
            if (_local_4 < _arg_2)
            {
                _local_5 = (_arg_2 - _local_4);
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    _local_3 = (_local_3 + "0");
                    _local_6++;
                }
            }
            return (_local_3 + _arg_1.toString());
        }

        private static function static_resourceManager_changeHandler(_arg_1:Event):void
        {
            static_resourcesChanged();
        }


    }
}//package mx.formatters

