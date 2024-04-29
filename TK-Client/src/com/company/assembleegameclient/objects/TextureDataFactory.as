// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//com.company.assembleegameclient.objects.TextureDataFactory

package com.company.assembleegameclient.objects
{
    public class TextureDataFactory 
    {


        public function create(_arg_1:XML):TextureData
        {
            return (new TextureDataConcrete(_arg_1));
        }


    }
}//package com.company.assembleegameclient.objects

