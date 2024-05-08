package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   internal class ObjectElement extends Element
   {
       
      
      public var objXML_:XML;
      
      function ObjectElement(objXML:XML)
      {
         super(int(objXML.@type));
         this.objXML_ = objXML;
         var texture:BitmapData = ObjectLibrary.getRedrawnTextureFromType(type_,100,true,false);
         var bitmap:Bitmap = new Bitmap(texture);
         var scale:Number = (WIDTH - 4) / Math.max(bitmap.width,bitmap.height);
         bitmap.scaleX = bitmap.scaleY = scale;
         bitmap.x = WIDTH / 2 - bitmap.width / 2;
         bitmap.y = HEIGHT / 2 - bitmap.height / 2;
         addChild(bitmap);
      }
      
      override protected function getToolTip() : ToolTip
      {
         return new ObjectTypeToolTip(this.objXML_);
      }
   }
}
