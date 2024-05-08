package io.decagames.rotmg.ui.defaults
{
   import com.company.assembleegameclient.util.FilterUtil;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import io.decagames.rotmg.ui.labels.UILabel;
   //import kabam.rotmg.text.model.FontModel;
   
   public class DefaultLabelFormat
   {
       
      
      public function DefaultLabelFormat()
      {
         super();
      }
      
      public static function createLabelFormat(param1:UILabel, param2:int = 12, param3:Number = 16777215, param4:String = "left", param5:Boolean = false, param6:Array = null) : void
      {
         var _loc7_:TextFormat = createTextFormat(param2,param3,param4,param5);
         applyTextFormat(_loc7_,param1);
         if(param6)
         {
            param1.filters = param6;
         }
      }
      
      public static function defaultButtonLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,16,16777215,TextFormatAlign.CENTER);
      }
      
      public static function defaultPopupTitle(param1:UILabel) : void
      {
         createLabelFormat(param1,32,15395562,TextFormatAlign.LEFT,true,FilterUtil.getUILabelDropShadowFilter01());
      }
      
      public static function defaultSmallPopupTitle(param1:UILabel, param2:String = "left") : void
      {
         createLabelFormat(param1,14,15395562,param2,true,FilterUtil.getUILabelDropShadowFilter01());
      }
      
      public static function friendsItemLabel(param1:UILabel, param2:Number = 16777215) : void
      {
         createLabelFormat(param1,14,param2,TextFormatAlign.LEFT,true,FilterUtil.getUILabelDropShadowFilter01());
      }
      
      public static function guildInfoLabel(param1:UILabel, param2:int = 14, param3:Number = 16777215, param4:String = "left") : void
      {
         createLabelFormat(param1,param2,param3,param4,true,FilterUtil.getUILabelDropShadowFilter01());
      }
      
      public static function characterViewNameLabel(param1:UILabel, param2:int = 18) : void
      {
         createLabelFormat(param1,param2,11776947,TextFormatAlign.LEFT,true,[new DropShadowFilter(0,0,0)]);
      }
      
      public static function characterFameNameLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,18,16777215,TextFormatAlign.LEFT,true,FilterUtil.getUILabelDropShadowFilter01());
      }
      
      public static function characterFameInfoLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,12,9211020,TextFormatAlign.LEFT,true,FilterUtil.getUILabelDropShadowFilter01());
      }
      
      public static function characterToolTipLabel(param1:UILabel, param2:Number) : void
      {
         createLabelFormat(param1,12,param2,TextFormatAlign.LEFT,true);
      }
      
      public static function coinsFieldLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,18,16777215,TextFormatAlign.RIGHT);
      }
      
      public static function numberSpinnerLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,18,15395562,TextFormatAlign.CENTER);
      }
      
      public static function shopTag(param1:UILabel) : void
      {
         createLabelFormat(param1,12,16777215,TextFormatAlign.LEFT,true,FilterUtil.getUILabelDropShadowFilter02());
      }
      
      public static function popupTag(param1:UILabel) : void
      {
         createLabelFormat(param1,24,16777215,TextFormatAlign.LEFT,true,FilterUtil.getUILabelDropShadowFilter02());
      }
      
      public static function shopBoxTitle(param1:UILabel) : void
      {
         createLabelFormat(param1,14,15395562,TextFormatAlign.LEFT);
      }

      public static function defaultModalTitle(param1:UILabel) : void
      {
         createLabelFormat(param1,18,16777215,TextFormatAlign.LEFT,false,FilterUtil.getUILabelDropShadowFilter01());
      }

      public static function defaultModalTitleSmaller(param1:UILabel) : void
      {
         createLabelFormat(param1,15,16777215,TextFormatAlign.LEFT,false,FilterUtil.getUILabelDropShadowFilter01());
      }

      public static function defaultTextModalText(param1:UILabel) : void
      {
         createLabelFormat(param1,14,16777215,TextFormatAlign.CENTER);
      }
      
      public static function mysteryBoxContentInfo(param1:UILabel) : void
      {
         createLabelFormat(param1,12,10066329,TextFormatAlign.CENTER,true);
      }
      
      public static function mysteryBoxContentItemName(param1:UILabel) : void
      {
         createLabelFormat(param1,14,16777215,TextFormatAlign.LEFT);
      }
      
      public static function popupEndsIn(param1:UILabel) : void
      {
         createLabelFormat(param1,24,16684800,TextFormatAlign.LEFT,true,FilterUtil.getUILabelComboFilter());
      }
      
      public static function mysteryBoxEndsIn(param1:UILabel) : void
      {
         createLabelFormat(param1,12,16684800,TextFormatAlign.LEFT,true,FilterUtil.getUILabelComboFilter());
      }
      
      public static function popupStartsIn(param1:UILabel) : void
      {
         createLabelFormat(param1,24,16728576,TextFormatAlign.LEFT,true,FilterUtil.getUILabelComboFilter());
      }
      
      public static function mysteryBoxStartsIn(param1:UILabel) : void
      {
         createLabelFormat(param1,12,16728576,TextFormatAlign.LEFT,true,FilterUtil.getUILabelComboFilter());
      }
      
      public static function priceButtonLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,18,15395562,TextFormatAlign.LEFT,false,FilterUtil.getUILabelDropShadowFilter01());
      }
      
      public static function originalPriceButtonLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,16,15395562,TextFormatAlign.LEFT,false,FilterUtil.getUILabelComboFilter());
      }
      
      public static function defaultInactiveTab(param1:UILabel) : void
      {
         createLabelFormat(param1,14,6381921,TextFormatAlign.LEFT,true);
      }
      
      public static function defaultActiveTab(param1:UILabel) : void
      {
         createLabelFormat(param1,14,15395562,TextFormatAlign.LEFT,true,FilterUtil.getUILabelDropShadowFilter02());
      }
      
      public static function mysteryBoxVaultInfo(param1:UILabel) : void
      {
         createLabelFormat(param1,14,16684800,TextFormatAlign.LEFT,true,FilterUtil.getUILabelDropShadowFilter02());
      }
      
      public static function currentFameLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,22,16760388,TextFormatAlign.LEFT,true);
      }
      
      public static function deathFameLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,18,15395562,TextFormatAlign.LEFT,true);
      }
      
      public static function deathFameCount(param1:UILabel) : void
      {
         createLabelFormat(param1,18,16762880,TextFormatAlign.RIGHT,true);
      }
      
      public static function tierLevelLabel(param1:UILabel, param2:int = 12, param3:Number = 16777215, param4:String = "right") : void
      {
         createLabelFormat(param1,param2,param3,param4,true);
      }
      
      public static function questRefreshLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,14,10724259,TextFormatAlign.CENTER,true);
      }
      
      public static function questCompletedLabel(param1:UILabel, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:Number = !!param2?Number(Number(3971635)):Number(Number(13224136));
         createLabelFormat(param1,16,_loc4_,TextFormatAlign.LEFT,true);
      }
      
      public static function questNameLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,20,15241232,TextFormatAlign.CENTER,true);
      }
      
      public static function notificationLabel(param1:UILabel, param2:int, param3:Number, param4:String, param5:Boolean) : void
      {
         createLabelFormat(param1,param2,param3,param4,param5,FilterUtil.getUILabelDropShadowFilter01());
      }
      
      private static function applyTextFormat(param1:TextFormat, param2:UILabel) : void
      {
         param2.defaultTextFormat = param1;
         param2.setTextFormat(param1);
      }
      
      public static function createTextFormat(param1:int, param2:uint, param3:String, param4:Boolean) : TextFormat
      {
         var _loc5_:TextFormat = new TextFormat();
         _loc5_.color = param2;
         _loc5_.bold = param4;
         //_loc5_.font = FontModel.DEFAULT_FONT_NAME;
         _loc5_.size = param1;
         _loc5_.align = param3;
         return _loc5_;
      }
      
      public static function questDescriptionLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,16,13224136,TextFormatAlign.CENTER);
      }
      
      public static function questRewardLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,16,16777215,TextFormatAlign.CENTER,true);
      }
      
      public static function questChoiceLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,14,13224136,TextFormatAlign.CENTER);
      }
      
      public static function questButtonCompleteLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,18,16777215,TextFormatAlign.CENTER,true);
      }
      
      public static function questNameListLabel(param1:UILabel, param2:uint) : void
      {
         createLabelFormat(param1,14,param2,TextFormatAlign.LEFT,true);
      }
      
      public static function petNameLabel(param1:UILabel, param2:uint) : void
      {
         createLabelFormat(param1,18,param2,TextFormatAlign.CENTER,true);
      }
      
      public static function petNameLabelSmall(param1:UILabel, param2:uint) : void
      {
         createLabelFormat(param1,14,param2,TextFormatAlign.CENTER,true);
      }
      
      public static function petFamilyLabel(param1:UILabel, param2:uint) : void
      {
         createLabelFormat(param1,14,param2,TextFormatAlign.CENTER,true,FilterUtil.getUILabelComboFilter());
      }
      
      public static function petInfoLabel(param1:UILabel, param2:uint) : void
      {
         createLabelFormat(param1,12,param2,TextFormatAlign.CENTER);
      }
      
      public static function petStatLabelLeft(param1:UILabel, param2:uint) : void
      {
         createLabelFormat(param1,12,param2,TextFormatAlign.LEFT);
      }
      
      public static function petStatLabelRight(param1:UILabel, param2:uint, param3:Boolean = false) : void
      {
         createLabelFormat(param1,12,param2,TextFormatAlign.RIGHT,param3);
      }
      
      public static function petStatLabelLeftSmall(param1:UILabel, param2:uint) : void
      {
         createLabelFormat(param1,11,param2,TextFormatAlign.LEFT);
      }
      
      public static function petStatLabelRightSmall(param1:UILabel, param2:uint, param3:Boolean = false) : void
      {
         createLabelFormat(param1,11,param2,TextFormatAlign.RIGHT,param3);
      }
      
      public static function fusionStrengthLabel(param1:UILabel, param2:uint, param3:int) : void
      {
         var _loc4_:Number = param3 != 0?Number(Number(param2)):Number(Number(16777215));
         createLabelFormat(param1,14,_loc4_,TextFormatAlign.CENTER,true);
      }
      
      public static function feedPetInfo(param1:UILabel) : void
      {
         createLabelFormat(param1,14,16777215,TextFormatAlign.CENTER,true);
      }
      
      public static function wardrobeCollectionLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,12,16777215,TextFormatAlign.CENTER,true);
      }
      
      public static function petYardRarity(param1:UILabel) : void
      {
         createLabelFormat(param1,12,10658466,TextFormatAlign.CENTER,true);
      }
      
      public static function petYardUpgradeInfo(param1:UILabel) : void
      {
         createLabelFormat(param1,12,9211020,TextFormatAlign.CENTER,true);
      }
      
      public static function petYardUpgradeRarityInfo(param1:UILabel) : void
      {
         createLabelFormat(param1,14,16777215,TextFormatAlign.CENTER,true);
      }
      
      public static function newAbilityInfo(param1:UILabel) : void
      {
         createLabelFormat(param1,12,10066329,TextFormatAlign.CENTER,true);
      }
      
      public static function newAbilityName(param1:UILabel) : void
      {
         createLabelFormat(param1,18,8971493,TextFormatAlign.CENTER,true);
      }
      
      public static function newSkinHatched(param1:UILabel) : void
      {
         createLabelFormat(param1,14,9671571,TextFormatAlign.CENTER,true);
      }
      
      public static function infoTooltipText(param1:UILabel, param2:uint) : void
      {
         createLabelFormat(param1,14,param2,TextFormatAlign.LEFT);
      }
      
      public static function newSkinLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,9,0,TextFormatAlign.CENTER,true);
      }
      
      public static function donateAmountLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,18,15395562,TextFormatAlign.RIGHT,false);
      }
      
      public static function pointsAmountLabel(param1:UILabel) : void
      {
         createLabelFormat(param1,18,15395562,TextFormatAlign.CENTER,false);
      }
   }
}
