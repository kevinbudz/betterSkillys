package kabam.rotmg.news.model
{
   public class NewsCellLinkType
   {
      
      public static const OPENS_LINK:NewsCellLinkType = new NewsCellLinkType(1);
      
      private static const types:Object = {
         1:OPENS_LINK
      };
       
      
      private var index:int;
      
      public function NewsCellLinkType(index:int)
      {
         super();
         this.index = index;
      }
      
      public static function parse(index:int) : NewsCellLinkType
      {
         return types[index];
      }
      
      public function getIndex() : int
      {
         return this.index;
      }
   }
}
