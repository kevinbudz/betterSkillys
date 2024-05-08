package com.company.assembleegameclient.tutorial
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   
   public class Requirement
   {
       
      
      public var type_:String;
      
      public var slot_:int = -1;
      
      public var objectType_:int = -1;
      
      public var objectName_:String = "";
      
      public var radius_:Number = 1;
      
      public function Requirement(reqXML:XML)
      {
         super();
         this.type_ = String(reqXML);
         var objectId:String = String(reqXML.@objectId);
         if(objectId != null && objectId != "")
         {
            this.objectType_ = ObjectLibrary.idToType_[objectId];
         }
         this.objectName_ = String(reqXML.@objectName);
         if(this.objectName_ == null)
         {
            this.objectName_ = "";
         }
         this.slot_ = int(reqXML.@slot);
         this.radius_ = Number(reqXML.@radius);
      }
   }
}
