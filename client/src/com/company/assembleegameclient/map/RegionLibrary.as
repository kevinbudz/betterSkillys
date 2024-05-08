package com.company.assembleegameclient.map
{
   import flash.utils.Dictionary;
   
   public class RegionLibrary
   {
      
      public static const xmlLibrary_:Dictionary = new Dictionary();
      
      public static var idToType_:Dictionary = new Dictionary();
       
      
      public function RegionLibrary()
      {
         super();
      }
      
      public static function parseFromXML(xml:XML) : void
      {
         var regionXML:XML = null;
         var type:int = 0;
         for each(regionXML in xml.Region)
         {
            type = int(regionXML.@type);
            xmlLibrary_[type] = regionXML;
            idToType_[String(regionXML.@id)] = type;
         }
      }
      
      public static function getIdFromType(type:int) : String
      {
         var objectXML:XML = xmlLibrary_[type];
         if(objectXML == null)
         {
            return null;
         }
         return String(objectXML.@id);
      }
      
      public static function getColor(type:int) : uint
      {
         var objectXML:XML = xmlLibrary_[type];
         if(objectXML == null)
         {
            return 0;
         }
         return uint(objectXML.Color);
      }
   }
}
