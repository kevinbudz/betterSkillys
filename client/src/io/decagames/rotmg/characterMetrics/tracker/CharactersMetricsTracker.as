// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker

package io.decagames.rotmg.characterMetrics.tracker
{
    import flash.utils.Dictionary;
    import com.hurlant.util.Base64;
    import io.decagames.rotmg.characterMetrics.data.CharacterMetricsData;
    import flash.utils.IDataInput;

    public class CharactersMetricsTracker 
    {

        public static const STATS_SIZE:int = 5;

        private var charactersStats:Dictionary;
        private var _lastUpdate:Date;


        public function setBinaryStringData(_arg_1:int, _arg_2:String):void
        {
            var _local_3:RegExp = /-/g;
            var _local_4:RegExp = /_/g;
            var _local_5:int = (4 - (_arg_2.length % 4));
            while (_local_5--)
            {
                _arg_2 = (_arg_2 + "=");
            }
            _arg_2 = _arg_2.replace(_local_3, "+").replace(_local_4, "/");
            this.setBinaryData(_arg_1, Base64.decodeToByteArray(_arg_2));
        }

        public function setBinaryData(_arg_1:int, _arg_2:IDataInput):void
        {
            var _local_3:int;
            var _local_4:int;
            if (!this.charactersStats)
            {
                this.charactersStats = new Dictionary();
            }
            if (!this.charactersStats[_arg_1])
            {
                this.charactersStats[_arg_1] = new CharacterMetricsData();
            }
            while (_arg_2.bytesAvailable >= STATS_SIZE)
            {
                _local_3 = _arg_2.readByte();
                _local_4 = _arg_2.readInt();
                this.charactersStats[_arg_1].setStat(_local_3, _local_4);
            }
            this._lastUpdate = new Date();
        }

        public function get lastUpdate():Date
        {
            return (this._lastUpdate);
        }

        public function getCharacterStat(_arg_1:int, _arg_2:int):int
        {
            if (!this.charactersStats)
            {
                this.charactersStats = new Dictionary();
            }
            if (!this.charactersStats[_arg_1])
            {
                return (0);
            }
            return (this.charactersStats[_arg_1].getStat(_arg_2));
        }

        public function parseCharListData(_arg_1:XML):void
        {
            var _local_2:XML;
            for each (_local_2 in _arg_1.Char)
            {
                this.setBinaryStringData(int(_local_2.@id), _local_2.PCStats);
            }
        }


    }
}//package io.decagames.rotmg.characterMetrics.tracker

