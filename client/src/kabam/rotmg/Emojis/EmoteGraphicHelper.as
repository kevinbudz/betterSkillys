package kabam.rotmg.Emojis{
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import kabam.rotmg.text.view.stringBuilder.StaticStringBuilder;
import kabam.rotmg.text.view.stringBuilder.StringBuilder;


public class EmoteGraphicHelper
{

    private static const tField:TextField = _J_R_();


    private var buffer:Vector.<DisplayObject>;

    public function EmoteGraphicHelper()
    {
        super();
        this.buffer = new Vector.<DisplayObject>();
    }

    private static function _J_R_() : TextField
    {
        var _loc1_:TextField = new TextField();
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.size = 14;
        _loc2_.bold = false;
        _loc1_.defaultTextFormat = _loc2_;
        return _loc1_;
    }

    public function getChatBubbleText(param1:String, param2:Boolean, param3:uint) : Sprite
    {
        this.add(param1,param2,param3);
        return new Drawer(this.buffer,150,17);
    }

    private function getAllWords(param1:String) : Array
    {
        return param1.split(" ");
    }

    private function add(param1:String, param2:Boolean, param3:uint) : void
    {
        var _loc4_:StringBuilder = null;
        var _loc5_:String = null;
        for each(_loc5_ in this.getAllWords(param1))
        {
            if(Emotes.hasEmote(_loc5_))
            {
                this.buffer.push(Emotes.getEmote(_loc5_));
            }
            else
            {
                _loc4_ = new StaticStringBuilder(_loc5_);
                this.buffer.push(this.makeNormalText(_loc4_,param2,param3));
            }
        }
    }

    private function makeNormalText(param1:StringBuilder, param2:Boolean, param3:uint) : TextField
    {
        var _loc4_:TextField = null;
        _loc4_ = new TextField();
        _loc4_.autoSize = TextFieldAutoSize.LEFT;
        _loc4_.embedFonts = true;
        var _loc5_:TextFormat = new TextFormat();
        _loc5_.font = "Myriad Pro";
        _loc5_.size = 14;
        _loc5_.bold = param2;
        _loc5_.color = param3;
        _loc4_.defaultTextFormat = _loc5_;
        _loc4_.selectable = false;
        _loc4_.mouseEnabled = false;
        _loc4_.text = param1.getString();
        if(_loc4_.textWidth > 150)
        {
            _loc4_.multiline = true;
            _loc4_.wordWrap = true;
            _loc4_.width = 150;
        }
        return _loc4_;
    }
}
}


import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Rectangle;

import kabam.rotmg.Emojis.Emote;


class Drawer extends Sprite
{


    private var maxWidth:int;

    private var list:Vector.<DisplayObject>;

    private var count:uint;

    private var lineHeight:uint;

    function Drawer(param1:Vector.<DisplayObject>, param2:int, param3:int)
    {
        super();
        this.maxWidth = param2;
        this.lineHeight = param3;
        this.list = param1;
        this.count = param1.length;
        this._0H_q();
        this._B_Z_();
    }

    private function _0H_q() : void
    {
        var _loc1_:int = 0;
        var _loc2_:DisplayObject = null;
        var _loc3_:Rectangle = null;
        var _loc4_:int = 0;
        var _loc5_:int = 0;
        _loc1_ = 0;
        while(_loc5_ < this.count)
        {
            _loc2_ = this.list[_loc5_];
            _loc3_ = _loc2_.getRect(_loc2_);
            _loc2_.x = _loc1_;
            _loc2_.y = -_loc3_.height;
            if(_loc1_ + _loc3_.width > this.maxWidth)
            {
                _loc2_.x = 0;
                _loc1_ = 0;
                _loc4_ = 0;
                while(_loc4_ < _loc5_)
                {
                    this.list[_loc4_].y = this.list[_loc4_].y - this.lineHeight;
                    _loc4_++;
                }
            }
            _loc1_ = _loc1_ + (_loc2_ is Emote?_loc3_.width + 2:_loc3_.width);
            _loc5_++;
        }
    }

    private function _B_Z_() : void
    {
        var _loc1_:DisplayObject = null;
        for each(_loc1_ in this.list)
        {
            addChild(_loc1_);
        }
    }
}