package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.MoreStringUtil;

import flash.utils.Dictionary;

internal class ObjectChooser extends Chooser
   {

      private var cache:Dictionary;
      private var lastSearch:String = "";
      
      function ObjectChooser()
      {
         super(Layer.OBJECT);
         this.cache = new Dictionary();
         this.reloadObjects("", true);
      }

      public function getLastSearch():String
      {
         return this.lastSearch;
      }

      public function reloadObjects(objectName:String = "", noRemoveObjects:Boolean = false) : void
      {
         var regExp:RegExp;
         var id:String;
         var type:int = 0;
         var objXML:XML = null;
         var objectElement:ObjectElement = null;
         var ids:Vector.<String> = new Vector.<String>();
         if(!noRemoveObjects)
         {
            removeElements();
         }
         if(objectName != "")
         {
            regExp = new RegExp(objectName, "gix");
         }
         for(id in ObjectLibrary.idToType_)
         {
            if(regExp != null)
            {
               if(id.search(regExp) >= 0)
               {
                  ids.push(id);
               }
            }
            else
            {
               ids.push(id);
            }
         }
         ids.sort(MoreStringUtil.cmp);
         for each(id in ids)
         {
            type = ObjectLibrary.idToType_[id];
            objXML = ObjectLibrary.xmlLibrary_[type];
            if(!(objXML.hasOwnProperty("Item") || objXML.hasOwnProperty("Player") || objXML.Class == "Projectile"))
            {
               if (!this.cache[type]) {
                  objectElement = new ObjectElement(objXML);
                  this.cache[type] = objectElement;
               }
               else {
                  objectElement = this.cache[type];
               }
               addElement(objectElement);
            }
         }
      }
   }
}
