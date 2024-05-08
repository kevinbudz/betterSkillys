package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.BitmapData;
   
   public class ClosedVaultChest extends SellableObject
   {
       
      
      public function ClosedVaultChest(objectXML:XML)
      {
         super(objectXML);
      }
      
      override public function soldObjectName() : String
      {
         return "Vault Chest";
      }
      
      override public function soldObjectInternalName() : String
      {
         return "Vault Chest";
      }
      
      override public function getTooltip() : ToolTip
      {
         var toolTip:ToolTip = new TextToolTip(3552822,10197915,this.soldObjectName(),"A chest that will safely store 8 items and is " + "accessible by all of your characters.",200);
         return toolTip;
      }
      
      override public function getIcon() : BitmapData
      {
         return ObjectLibrary.getRedrawnTextureFromType(ObjectLibrary.idToType_["Vault Chest"],55,true);
      }
   }
}
