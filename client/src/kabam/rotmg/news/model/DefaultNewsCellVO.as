package kabam.rotmg.news.model
{
   public class DefaultNewsCellVO extends NewsCellVO
   {
       
      
      public function DefaultNewsCellVO(slotId:int)
      {
         super();
         imageURL = "";
         linkDetail = "https://forums.wildshadow.com/";
         headline = slotId == 0?"Realm Forums and Wiki":"Forums";
         linkType = NewsCellLinkType.OPENS_LINK;
         priority = 999999;
         slot = slotId;
      }
   }
}
