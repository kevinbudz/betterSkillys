package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.RegionLibrary;
   
   public class RegionChooser extends Chooser
   {
       
      
      public function RegionChooser()
      {
         var regionXML:XML = null;
         var regionElement:RegionElement = null;
         super(Layer.REGION);
         for each(regionXML in RegionLibrary.xmlLibrary_)
         {
            regionElement = new RegionElement(regionXML);
            addElement(regionElement);
         }
      }
   }
}
