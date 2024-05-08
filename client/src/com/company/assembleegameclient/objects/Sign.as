package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.util.TextureRedrawer;
   import flash.display.BitmapData;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Sign extends GameObject
   {
       
      
      public function Sign(objectXML:XML)
      {
         super(objectXML);
         texture_ = null;
      }
      
      override protected function getTexture(camera:Camera, time:int) : BitmapData
      {
         if(texture_ != null)
         {
            return texture_;
         }
         var txt:TextField = new TextField();
         txt.multiline = true;
         txt.wordWrap = false;
         txt.autoSize = TextFieldAutoSize.LEFT;
         txt.textColor = 16777215;
         txt.embedFonts = true;
         var newFormat:TextFormat = new TextFormat();
         newFormat.align = TextFormatAlign.CENTER;
         newFormat.font = "Myriad Pro";
         newFormat.size = 24;
         newFormat.color = 16777215;
         newFormat.bold = true;
         txt.defaultTextFormat = newFormat;
         txt.text = name_.split("|").join("\n");
         var bitmapData:BitmapData = new BitmapData(txt.width,txt.height,true,0);
         bitmapData.draw(txt);
         texture_ = TextureRedrawer.redraw(bitmapData,size_,false,0);
         return texture_;
      }
   }
}
