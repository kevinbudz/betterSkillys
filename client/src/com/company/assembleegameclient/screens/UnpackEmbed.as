package com.company.assembleegameclient.screens
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.MovieClip;
   import flash.events.Event;
   import mx.core.MovieClipAsset;
   import org.osflash.signals.Signal;
   
   public class UnpackEmbed
   {
       
      
      private var _ready:Signal;
      
      private var _asset:MovieClipAsset;
      
      private var _content:MovieClip;
      
      public function UnpackEmbed(assetClass:Class)
      {
         super();
         this._asset = new assetClass();
         this._ready = new Signal(UnpackEmbed);
         var loader:Loader = Loader(this._asset.getChildAt(0));
         var info:LoaderInfo = loader.contentLoaderInfo;
         info.addEventListener(Event.COMPLETE,this.onLoadComplete);
      }
      
      private function onLoadComplete(event:Event) : void
      {
         var info:LoaderInfo = LoaderInfo(event.target);
         info.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         this._content = MovieClip(info.loader.content);
         this._ready.dispatch(this);
      }
      
      public function get content() : MovieClip
      {
         return this._content;
      }
      
      public function get ready() : Signal
      {
         return this._ready;
      }
      
      public function get asset() : MovieClipAsset
      {
         return this._asset;
      }
   }
}
