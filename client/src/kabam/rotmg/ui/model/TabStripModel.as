package kabam.rotmg.ui.model
{
   public class TabStripModel
   {
      
      public static const MAIN_INVENTORY:String = "Main Inventory";
      public static const STATS:String = "Stats";
      public static const BACKPACK:String = "Backpack";
      public static const TALISMANS:String = "Talismans";

      
      public var currentSelection:String;
      
      public function TabStripModel()
      {
         super();
      }
   }
}
