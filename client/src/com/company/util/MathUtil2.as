package com.company.util {

public class MathUtil2 {

    public static function roundTo(num:Number, decimals:int):Number {
        var m:int = Math.pow(10, decimals);
        return Math.round(num * m) / m;
    }

    public static function angleCos(val:Number):Number {
        return Math.cos(val * Math.PI / 180);
    }

    public static function angleSin(val:Number):Number {
        return Math.sin(val * Math.PI / 180);
    }

    public static function getAngle(x:Number, y:Number, cx:Number, cy:Number):Number {
        return Math.atan2((y - cy), (x - cx)) * 180 / Math.PI;
    }

    public static function next(minNum:Number, maxNum:Number):Number {
        return Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum;
    }

    // https://snipplr.com/view/60387/as3-decimal-to-hex
    public static function decimalToHex(decimal:int, padding:int = 2):String {
        var hex:String = Number(decimal).toString(16);
        while (hex.length < padding)
            hex = "0" + hex;
        return hex.toUpperCase();
    }
}
}
