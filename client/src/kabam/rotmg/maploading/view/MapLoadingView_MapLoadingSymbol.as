package kabam.rotmg.maploading.view
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class MapLoadingView_MapLoadingSymbol extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      
      public var dataClass:Class;
      
      public function MapLoadingView_MapLoadingSymbol()
      {
         this.dataClass = MapLoadingView_MapLoadingSymbol_dataClass;
         super();
         initialWidth = 16000 / 20;
         initialHeight = 12000 / 20;
      }
      
      override public function get movieClipData() : ByteArray
      {
         if(bytes == null)
         {
            bytes = ByteArray(new this.dataClass());
         }
         return bytes;
      }
   }
}
