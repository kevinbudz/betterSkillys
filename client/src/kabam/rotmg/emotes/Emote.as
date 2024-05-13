package kabam.rotmg.emotes
{
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.GlowFilter;
import flash.geom.Matrix;


public class Emote extends Sprite
{
    private var emoteName:String;

    private var bitmapData:BitmapData;

    private var scale:Number;

    private var hq:Boolean;

    public function Emote(param1:String, param2:BitmapData, param3:Number, param4:Boolean)
    {
        super();
        this.emoteName = param1;
        this.bitmapData = param2;
        this.scale = param3;
        this.hq = param4;
        var _loc5_:BitmapData = param2;
        var _loc6_:Matrix = new Matrix();
        _loc6_.scale(param3,param3);
        var _loc7_:BitmapData = new BitmapData(Math.floor(_loc5_.width * param3),Math.floor(_loc5_.height * param3),true,0);
        _loc7_.draw(_loc5_,_loc6_,null,null,null,param4);
        var _loc8_:Shape = new Shape();
        _loc8_.graphics.beginBitmapFill(_loc5_,_loc6_,false,true);
        _loc8_.graphics.lineStyle(0,0,0);
        _loc8_.graphics.drawRect(0,0,_loc7_.width,_loc7_.height);
        _loc8_.graphics.endFill();
        _loc7_.draw(_loc8_);
        var _loc9_:Bitmap = new Bitmap(_loc7_);
        _loc9_.filters = !!param4?[]:[new GlowFilter(0,1,6,6,4)];
        _loc9_.y = -2;
        addChild(_loc9_);
    }

    public function clone() : Emote
    {
        return new Emote(this.emoteName,this.bitmapData,this.scale,this.hq);
    }
}
}