package com.company.assembleegameclient.util
{
import flash.utils.Dictionary;

public class FreeList
{

   private static var dict_:Dictionary = new Dictionary();


   public function FreeList()
   {
      super();
   }

   public static function newObject(c:Class) : Object
   {
      var vec:Vector.<Object> = dict_[c];
      if(vec == null)
      {
         vec = new Vector.<Object>();
         dict_[c] = vec;
      }
      else if(vec.length > 0)
      {
         return vec.pop();
      }
      return new c();
   }

   public static function storeObject(id:*, o:Object) : void
   {
      var vec:Vector.<Object> = dict_[id];
      if(vec == null)
      {
         vec = new Vector.<Object>();
         dict_[id] = vec;
      }
      vec.push(o);
   }

   public static function getObject(id:*) : Object
   {
      var vec:Vector.<Object> = dict_[id];
      if(vec != null && vec.length > 0)
      {
         trace("vec size: " + vec.length);
         return vec.pop();
      }
      return null;
   }

   public static function dump(id:*) : void
   {
      delete dict_[id];
   }

   public static function dispose() : void
   {
      var vec:Vector.<Object>;
      for each(vec in dict_)
      {
         vec.length = 0;
      }
   }

   public static function deleteObject(o:Object) : void
   {
      var c:Class = Object(o).constructor;
      var vec:Vector.<Object> = dict_[c];
      if(vec == null)
      {
         vec = new Vector.<Object>();
         dict_[c] = vec;
      }
      vec.push(o);
   }
}
}
