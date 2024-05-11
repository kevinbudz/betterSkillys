// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//io.decagames.rotmg.fame.data.bonus.FameBonus

package io.decagames.rotmg.fame.data.bonus
{
    public class FameBonus 
    {

        private var _added:int;
        private var _numAdded:int;
        private var _level:int;
        private var _fameAdded:int;
        private var _id:int;
        private var _name:String;
        private var _tooltip:String;

        public function FameBonus(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:String, _arg_6:String)
        {
            this._added = _arg_2;
            this._numAdded = _arg_3;
            this._level = _arg_4;
            this._id = _arg_1;
            this._name = _arg_5;
            this._tooltip = _arg_6;
        }

        public function get added():int
        {
            return (this._added);
        }

        public function get numAdded():int
        {
            return (this._numAdded);
        }

        public function get level():int
        {
            return (this._level);
        }

        public function get fameAdded():int
        {
            return (this._fameAdded);
        }

        public function set fameAdded(_arg_1:int):void
        {
            this._fameAdded = _arg_1;
        }

        public function get id():int
        {
            return (this._id);
        }

        public function get name():String
        {
            return (this._name);
        }

        public function get tooltip():String
        {
            return (this._tooltip);
        }


    }
}//package io.decagames.rotmg.fame.data.bonus

