package com.company.assembleegameclient.util
{
   import flash.display.DisplayObject;
   
   public class DisplayHierarchy
   {
       
      
      public function DisplayHierarchy()
      {
         super();
      }
      
      public static function getParentWithType(dObj:DisplayObject, c:Class) : DisplayObject
      {
         while(dObj && !(dObj is c))
         {
            dObj = dObj.parent;
         }
         return dObj;
      }
      
      public static function getParentWithTypeArray(dObj:DisplayObject, ... classes) : DisplayObject
      {
         var c:Class = null;
         while(dObj)
         {
            for each(c in classes)
            {
               if(dObj is c)
               {
                  return dObj;
               }
            }
            dObj = dObj.parent;
         }
         return dObj;
      }
   }
}
