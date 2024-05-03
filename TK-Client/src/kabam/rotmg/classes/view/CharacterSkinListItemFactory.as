package kabam.rotmg.classes.view
{
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.Currency;
   import com.company.util.AssetLibrary;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.CharacterSkins;
   import kabam.rotmg.util.components.LegacyBuyButton;
   
   public class CharacterSkinListItemFactory
   {
       
      
      [Inject]
      public var characters:CharacterFactory;
      
      public function CharacterSkinListItemFactory()
      {
         super();
      }
      
      public function make(skins:CharacterSkins) : Vector.<DisplayObject>
      {
         var count:int = 0;
         count = skins.getCount();
         var items:Vector.<DisplayObject> = new Vector.<DisplayObject>(count,true);
         for(var i:int = 0; i < count; i++)
         {
            items[i] = this.makeCharacterSkinTile(skins.getSkinAt(i));
         }
         return items;
      }
      
      private function makeCharacterSkinTile(model:CharacterSkin) : CharacterSkinListItem
      {
         var view:CharacterSkinListItem = new CharacterSkinListItem();
         view.setSkin(this.makeIcon(model));
         view.setModel(model);
         view.setLockIcon(AssetLibrary.getImageFromSet("lofiInterface2",5));
         view.setBuyButton(this.makeBuyButton());
         return view;
      }
      
      private function makeBuyButton() : LegacyBuyButton
      {
         var button:LegacyBuyButton = new LegacyBuyButton("Buy for ",16,0,Currency.GOLD);
         button.setWidth(120);
         return button;
      }

      private function makeIcon(_arg_1:CharacterSkin):Bitmap
      {
         var _local_2:int = _arg_1.is16x16 ? 50 : 100;
         var _local_3:BitmapData = this.characters.makeIcon(_arg_1.template, _local_2);
         return (new Bitmap(_local_3));
      }
   }
}
