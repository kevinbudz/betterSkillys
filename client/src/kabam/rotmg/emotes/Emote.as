package kabam.rotmg.emotes {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;

public class Emote extends Sprite {

    public function Emote(name:String, bitmap:BitmapData, scale:Number, hq:Boolean) {
        super();
        this.emoteName = name;
        this.bitmapData = bitmap;
        this.scale = scale;
        this.hq = hq;
        var matrix:Matrix = new Matrix();
        matrix.scale(scale, scale);
        var texture:BitmapData = new BitmapData(Math.floor(this.bitmapData.width * scale), Math.floor(this.bitmapData.height * scale), true, 0);
        texture.draw(this.bitmapData, matrix, null, null, null, hq);
        var shape:Shape = new Shape();
        shape.graphics.beginBitmapFill(this.bitmapData, matrix, false, true);
        shape.graphics.lineStyle(0, 0, 0);
        shape.graphics.drawRect(0, 0, texture.width, texture.height);
        shape.graphics.endFill();
        texture.draw(shape);
        this.emote = new Bitmap(texture);
        this.emote.y = -2;
        addChild(this.emote);
    }
    protected var emote:Bitmap;
    private var emoteName:String;
    private var bitmapData:BitmapData;
    private var scale:Number;
    private var hq:Boolean;

    public function clone():Emote {
        return new Emote(this.emoteName, this.bitmapData, this.scale, this.hq);
    }
}
}