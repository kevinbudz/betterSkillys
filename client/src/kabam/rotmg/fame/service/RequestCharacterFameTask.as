package kabam.rotmg.fame.service
{
   import com.company.assembleegameclient.ui.dialogs.ErrorDialog;
import com.company.util.DateFormatterReplacement;

import kabam.lib.tasks.BaseTask;
   import kabam.rotmg.appengine.api.AppEngineClient;
   import kabam.rotmg.assets.model.CharacterTemplate;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.dialogs.control.OpenDialogSignal;
   
   public class RequestCharacterFameTask extends BaseTask
   {
       
      
      [Inject]
      public var client:AppEngineClient;
      
      [Inject]
      public var openDialog:OpenDialogSignal;
      
      [Inject]
      public var classes:ClassesModel;
      
      public var accountId:int;
      
      public var charId:int;
      
      public var xml:XML;
      
      public var name:String;
      
      public var level:int;
      
      public var type:int;
      
      public var deathDate:String;
      
      public var killer:String;
      
      public var totalFame:int;
      
      public var template:CharacterTemplate;
      
      public var texture1:int;
      
      public var texture2:int;

      public var size:int;

      public function RequestCharacterFameTask()
      {
         super();
      }
      
      override protected function startTask() : void
      {
         this.sendFameRequest();
      }
      
      private function sendFameRequest() : void
      {
         this.client.setMaxRetries(3);
         this.client.complete.addOnce(this.onComplete);
         this.client.sendRequest("char/fame",this.getDataPacket());
      }
      
      private function getDataPacket() : Object
      {
         var data:Object = {};
         data.accountId = this.accountId;
         data.charId = this.accountId == -1?-1:this.charId;
         return data;
      }
      
      private function onComplete(isOK:Boolean, data:*) : void
      {
         if(isOK)
         {
            this.parseFameData(data);
         }
         else
         {
            this.onFameError(data);
         }
      }
      
      private function parseFameData(data:String) : void
      {
         this.xml = new XML(data);
         this.parseXML();
         completeTask(true);
      }
      
      private function parseXML() : void
      {
         var charXml:XML = null;
         var char:CharacterClass = null;
         var skin:CharacterSkin = null;
         charXml = this.xml.Char.(@id == charId)[0];
         this.name = charXml.Account.Name;
         this.level = charXml.Level;
         this.type = charXml.ObjectType;
         this.deathDate = this.getDeathDate();
         this.killer = this.xml.KilledBy || "";
         this.totalFame = this.xml.TotalFame;
         char = this.classes.getCharacterClass(charXml.ObjectType);
         skin = Boolean(charXml.hasOwnProperty("Texture"))?char.skins.getSkin(charXml.Texture):char.skins.getDefaultSkin();
         this.template = skin.template;
         this.texture1 = Boolean(charXml.hasOwnProperty("Tex1"))?int(charXml.Tex1):int(0);
         this.texture2 = Boolean(charXml.hasOwnProperty("Tex2"))?int(charXml.Tex2):int(0);
         this.size = ((skin.is16x16) ? 140 : 250);
      }
      
      private function getDeathDate() : String
      {
         var time:Number = Number(this.xml.CreatedOn) * 1000;
         var date:Date = new Date(time);
         var df:DateFormatterReplacement = new DateFormatterReplacement();
         df.formatString = "MMMM D, YYYY";
         return df.format(date);
      }
      
      private function onFameError(data:String) : void
      {
         this.openDialog.dispatch(new ErrorDialog(data));
      }
   }
}
