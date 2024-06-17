// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//kabam.lib.math.easing.Quart

package kabam.lib.math.easing
{
    public class Quart 
    {


        public static function easeIn(_arg_1:Number):Number
        {
            return (((_arg_1 * _arg_1) * _arg_1) * _arg_1);
        }

        public static function easeOut(_arg_1:Number):Number
        {
            return (-((((--_arg_1 * _arg_1) * _arg_1) * _arg_1) - 1));
        }

        public static function easeInOut(_arg_1:Number):Number
        {
            if ((_arg_1 = (_arg_1 * 2)) < 1)
            {
                return ((((0.5 * _arg_1) * _arg_1) * _arg_1) * _arg_1);
            }
            return (-0.5 * (((((_arg_1 = (_arg_1 - 2)) * _arg_1) * _arg_1) * _arg_1) - 2));
        }


    }
}//package kabam.lib.math.easing

