package com.company.assembleegameclient.appengine
{
   import com.company.assembleegameclient.util.TextureRedrawer;
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   
   public class SavedNewsItem
   {
      
      private static const FAME:String = "fame";
       
      
      private var iconName:String;
      
      public var title_:String;
      
      public var tagline_:String;
      
      public var link_:String;
      
      public var date_:int;
      
      public function SavedNewsItem(iconName:String, title:String, tagline:String, link:String, date:int)
      {
         super();
         this.iconName = iconName;
         this.title_ = title;
         this.tagline_ = tagline;
         this.link_ = link;
         this.date_ = date;
      }
      
      private static function forumIcon() : BitmapData
      {
         var bd:BitmapData = AssetLibrary.getImageFromSet("lofiInterface2",4);
         return TextureRedrawer.redraw(bd,80,true,0);
      }
      
      private static function fameIcon() : BitmapData
      {
         var bd:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",224);
         return TextureRedrawer.redraw(bd,80,true,0);
      }
      
      public function getIcon() : BitmapData
      {
         return this.iconName == FAME?fameIcon():forumIcon();
      }
       public function isCharDeath():Boolean {
           return ((this.iconName == FAME));
       }
   }
}
