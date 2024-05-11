// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//mx.formatters.StringFormatter

package mx.formatters
{
    import mx.core.mx_internal;

    use namespace mx_internal;

    public class StringFormatter 
    {

        mx_internal static const VERSION:String = "4.6.0.23201";

        private var extractToken:Function;
        private var reqFormat:String;
        private var patternInfo:Array;

        public function StringFormatter(_arg_1:String, _arg_2:String, _arg_3:Function)
        {
            this.formatPattern(_arg_1, _arg_2);
            this.extractToken = _arg_3;
        }

        public function formatValue(_arg_1:Object):String
        {
            var _local_2:Object = this.patternInfo[0];
            var _local_3:String = (this.reqFormat.substring(0, _local_2.begin) + this.extractToken(_arg_1, _local_2));
            var _local_4:Object = _local_2;
            var _local_5:int = this.patternInfo.length;
            var _local_6:int = 1;
            while (_local_6 < _local_5)
            {
                _local_2 = this.patternInfo[_local_6];
                _local_3 = (_local_3 + (this.reqFormat.substring(_local_4.end, _local_2.begin) + this.extractToken(_arg_1, _local_2)));
                _local_4 = _local_2;
                _local_6++;
            }
            if (((_local_4.end > 0) && (!(_local_4.end == this.reqFormat.length))))
            {
                _local_3 = (_local_3 + this.reqFormat.substring(_local_4.end));
            }
            return (_local_3);
        }

        private function formatPattern(_arg_1:String, _arg_2:String):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:Array = _arg_2.split(",");
            this.reqFormat = _arg_1;
            this.patternInfo = [];
            var _local_7:int = _local_6.length;
            var _local_8:int;
            while (_local_8 < _local_7)
            {
                _local_3 = this.reqFormat.indexOf(_local_6[_local_8]);
                if (((_local_3 >= 0) && (_local_3 < this.reqFormat.length)))
                {
                    _local_4 = this.reqFormat.lastIndexOf(_local_6[_local_8]);
                    _local_4 = ((_local_4 >= 0) ? (_local_4 + 1) : (_local_3 + 1));
                    this.patternInfo.splice(_local_5, 0, {
                        "token":_local_6[_local_8],
                        "begin":_local_3,
                        "end":_local_4
                    });
                    _local_5++;
                }
                _local_8++;
            }
            this.patternInfo.sort(this.compareValues);
        }

        private function compareValues(_arg_1:Object, _arg_2:Object):int
        {
            if (_arg_1.begin > _arg_2.begin)
            {
                return (1);
            }
            if (_arg_1.begin < _arg_2.begin)
            {
                return (-1);
            }
            return (0);
        }


    }
}//package mx.formatters

