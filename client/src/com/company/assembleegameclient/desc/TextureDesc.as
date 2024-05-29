package com.company.assembleegameclient.desc {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.assembleegameclient.util.AnimatedChars;
import com.company.assembleegameclient.util.TextureRedrawer;

import flash.display.BitmapData;

public class TextureDesc {

    public var File:String;
    public var Index:int;

    public function TextureDesc(obj:*) {
        if (obj) {
            this.File = obj.File;
            this.Index = obj.Index;
        }
    }
}
}
