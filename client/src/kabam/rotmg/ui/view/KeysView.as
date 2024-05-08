package kabam.rotmg.ui.view
{
   import flash.display.Sprite;
   import kabam.rotmg.ui.model.Key;
   import mx.core.BitmapAsset;
   
   public class KeysView extends Sprite
   {
      
      private static var keyBackgroundPng:Class = KeysView_keyBackgroundPng;
      
      private static var greenKeyPng:Class = KeysView_greenKeyPng;
      
      private static var redKeyPng:Class = KeysView_redKeyPng;
      
      private static var yellowKeyPng:Class = KeysView_yellowKeyPng;
      
      private static var purpleKeyPng:Class = KeysView_purpleKeyPng;
       
      
      private var base:BitmapAsset;
      
      private var keys:Vector.<BitmapAsset>;
      
      public function KeysView()
      {
         super();
         this.base = new keyBackgroundPng();
         addChild(this.base);
         this.keys = new Vector.<BitmapAsset>(4,true);
         this.keys[0] = new purpleKeyPng();
         this.keys[1] = new greenKeyPng();
         this.keys[2] = new redKeyPng();
         this.keys[3] = new yellowKeyPng();
         for(var i:int = 0; i < 4; i++)
         {
            this.keys[i].x = 12 + 40 * i;
            this.keys[i].y = 12;
         }
      }
      
      public function showKey(key:Key) : void
      {
         var asset:BitmapAsset = this.keys[key.position];
         if(!contains(asset))
         {
            addChild(asset);
         }
      }
      
      public function hideKey(key:Key) : void
      {
         var asset:BitmapAsset = this.keys[key.position];
         if(contains(asset))
         {
            removeChild(asset);
         }
      }
   }
}
