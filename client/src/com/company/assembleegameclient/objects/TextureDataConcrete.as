// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.TextureDataConcrete

package com.company.assembleegameclient.objects
{
    import flash.display.BitmapData;
    import com.company.assembleegameclient.util.MaskedImage;
    import com.company.util.AssetLibrary;
    import com.company.assembleegameclient.objects.particles.EffectProperties;
    import com.company.assembleegameclient.util.AnimatedChars;
    import com.company.assembleegameclient.util.AnimatedChar;
    import flash.utils.Dictionary;

    public class TextureDataConcrete extends TextureData 
    {

        public static var remoteTexturesUsed:Boolean = false;

        private var isUsingLocalTextures:Boolean;

        public function TextureDataConcrete(_arg_1:XML)
        {
            var _local_2:XML;
            super();
            //this.isUsingLocalTextures = this.getWhetherToUseLocalTextures();
            if (_arg_1.hasOwnProperty("Texture"))
            {
                this.parse(XML(_arg_1.Texture), String(_arg_1.@id));
            }
            else
            {
                if (_arg_1.hasOwnProperty("AnimatedTexture"))
                {
                    this.parse(XML(_arg_1.AnimatedTexture), String(_arg_1.@id));
                }
                else
                {
                    if (_arg_1.hasOwnProperty("RemoteTexture"))
                    {
                        this.parse(XML(_arg_1.RemoteTexture));
                    }
                    else
                    {
                        if (_arg_1.hasOwnProperty("RandomTexture"))
                        {
                            this.parse(XML(_arg_1.RandomTexture), String(_arg_1.@id));
                        }
                        else
                        {
                            this.parse(_arg_1);
                        }
                    }
                }
            }
            for each (_local_2 in _arg_1.AltTexture)
            {
                this.parse(_local_2);
            }
            if (_arg_1.hasOwnProperty("Mask"))
            {
                this.parse(XML(_arg_1.Mask));
            }
            if (_arg_1.hasOwnProperty("Effect"))
            {
                this.parse(XML(_arg_1.Effect));
            }
        }

        override public function getTexture(_arg_1:int=0):BitmapData
        {
            if (randomTextureData_ == null)
            {
                return (texture_);
            }
            var _local_2:TextureData = randomTextureData_[(_arg_1 % randomTextureData_.length)];
            return (_local_2.getTexture(_arg_1));
        }

        override public function getAltTextureData(_arg_1:int):TextureData
        {
            if (altTextures_ == null)
            {
                return (null);
            }
            return (altTextures_[_arg_1]);
        }

        private function parse(xml:XML, id:String=""):void
        {
            var image:MaskedImage;
            var childXML:XML;
            switch (xml.name().toString())
            {
                case "Texture":
                    try
                    {
                        texture_ = AssetLibrary.getImageFromSet(String(xml.File), int(xml.Index));
                    }
                    catch(error:Error)
                    {
                        throw (new Error(((((("Error loading Texture for " + id) + " - name: ") + String(xml.File)) + " - idx: ") + int(xml.Index))));
                    }
                    return;
                case "Mask":
                    mask_ = AssetLibrary.getImageFromSet(String(xml.File), int(xml.Index));
                    return;
                case "Effect":
                    effectProps_ = new EffectProperties(xml);
                    return;
                case "AnimatedTexture":
                    animatedChar_ = AnimatedChars.getAnimatedChar(String(xml.File), int(xml.Index));
                    try
                    {
                        image = animatedChar_.imageFromAngle(0, AnimatedChar.STAND, 0);
                        texture_ = image.image_;
                        mask_ = image.mask_;
                    }
                    catch(error:Error)
                    {
                        throw (new Error(((((("Error loading AnimatedTexture for " + id) + " - name: ") + String(xml.File)) + " - idx: ") + int(xml.Index))));
                    }
                    return;
                case "RandomTexture":
                    try
                    {
                        randomTextureData_ = new Vector.<TextureData>();
                        for each (childXML in xml.children())
                        {
                            randomTextureData_.push(new TextureDataConcrete(childXML));
                        }
                    }
                    catch(error:Error)
                    {
                        throw (new Error(("Error loading RandomTexture for " + id)));
                    }
                    return;
                case "AltTexture":
                    if (altTextures_ == null)
                    {
                        altTextures_ = new Dictionary();
                    }
                    altTextures_[int(xml.@id)] = new TextureDataConcrete(xml);
                    return;
            }
        }

        private function onRemoteTexture(_arg_1:BitmapData):void
        {
            if (_arg_1)
            {
                if (_arg_1.width > 16)
                {
                    AnimatedChars.add("remoteTexture", _arg_1, null, (_arg_1.width / 7), _arg_1.height, _arg_1.width, _arg_1.height, remoteTextureDir_);
                    animatedChar_ = AnimatedChars.getAnimatedChar("remoteTexture", 0);
                    texture_ = animatedChar_.imageFromAngle(0, AnimatedChar.STAND, 0).image_;
                }
                else
                {
                    texture_ = _arg_1;
                }
            }
        }


    }
}//package com.company.assembleegameclient.objects

