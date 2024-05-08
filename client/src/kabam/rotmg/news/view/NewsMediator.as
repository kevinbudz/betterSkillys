package kabam.rotmg.news.view
{
   import kabam.rotmg.news.controller.NewsDataUpdatedSignal;
   import kabam.rotmg.news.model.NewsCellVO;
   import kabam.rotmg.news.model.NewsModel;
   import robotlegs.bender.bundles.mvcs.Mediator;
   
   public class NewsMediator extends Mediator
   {
       
      
      [Inject]
      public var view:NewsView;
      
      [Inject]
      public var update:NewsDataUpdatedSignal;
      
      [Inject]
      public var model:NewsModel;
      
      public function NewsMediator()
      {
         super();
      }
      
      override public function initialize() : void
      {
         this.view.update(this.model.news);
         this.update.add(this.onUpdate);
      }
      
      override public function destroy() : void
      {
         this.update.remove(this.onUpdate);
      }
      
      private function onUpdate(news:Vector.<NewsCellVO>) : void
      {
         this.view.update(news);
      }
   }
}
