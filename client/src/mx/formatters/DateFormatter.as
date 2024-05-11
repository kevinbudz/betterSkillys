// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//mx.formatters.DateFormatter

package mx.formatters
{
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class DateFormatter extends Formatter 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";
        private static const VALID_PATTERN_CHARS:String = "Y,M,D,A,E,H,J,K,L,N,S,Q";

        private var _formatString:String;
        private var formatStringOverride:String;


        public static function parseDateString(_arg_1:String):Date
        {
            var _local_14:String;
            var _local_15:int;
            var _local_16:int;
            var _local_17:String;
            var _local_18:String;
            var _local_19:int;
            if (((!(_arg_1)) || (_arg_1 == "")))
            {
                return (null);
            }
            var _local_2:int = -1;
            var _local_3:int = -1;
            var _local_4:int = -1;
            var _local_5:int = -1;
            var _local_6:int = -1;
            var _local_7:int = -1;
            var _local_8:* = "";
            var _local_9:Object = 0;
            var _local_10:int;
            var _local_11:int = _arg_1.length;
            var _local_12:RegExp = /(GMT|UTC)((\+|-)\d\d\d\d )?/ig;
            _arg_1 = _arg_1.replace(_local_12, "");
            while (_local_10 < _local_11)
            {
                _local_8 = _arg_1.charAt(_local_10);
                _local_10++;
                if (!((_local_8 <= " ") || (_local_8 == ",")))
                {
                    if (((((_local_8 == "/") || (_local_8 == ":")) || (_local_8 == "+")) || (_local_8 == "-")))
                    {
                        _local_9 = _local_8;
                    }
                    else
                    {
                        if (((("a" <= _local_8) && (_local_8 <= "z")) || (("A" <= _local_8) && (_local_8 <= "Z"))))
                        {
                            _local_14 = _local_8;
                            while (_local_10 < _local_11)
                            {
                                _local_8 = _arg_1.charAt(_local_10);
                                if (!((("a" <= _local_8) && (_local_8 <= "z")) || (("A" <= _local_8) && (_local_8 <= "Z")))) break;
                                _local_14 = (_local_14 + _local_8);
                                _local_10++;
                            }
                            _local_15 = DateBase.defaultStringKey.length;
                            _local_16 = 0;
                            while (_local_16 < _local_15)
                            {
                                _local_17 = String(DateBase.defaultStringKey[_local_16]);
                                if (((_local_17.toLowerCase() == _local_14.toLowerCase()) || (_local_17.toLowerCase().substr(0, 3) == _local_14.toLowerCase())))
                                {
                                    if (_local_16 == 13)
                                    {
                                        if (((_local_5 > 12) || (_local_5 < 1))) break;
                                        if (_local_5 < 12)
                                        {
                                            _local_5 = (_local_5 + 12);
                                        }
                                    }
                                    else
                                    {
                                        if (_local_16 == 12)
                                        {
                                            if (((_local_5 > 12) || (_local_5 < 1))) break;
                                            if (_local_5 == 12)
                                            {
                                                _local_5 = 0;
                                            }
                                        }
                                        else
                                        {
                                            if (_local_16 < 12)
                                            {
                                                if (_local_3 < 0)
                                                {
                                                    _local_3 = _local_16;
                                                }
                                                else
                                                {
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                    break;
                                }
                                _local_16++;
                            }
                            _local_9 = 0;
                        }
                        else
                        {
                            if ((("0" <= _local_8) && (_local_8 <= "9")))
                            {
                                _local_18 = _local_8;
                                while (((("0" <= (_local_8 = _arg_1.charAt(_local_10))) && (_local_8 <= "9")) && (_local_10 < _local_11)))
                                {
                                    _local_18 = (_local_18 + _local_8);
                                    _local_10++;
                                }
                                _local_19 = int(_local_18);
                                if (_local_19 >= 70)
                                {
                                    if (_local_2 != -1) break;
                                    if (((((((_local_8 <= " ") || (_local_8 == ",")) || (_local_8 == ".")) || (_local_8 == "/")) || (_local_8 == "-")) || (_local_10 >= _local_11)))
                                    {
                                        _local_2 = _local_19;
                                    }
                                    else
                                    {
                                        break;
                                    }
                                }
                                else
                                {
                                    if ((((_local_8 == "/") || (_local_8 == "-")) || (_local_8 == ".")))
                                    {
                                        if (_local_3 < 0)
                                        {
                                            _local_3 = (_local_19 - 1);
                                        }
                                        else
                                        {
                                            if (_local_4 < 0)
                                            {
                                                _local_4 = _local_19;
                                            }
                                            else
                                            {
                                                break;
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if (_local_8 == ":")
                                        {
                                            if (_local_5 < 0)
                                            {
                                                _local_5 = _local_19;
                                            }
                                            else
                                            {
                                                if (_local_6 < 0)
                                                {
                                                    _local_6 = _local_19;
                                                }
                                                else
                                                {
                                                    break;
                                                }
                                            }
                                        }
                                        else
                                        {
                                            if (((_local_5 >= 0) && (_local_6 < 0)))
                                            {
                                                _local_6 = _local_19;
                                            }
                                            else
                                            {
                                                if (((_local_6 >= 0) && (_local_7 < 0)))
                                                {
                                                    _local_7 = _local_19;
                                                }
                                                else
                                                {
                                                    if (_local_4 < 0)
                                                    {
                                                        _local_4 = _local_19;
                                                    }
                                                    else
                                                    {
                                                        if ((((_local_2 < 0) && (_local_3 >= 0)) && (_local_4 >= 0)))
                                                        {
                                                            _local_2 = (2000 + _local_19);
                                                        }
                                                        else
                                                        {
                                                            break;
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                _local_9 = 0;
                            }
                        }
                    }
                }
            }
            if ((((((_local_2 < 0) || (_local_3 < 0)) || (_local_3 > 11)) || (_local_4 < 1)) || (_local_4 > 31)))
            {
                return (null);
            }
            if (_local_7 < 0)
            {
                _local_7 = 0;
            }
            if (_local_6 < 0)
            {
                _local_6 = 0;
            }
            if (_local_5 < 0)
            {
                _local_5 = 0;
            }
            var _local_13:Date = new Date(_local_2, _local_3, _local_4, _local_5, _local_6, _local_7);
            if (((!(_local_4 == _local_13.getDate())) || (!(_local_3 == _local_13.getMonth()))))
            {
                return (null);
            }
            return (_local_13);
        }


        public function get formatString():String
        {
            return (this._formatString);
        }

        public function set formatString(_arg_1:String):void
        {
            this.formatStringOverride = _arg_1;
            this._formatString = ((_arg_1 != null) ? _arg_1 : resourceManager.getString("SharedResources", "dateFormat"));
        }

        override protected function resourcesChanged():void
        {
            super.resourcesChanged();
            this.formatString = this.formatStringOverride;
        }

        override public function format(_arg_1:Object):String
        {
            var _local_2:String;
            if (error)
            {
                error = null;
            }
            if (((!(_arg_1)) || ((_arg_1 is String) && (_arg_1 == ""))))
            {
                error = defaultInvalidValueError;
                return ("");
            }
            if ((_arg_1 is String))
            {
                _arg_1 = DateFormatter.parseDateString(String(_arg_1));
                if (!_arg_1)
                {
                    error = defaultInvalidValueError;
                    return ("");
                }
            }
            else
            {
                if (!(_arg_1 is Date))
                {
                    error = defaultInvalidValueError;
                    return ("");
                }
            }
            var _local_3:int;
            var _local_4:* = "";
            var _local_5:int = this.formatString.length;
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_2 = this.formatString.charAt(_local_6);
                if (((!(VALID_PATTERN_CHARS.indexOf(_local_2) == -1)) && (!(_local_2 == ","))))
                {
                    _local_3++;
                    if (_local_4.indexOf(_local_2) == -1)
                    {
                        _local_4 = (_local_4 + _local_2);
                    }
                    else
                    {
                        if (_local_2 != this.formatString.charAt(Math.max((_local_6 - 1), 0)))
                        {
                            error = defaultInvalidFormatError;
                            return ("");
                        }
                    }
                }
                _local_6++;
            }
            if (_local_3 < 1)
            {
                error = defaultInvalidFormatError;
                return ("");
            }
            var _local_7:StringFormatter = new StringFormatter(this.formatString, VALID_PATTERN_CHARS, DateBase.extractTokenDate);
            return (_local_7.formatValue(_arg_1));
        }


    }
}//package mx.formatters

