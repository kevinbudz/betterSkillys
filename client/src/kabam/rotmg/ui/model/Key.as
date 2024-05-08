package kabam.rotmg.ui.model
{
   public class Key
   {
      
      public static const PURPLE:Key = new Key(0);
      
      public static const GREEN:Key = new Key(1);
      
      public static const RED:Key = new Key(2);
      
      public static const YELLOW:Key = new Key(3);
       
      
      public var position:int;
      
      public function Key(position:int)
      {
         super();
         this.position = position;
      }
   }
}
