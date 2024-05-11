// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//io.decagames.rotmg.fame.data.TotalFame

package io.decagames.rotmg.fame.data
{
    
    import io.decagames.rotmg.fame.data.bonus.FameBonus;
    import flash.utils.Dictionary;
    

    public class TotalFame 
    {

        private var _bonuses:Vector.<FameBonus> = new Vector.<FameBonus>();
        private var _baseFame:Number;
        private var _currentFame:Number;

        public function TotalFame(_arg_1:Number)
        {
            this._baseFame = _arg_1;
            this._currentFame = _arg_1;
        }

        public function addBonus(_arg_1:FameBonus):void
        {
            if (_arg_1 != null)
            {
                this._bonuses.push(_arg_1);
                this._currentFame = (this._currentFame + _arg_1.fameAdded);
            }
        }

        public function get bonuses():Dictionary
        {
            var _local_2:FameBonus;
            var _local_1:Dictionary = new Dictionary();
            for each (_local_2 in this._bonuses)
            {
                _local_1[_local_2.id] = _local_2;
            }
            return (_local_1);
        }

        public function get baseFame():int
        {
            return (this._baseFame);
        }

        public function get currentFame():int
        {
            return (this._currentFame);
        }


    }
}//package io.decagames.rotmg.fame.data

