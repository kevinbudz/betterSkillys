// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.util.ColorUtil

package com.company.assembleegameclient.util
{
    public class ColorUtil 
    {


        public static function rangeRandomSmart(_arg_1:uint, _arg_2:uint):Number
        {
            var _local_3:uint = ((_arg_1 >> 16) & 0xFF);
            var _local_4:uint = ((_arg_1 >> 8) & 0xFF);
            var _local_5:uint = (_arg_1 & 0xFF);
            var _local_6:uint = ((_arg_2 >> 16) & 0xFF);
            var _local_7:uint = ((_arg_2 >> 8) & 0xFF);
            var _local_8:uint = (_arg_2 & 0xFF);
            var _local_9:uint = (_local_6 + (Math.random() * (_local_3 - _local_6)));
            var _local_10:uint = (_local_7 + (Math.random() * (_local_4 - _local_7)));
            var _local_11:uint = (_local_8 + (Math.random() * (_local_5 - _local_8)));
            return (((_local_9 << 16) | (_local_10 << 8)) | _local_11);
        }

        public static function randomSmart(_arg_1:uint):Number
        {
            var _local_2:uint = ((_arg_1 >> 16) & 0xFF);
            var _local_3:uint = ((_arg_1 >> 8) & 0xFF);
            var _local_4:uint = (_arg_1 & 0xFF);
            var _local_5:uint = Math.max(0, Math.min(0xFF, (_local_2 + RandomUtil.plusMinus((_local_2 * 0.05)))));
            var _local_6:uint = Math.max(0, Math.min(0xFF, (_local_3 + RandomUtil.plusMinus((_local_3 * 0.05)))));
            var _local_7:uint = Math.max(0, Math.min(0xFF, (_local_4 + RandomUtil.plusMinus((_local_4 * 0.05)))));
            return (((_local_5 << 16) | (_local_6 << 8)) | _local_7);
        }

        public static function rangeRandomMix(_arg_1:uint, _arg_2:uint):Number
        {
            var _local_3:uint = ((_arg_1 >> 16) & 0xFF);
            var _local_4:uint = ((_arg_1 >> 8) & 0xFF);
            var _local_5:uint = (_arg_1 & 0xFF);
            var _local_6:uint = ((_arg_2 >> 16) & 0xFF);
            var _local_7:uint = ((_arg_2 >> 8) & 0xFF);
            var _local_8:uint = (_arg_2 & 0xFF);
            var _local_9:Number = Math.random();
            var _local_10:uint = (_local_6 + (_local_9 * (_local_3 - _local_6)));
            var _local_11:uint = (_local_7 + (_local_9 * (_local_4 - _local_7)));
            var _local_12:uint = (_local_8 + (_local_9 * (_local_5 - _local_8)));
            return (((_local_10 << 16) | (_local_11 << 8)) | _local_12);
        }

        public static function rangeRandom(_arg_1:uint, _arg_2:uint):Number
        {
            return (_arg_2 + (Math.random() * (_arg_1 - _arg_2)));
        }


    }
}//package com.company.assembleegameclient.util

