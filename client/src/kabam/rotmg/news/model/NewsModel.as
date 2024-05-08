package kabam.rotmg.news.model
{
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.news.controller.NewsDataUpdatedSignal;
   
   public class NewsModel
   {
      
      private static const COUNT:int = 3;
       
      
      [Inject]
      public var update:NewsDataUpdatedSignal;
      
      [Inject]
      public var account:Account;
      
      public var news:Vector.<NewsCellVO>;
      
      public function NewsModel()
      {
         super();
      }
      
      public function initNews() : void
      {
         this.news = new Vector.<NewsCellVO>(COUNT,true);
         for(var i:int = 0; i < COUNT; i++)
         {
            this.news[i] = new DefaultNewsCellVO(i);
         }
      }
      
      public function updateNews(incoming:Vector.<NewsCellVO>) : void
      {
         this.initNews();
         this.sortByPriority(incoming);
         this.update.dispatch(this.news);
      }
      
      public function hasValidNews() : Boolean
      {
         return this.news[0] != null && this.news[1] != null && this.news[2] != null;
      }
      
      private function sortByPriority(incoming:Vector.<NewsCellVO>) : void
      {
         var newsObject:NewsCellVO = null;
         for each(newsObject in incoming)
         {
            this.prioritize(newsObject);
         }
      }
      
      private function prioritize(newsObject:NewsCellVO) : void
      {
         var index:uint = newsObject.slot - 1;
         if(this.news[index])
         {
            newsObject = this.comparePriority(this.news[index],newsObject);
         }
         this.news[index] = newsObject;
      }
      
      private function comparePriority(a:NewsCellVO, b:NewsCellVO) : NewsCellVO
      {
         return a.priority < b.priority?a:b;
      }
   }
}
