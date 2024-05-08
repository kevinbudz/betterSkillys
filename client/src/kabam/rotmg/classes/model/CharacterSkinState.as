package kabam.rotmg.classes.model
{
   public class CharacterSkinState
   {
      public static const OWNED:CharacterSkinState = new CharacterSkinState(false,"OWNED");
      public static const PURCHASABLE:CharacterSkinState = new CharacterSkinState(true,"PURCHASABLE");
      public static const PURCHASING:CharacterSkinState = new CharacterSkinState(true,"PURCHASING");
      public static const LOCKED:CharacterSkinState = new CharacterSkinState(true,"LOCKED");
      public static const NULL:CharacterSkinState = new CharacterSkinState(true,"NULL");
      
      private var _isDisabled:Boolean;
      private var name:String;
      
      public function CharacterSkinState(isDisabled:Boolean, name:String)
      {
         super();
         this._isDisabled = isDisabled;
         this.name = name;
      }
      
      public function isDisabled() : Boolean
      {
         return this._isDisabled;
      }
      
      public function toString() : String
      {
         return "[CharacterSkinState {NAME}]".replace("{NAME}",this.name);
      }
   }
}
