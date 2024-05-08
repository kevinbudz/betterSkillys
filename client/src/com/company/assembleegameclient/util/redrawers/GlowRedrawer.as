package com.company.assembleegameclient.util.redrawers
{
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.PointUtil;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.GradientType;
import flash.display.Shape;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.geom.Matrix;
import flash.utils.Dictionary;

public class GlowRedrawer
{

    private static const GLOW_FILTER:GlowFilter = new GlowFilter(0,0.3,12,12,2,BitmapFilterQuality.LOW,false,false);
    private static const GLOW_FILTER_OUTLINE:GlowFilter = new GlowFilter(0, 0.8, 2, 2, 255, 1, false, false);

    private static var glowHashes:Dictionary = new Dictionary();

    public static function clearCache():void{
        for each (var _local3:* in glowHashes) {
            for each (var _local4:* in _local3) {
                delete _local3[_local4];
            }
            delete glowHashes[_local3];
        }
        glowHashes = new Dictionary();
    }

    public static function outlineGlow(texture:BitmapData, glowColor:uint, outlineSize:Number = 1.4, caching:Boolean = true, outlineColor:int = 0) : BitmapData
    {
        var hash:String = getHash(glowColor,outlineSize,outlineColor);
        if(caching && isCached(texture,hash))
        {
            return glowHashes[texture][hash];
        }
        var newTexture:BitmapData = texture.clone();
        var origBitmap:Bitmap = new Bitmap(texture);
        newTexture.draw(origBitmap,null,null,BlendMode.ALPHA);
        TextureRedrawer.OUTLINE_FILTER.blurX = outlineSize;
        TextureRedrawer.OUTLINE_FILTER.blurY = outlineSize;
        TextureRedrawer.OUTLINE_FILTER.color = outlineColor;
        newTexture.applyFilter(newTexture,newTexture.rect,PointUtil.ORIGIN,TextureRedrawer.OUTLINE_FILTER);
        if(glowColor != 0xFFFFFFFF)
        {
            if(glowColor != 0)
            {
                GLOW_FILTER_OUTLINE.color = glowColor;
                newTexture.applyFilter(newTexture, newTexture.rect, PointUtil.ORIGIN, GLOW_FILTER_OUTLINE);
                GLOW_FILTER.color = glowColor;
                newTexture.applyFilter(newTexture,newTexture.rect,PointUtil.ORIGIN,GLOW_FILTER);
            }
        }
        if(caching)
        {
            cache(texture,glowColor,outlineSize,newTexture,outlineColor);
        }
        return newTexture;
    }

    private static function cache(texture:BitmapData, glowColor:uint, outlineSize:Number, newTexture:BitmapData, outlineColor:int) : void
    {
        var glowHash:Object = null;
        var hash:String = getHash(glowColor,outlineSize,outlineColor);
        if(texture in glowHashes)
        {
            glowHashes[texture][hash] = newTexture;
        }
        else
        {
            glowHash = {};
            glowHash[hash] = newTexture;
            glowHashes[texture] = glowHash;
        }
    }

    private static function isCached(texture:BitmapData, hash:String) : Boolean
    {
        var outlineHash:Object = null;
        if(texture in glowHashes)
        {
            outlineHash = glowHashes[texture];
            if(hash in outlineHash)
            {
                return true;
            }
        }
        return false;
    }

    private static function getHash(glowColor:uint, outlineSize:Number, outlineColor:int) : String
    {
        return int(outlineSize * 10).toString() + glowColor + outlineColor;
    }
}
}
