package kabam.rotmg.legends.model
{
   import com.company.util.ConversionUtil;
   import kabam.rotmg.assets.services.CharacterFactory;
   import kabam.rotmg.classes.model.CharacterClass;
   import kabam.rotmg.classes.model.CharacterSkin;
   import kabam.rotmg.classes.model.ClassesModel;
   import kabam.rotmg.core.model.PlayerModel;
   
   public class LegendFactory
   {
       
      
      [Inject]
      public var playerModel:PlayerModel;
      
      [Inject]
      public var classesModel:ClassesModel;
      
      [Inject]
      public var factory:CharacterFactory;
      
      private var ownAccountId:int;
      
      private var legends:Vector.<Legend>;
      
      public function LegendFactory()
      {
         super();
      }
      
      public function makeLegends(xml:XML) : Vector.<Legend>
      {
         this.ownAccountId = this.playerModel.getAccountId();
         this.legends = new Vector.<Legend>(0);
         this.makeLegendsFromList(xml.FameListElem,false);
         this.makeLegendsFromList(xml.MyFameListElem,true);
         return this.legends;
      }
      
      private function makeLegendsFromList(list:XMLList, isFocus:Boolean) : void
      {
         var node:XML = null;
         var legend:Legend = null;
         for each(node in list)
         {
            if(!this.legendsContains(node))
            {
               legend = this.makeLegend(node);
               legend.isOwnLegend = node.@accountId == this.ownAccountId;
               legend.isFocus = isFocus;
               this.legends.push(legend);
            }
         }
      }
      
      private function legendsContains(node:XML) : Boolean
      {
         var legend:Legend = null;
         for each(legend in this.legends)
         {
            if(legend.accountId == node.@accountId && legend.charId == node.@charId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function makeLegend(xml:XML) : Legend
      {
         var type:int = xml.ObjectType;
         var skinType:int = xml.Texture;
         var character:CharacterClass = this.classesModel.getCharacterClass(type);
         var skin:CharacterSkin = character.skins.getSkin(skinType);
         var texture1:int = Boolean(xml.hasOwnProperty("Tex1"))?int(xml.Tex1):int(0);
         var texture2:int = Boolean(xml.hasOwnProperty("Tex2"))?int(xml.Tex2):int(0);
         var legend:Legend = new Legend();
         legend.accountId = xml.@accountId;
         legend.charId = xml.@charId;
         legend.name = xml.Name;
         legend.totalFame = xml.TotalFame;
         legend.character = this.factory.makeIcon(skin.template, 100,texture1,texture2);
         if (legend.character.width > 52)
             legend.character = this.factory.makeIcon(skin.template, 50,texture1,texture2);
         legend.equipmentSlots = character.slotTypes;
         legend.equipment = ConversionUtil.toIntVector(xml.Equipment);
         legend.itemDatas_ = new Vector.<Object>();
         var data:Vector.<Object> = ConversionUtil.ArrayToObject(xml.ItemDatas, ";");
         for(var i:int = 0; i < data.length; i++)
            legend.itemDatas_[i] = JSON.parse(String(data[i]));
         return legend;
      }
   }
}
