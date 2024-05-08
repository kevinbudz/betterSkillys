package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.assembleegameclient.util.Currency;
   import com.company.assembleegameclient.util.GuildUtil;
   import flash.display.BitmapData;
   
   public class GuildMerchant extends SellableObject implements IInteractiveObject
   {
       
      
      public var description_:String;
      
      public function GuildMerchant(objectXML:XML)
      {
         super(objectXML);
         price_ = int(objectXML.Price);
         currency_ = Currency.GUILD_FAME;
         this.description_ = objectXML.Description;
         guildRankReq_ = GuildUtil.LEADER;
      }
      
      override public function soldObjectName() : String
      {
         return ObjectLibrary.typeToDisplayId_[objectType_];
      }
      
      override public function soldObjectInternalName() : String
      {
         var objectXML:XML = ObjectLibrary.xmlLibrary_[objectType_];
         return objectXML.@id.toString();
      }
      
      override public function getTooltip() : ToolTip
      {
         var toolTip:ToolTip = new TextToolTip(3552822,10197915,this.soldObjectName(),this.description_,200);
         return toolTip;
      }

      override public function getIcon() : BitmapData
      {
         return ObjectLibrary.getRedrawnTextureFromType(objectType_,80,true);
      }
   }
}
