// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.util.MathUtil

package com.company.assembleegameclient.util
{
    public class MathUtil 
    {

        public static const TO_DEG:Number = (180 / Math.PI);//57.2957795130823
        public static const TO_RAD:Number = (Math.PI / 180);//0.0174532925199433


        public static function round(_arg_1:Number, _arg_2:int=0):Number
        {
            var _local_3:int = Math.pow(10, _arg_2);
            return (Math.round((_arg_1 * _local_3)) / _local_3);
        }


    }
}//package com.company.assembleegameclient.util

