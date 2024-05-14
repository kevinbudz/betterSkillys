package kabam.rotmg.emotes {
import com.company.ui.SimpleText;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;


public class EmoteGraphicHelper {

    private static function getAllWords(text:String):Array {
        return text.split(" ");
    }

    private static function makeNormalText(text:String, bold:Boolean, color:uint):TextField {
        var textField:TextField = new TextField();
        textField.autoSize = TextFieldAutoSize.LEFT;
        textField.embedFonts = true;
        var format:TextFormat = new TextFormat();
        format.font = SimpleText._Font.fontName;
        format.size = 14;
        format.bold = bold;
        format.color = color;
        textField.defaultTextFormat = format;
        textField.selectable = false;
        textField.mouseEnabled = false;
        textField.text = text;
        if (textField.textWidth > 150) {
            textField.multiline = true;
            textField.wordWrap = true;
            textField.width = 150;
        }
        return textField;
    }

    public function EmoteGraphicHelper() {
        super();
        this.buffer = new Vector.<DisplayObject>();
    }
    private var buffer:Vector.<DisplayObject>;

    public function getChatBubbleText(text:String, bold:Boolean, color:uint):Sprite {
        this.add(text, bold, color);
        return new Drawer(this.buffer, 150, 17);
    }

    private function add(text:String, bold:Boolean, color:uint):void {
        for each(var word:String in getAllWords(text)) {
            if (Emotes.hasEmote(word)) {
                this.buffer.push(Emotes.getEmote(word).clone());
            }
            else {
                this.buffer.push(makeNormalText(word, bold, color));
            }
        }
    }
}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Rectangle;

import kabam.rotmg.emotes.Emote;

class Drawer extends Sprite {

    function Drawer(buffer:Vector.<DisplayObject>, maxWidth:int, lineHeight:int) {
        super();
        this.maxWidth = maxWidth;
        this.lineHeight = lineHeight;
        this.list = buffer;
        this.count = buffer.length;
        this.position();
        for each (var obj:DisplayObject in this.list) {
            addChild(obj);
        }
    }
    private var maxWidth:int;
    private var list:Vector.<DisplayObject>;
    private var count:uint;
    private var lineHeight:uint;

    private function position():void {
        var p:int = 0;
        for (var i:int = 0; i < this.count; i++) {
            var image:DisplayObject = this.list[i];
            var rect:Rectangle = image.getRect(image);
            image.x = p;
            image.y = -rect.height;
            if (p + rect.width > this.maxWidth) {
                image.x = p = 0;
                for (var c:int = 0; c < i; c++)
                    this.list[c].y = this.list[c].y - this.lineHeight;
            }
            p = p + (image is Emote ? rect.width + 2 : rect.width);
        }
    }
}
