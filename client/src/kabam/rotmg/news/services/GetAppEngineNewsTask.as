package kabam.rotmg.news.services
{
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
   import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   import kabam.rotmg.news.model.NewsCellLinkType;
   import kabam.rotmg.news.model.NewsCellVO;
   import kabam.rotmg.news.model.NewsModel;
   
   public class GetAppEngineNewsTask extends BaseTask implements GetNewsTask
   {
       
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var model:NewsModel;
      
      public function GetAppEngineNewsTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("/app/globalNews",{});
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.onNewsRequestDone(data);
         }
         else
         {
            this.onNewsRequestError(data);
         }
         completeTask(isOK,data);
      }
      
      private function onNewsRequestDone(json:String) : void
      {
         var newsObject:Object = null;
         var news:Vector.<NewsCellVO> = new Vector.<NewsCellVO>();
         var data:Object = JSON.parse(json);
         for each(newsObject in data)
         {
            news.push(this.returnNewsCellVO(newsObject));
         }
         this.model.updateNews(news);
      }
      
      private function returnNewsCellVO(newsObject:Object) : NewsCellVO
      {
         var newsCellVO:NewsCellVO = null;
         newsCellVO = new NewsCellVO();
         newsCellVO.headline = newsObject.title;
         newsCellVO.imageURL = newsObject.image;
         newsCellVO.linkDetail = newsObject.linkDetail;
         newsCellVO.linkType = NewsCellLinkType.parse(newsObject.linkType);
         newsCellVO.priority = newsObject.priority;
         newsCellVO.slot = newsObject.slot;
         return newsCellVO;
      }
      
      private function onNewsRequestError(error:String) : void
      {
         this.openDialog.dispatch(new ErrorDialog("Unable to get news data."));
      }
   }
}
