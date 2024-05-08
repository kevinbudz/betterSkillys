package kabam.rotmg.classes.model
{
   import kabam.rotmg.assets.model.CharacterTemplate;
   import org.osflash.signals.Signal;
   
   public class CharacterSkin
   {
      public const changed:Signal = new Signal(CharacterSkin);
      
      public var id:int = 0;
      public var name:String = "";
      public var unlockLevel:int;
      public var template:CharacterTemplate;
      public var cost:int;
      public var is16x16:Boolean = false;
      private var state:CharacterSkinState;
      private var isSelected:Boolean;
      
      public function CharacterSkin()
      {
         this.state = CharacterSkinState.NULL;
         super();
      }
      
      public function getIsSelected() : Boolean
      {
         return this.isSelected;
      }
      
      public function setIsSelected(value:Boolean) : void
      {
         if(this.isSelected != value)
         {
            this.isSelected = value;
            this.changed.dispatch(this);
         }
      }
      
      public function getState() : CharacterSkinState
      {
         return this.state;
      }
      
      public function setState(value:CharacterSkinState) : void
      {
         if(this.state != value)
         {
            this.state = value;
            this.changed.dispatch(this);
         }
      }
   }
}
