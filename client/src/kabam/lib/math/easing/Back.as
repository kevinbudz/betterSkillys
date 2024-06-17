// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//kabam.lib.math.easing.Back

package kabam.lib.math.easing
{
    public class Back 
    {


        public static function easeIn(_arg_1:Number):Number
        {
            return ((_arg_1 * _arg_1) * ((2.70158 * _arg_1) - 1.70158));
        }

        public static function easeOut(_arg_1:Number):Number
        {
            return (((--_arg_1 * _arg_1) * ((2.70158 * _arg_1) + 1.70158)) + 1);
        }

        public static function easeInOut(_arg_1:Number):Number
        {
            if ((_arg_1 = (_arg_1 * 2)) < 1)
            {
                return (((0.5 * _arg_1) * _arg_1) * ((3.5949095 * _arg_1) - 2.5949095));
            }
            return (0.5 * ((((_arg_1 = (_arg_1 - 2)) * _arg_1) * ((3.5949095 * _arg_1) + 2.5949095)) + 2));
        }


    }
}//package kabam.lib.math.easing

