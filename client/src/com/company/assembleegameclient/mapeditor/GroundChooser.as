package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.util.MoreStringUtil;

import flash.utils.Dictionary;

internal class GroundChooser extends Chooser
   {

      private var cache:Dictionary;
      private var lastSearch:String = "";
      
      function GroundChooser()
      {
         super(Layer.GROUND);
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
         var id:String = "";
         var type:int = 0;
         var tileElement:GroundElement = null;
         var ids:Vector.<String> = new Vector.<String>();
         if(!noRemoveObjects)
         {
            removeElements();
         }
         if(objectName != "")
         {
            regExp = new RegExp(objectName, "gix");
         }
         for(id in GroundLibrary.idToType_)
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
            type = GroundLibrary.idToType_[id];
            if (!this.cache[type]) {
               tileElement = new GroundElement(GroundLibrary.xmlLibrary_[type]);
               this.cache[type] = tileElement;
            }
            else {
               tileElement = this.cache[type];
            }
            addElement(tileElement);
         }
      }
   }
}
