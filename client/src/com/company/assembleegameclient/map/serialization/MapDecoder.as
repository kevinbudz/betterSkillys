package com.company.assembleegameclient.map.serialization
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.Map;
   import com.company.assembleegameclient.objects.BasicObject;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.util.IntPoint;
   import com.hurlant.util.Base64;
   import flash.utils.ByteArray;
   import kabam.lib.json.JsonParser;
   import kabam.rotmg.core.StaticInjectorContext;
   
   public class MapDecoder
   {
       
      
      public function MapDecoder()
      {
         super();
      }
      
      private static function get json() : JsonParser
      {
         return StaticInjectorContext.getInjector().getInstance(JsonParser);
      }
      
      public static function decodeMap(encodedMap:String) : Map
      {
         var jm:Object = json.parse(encodedMap);
         var map:Map = new Map(null);
         map.setProps(jm["width"],jm["height"],jm["name"],jm["back"],false,false);
         map.initialize();
         writeMapInternal(jm,map,0,0);
         return map;
      }
      
      public static function writeMap(encodedMap:String, map:Map, x:int, y:int) : void
      {
         var jm:Object = json.parse(encodedMap);
         writeMapInternal(jm,map,x,y);
      }
      
      public static function getSize(encodedMap:String) : IntPoint
      {
         var jm:Object = json.parse(encodedMap);
         return new IntPoint(jm["width"],jm["height"]);
      }
      
      private static function writeMapInternal(jm:Object, map:Map, x:int, y:int) : void
      {
         var yi:int = 0;
         var xi:int = 0;
         var entry:Object = null;
         var objs:Array = null;
         var groundType:int = 0;
         var obj:Object = null;
         var go:GameObject = null;
         var byteArray:ByteArray = Base64.decodeToByteArray(jm["data"]);
         byteArray.uncompress();
         var dict:Array = jm["dict"];
         for(yi = y; yi < y + jm["height"]; yi++)
         {
            for(xi = x; xi < x + jm["width"]; xi++)
            {
               entry = dict[byteArray.readShort()];
               if(!(xi < 0 || xi >= map.width_ || yi < 0 || yi >= map.height_))
               {
                  if(entry.hasOwnProperty("ground"))
                  {
                     groundType = GroundLibrary.idToType_[entry["ground"]];
                     map.setGroundTile(xi,yi,groundType);
                  }
                  objs = entry["objs"];
                  if(objs != null)
                  {
                     for each(obj in objs)
                     {
                        go = getGameObject(obj);
                        go.objectId_ = BasicObject.getNextFakeObjectId();
                        map.addObj(go,xi + 0.5,yi + 0.5);
                     }
                  }
               }
            }
         }
      }
      
      public static function getGameObject(obj:Object) : GameObject
      {
         var objType:int = ObjectLibrary.idToType_[obj["id"]];
         var objXML:XML = ObjectLibrary.xmlLibrary_[objType];
         trace(objXML);
         var go:GameObject = ObjectLibrary.getObjectFromType(objType);
         go.size_ = !!obj.hasOwnProperty("size")?int(obj["size"]):int(go.props_.getSize());
         return go;
      }
   }
}
