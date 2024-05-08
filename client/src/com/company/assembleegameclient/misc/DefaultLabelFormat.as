package com.company.assembleegameclient.misc
{
import flash.filters.BitmapFilterQuality;
import flash.filters.DropShadowFilter;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


public class DefaultLabelFormat
{


    public function DefaultLabelFormat()
    {
        super();
    }

    public static function defaultButtonLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16777215;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 16;
        _loc2_.align = TextFormatAlign.CENTER;
        applyTextFromat(_loc2_,param1);
    }

    public static function defaultPopupTitle(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 15395562;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 32;
        param1.filters = [new DropShadowFilter(0,90,212992,0.6,4,4)];
        applyTextFromat(_loc2_,param1);
    }

    public static function defaultSmallPopupTitle(param1:UILabel, param2:String = "left") : void
    {
        var _loc3_:TextFormat = createTextFormat(14,15395562,param2,true);
        param1.filters = [new DropShadowFilter(0,90,212992,0.6,4,4)];
        applyTextFromat(_loc3_,param1);
    }

    public static function friendsItemLabel(param1:UILabel, param2:Number = 16777215) : void
    {
        var _loc3_:TextFormat = createTextFormat(14,param2,TextFormatAlign.LEFT,true);
        param1.filters = [new DropShadowFilter(0,90,212992,0.6,4,4)];
        applyTextFromat(_loc3_,param1);
    }

    public static function guildInfoLabel(param1:UILabel, param2:int = 14, param3:Number = 16777215, param4:String = "left") : void
    {
        var _loc5_:TextFormat = null;
        _loc5_ = createTextFormat(param2,param3,param4,true);
        param1.filters = [new DropShadowFilter(0,90,212992,0.6,4,4)];
        applyTextFromat(_loc5_,param1);
    }

    public static function characterViewNameLabel(param1:UILabel, param2:int = 18) : void
    {
        var _loc3_:TextFormat = null;
        _loc3_ = createTextFormat(param2,11776947,TextFormatAlign.LEFT,true);
        param1.filters = [new DropShadowFilter(0,0,0)];
        applyTextFromat(_loc3_,param1);
    }

    public static function characterFameNameLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16777215;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 18;
        param1.filters = [new DropShadowFilter(0,90,212992,0.6,4,4)];
        applyTextFromat(_loc2_,param1);
    }

    public static function characterFameInfoLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 9211020;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 12;
        param1.filters = [new DropShadowFilter(0,90,212992,0.6,4,4)];
        applyTextFromat(_loc2_,param1);
    }

    public static function coinsFieldLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16777215;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 18;
        _loc2_.align = "right";
        applyTextFromat(_loc2_,param1);
    }

    public static function numberSpinnerLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 15395562;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 18;
        _loc2_.align = TextFormatAlign.CENTER;
        applyTextFromat(_loc2_,param1);
    }

    public static function shopTag(param1:UILabel) : void
    {
        var _loc2_:TextFormat = createTextFormat(12,16777215,TextFormatAlign.LEFT,true);
        param1.filters = [new DropShadowFilter(1,90,0,0.6,4,4)];
        applyTextFromat(_loc2_,param1);
    }

    public static function popupTag(param1:UILabel) : void
    {
        var _loc2_:TextFormat = createTextFormat(24,16777215,TextFormatAlign.LEFT,true);
        param1.filters = [new DropShadowFilter(1,90,0,0.6,4,4)];
        applyTextFromat(_loc2_,param1);
    }

    public static function shopBoxTitle(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 15395562;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 14;
        applyTextFromat(_loc2_,param1);
    }

    public static function backLaterLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16777215;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 14;
        _loc2_.bold = true;
        _loc2_.align = TextFormatAlign.CENTER;
        applyTextFromat(_loc2_,param1);
    }

    public static function defaultModalTitle(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16777215;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 18;
        param1.filters = [new DropShadowFilter(0,90,212992,0.6,4,4)];
        applyTextFromat(_loc2_,param1);
    }

    public static function defaultTextModalText(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16777215;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 14;
        _loc2_.align = TextFormatAlign.CENTER;
        applyTextFromat(_loc2_,param1);
    }

    public static function mysteryBoxContentTitle(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16777215;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 14;
        applyTextFromat(_loc2_,param1);
    }

    public static function mysteryBoxContentInfo(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 10066329;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 12;
        _loc2_.bold = true;
        _loc2_.align = TextFormatAlign.CENTER;
        applyTextFromat(_loc2_,param1);
    }

    public static function mysteryBoxContentItemName(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16777215;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 14;
        applyTextFromat(_loc2_,param1);
    }

    public static function popupEndsIn(param1:UILabel) : void
    {
        var _loc2_:TextFormat = createTextFormat(24,16684800,TextFormatAlign.LEFT,true);
        param1.filters = [new DropShadowFilter(1,90,0,1,2,2),new DropShadowFilter(0,90,0,0.4,4,4,1,BitmapFilterQuality.HIGH)];
        applyTextFromat(_loc2_,param1);
    }

    public static function mysteryBoxEndsIn(param1:UILabel) : void
    {
        var _loc2_:TextFormat = createTextFormat(12,16684800,TextFormatAlign.LEFT,true);
        param1.filters = [new DropShadowFilter(1,90,0,1,2,2),new DropShadowFilter(0,90,0,0.4,0,0,3,BitmapFilterQuality.HIGH)];
        applyTextFromat(_loc2_,param1);
    }

    public static function priceButtonLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 15395562;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 18;
        param1.filters = [new DropShadowFilter(0,90,212992,0.6,4,4)];
        applyTextFromat(_loc2_,param1);
    }

    public static function originalPriceButtonLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 15395562;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 16;
        param1.filters = [new DropShadowFilter(1,90,0,1,2,2),new DropShadowFilter(0,90,0,0.4,4,4,1,BitmapFilterQuality.HIGH)];
        applyTextFromat(_loc2_,param1);
    }

    public static function defaultInactiveTab(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 6381921;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 14;
        applyTextFromat(_loc2_,param1);
    }

    public static function defaultActiveTab(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 15395562;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 14;
        param1.filters = [new DropShadowFilter(1,90,0,0.5,4,4)];
        applyTextFromat(_loc2_,param1);
    }

    public static function mysteryBoxVaultInfo(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16684800;
        //_loc2_.font =FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 14;
        _loc2_.bold = true;
        param1.filters = [new DropShadowFilter(1,90,0,0.5,4,4)];
        applyTextFromat(_loc2_,param1);
    }

    public static function defaultBoldLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 15395562;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 18;
        _loc2_.align = TextFormatAlign.LEFT;
        applyTextFromat(_loc2_,param1);
    }

    public static function currentFameLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16760388;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 22;
        _loc2_.align = TextFormatAlign.LEFT;
        applyTextFromat(_loc2_,param1);
    }

    public static function deathFameLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 15395562;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 18;
        _loc2_.align = TextFormatAlign.LEFT;
        applyTextFromat(_loc2_,param1);
    }

    public static function deathFameCount(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 16762880;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 18;
        _loc2_.align = TextFormatAlign.RIGHT;
        applyTextFromat(_loc2_,param1);
    }

    public static function tierLevelLabel(param1:UILabel, param2:int = 12, param3:Number = 16777215, param4:String = "right") : void
    {
        var _loc5_:TextFormat = new TextFormat();
        _loc5_.color = param3;
        _loc5_.bold = true;
        _loc5_.font = "Myriad Pro";
        _loc5_.size = param2;
        _loc5_.align = param4;
        applyTextFromat(_loc5_,param1);
    }

    public static function questRefreshLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 10724259;
        _loc2_.bold = true;
       // _loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 14;
        _loc2_.align = TextFormatAlign.CENTER;
        applyTextFromat(_loc2_,param1);
    }

    public static function questCompletedLabel(param1:UILabel, param2:Boolean, param3:Boolean) : void
    {
        var _loc4_:TextFormat = new TextFormat();
        _loc4_.color = param2?3971635:13224136;
        _loc4_.bold = true;
        //_loc4_.font = FontModel.DEFAULT_FONT_NAME;
        _loc4_.size = 16;
        _loc4_.align = TextFormatAlign.LEFT;
        applyTextFromat(_loc4_,param1);
    }

    public static function questNameLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = new TextFormat();
        _loc2_.color = 15241232;
        _loc2_.bold = true;
        //_loc2_.font = FontModel.DEFAULT_FONT_NAME;
        _loc2_.size = 20;
        _loc2_.align = TextFormatAlign.CENTER;
        applyTextFromat(_loc2_,param1);
    }

    private static function applyTextFromat(param1:TextFormat, param2:UILabel) : void
    {
        param2.defaultTextFormat = param1;
        param2.setTextFormat(param1);
    }

    public static function createTextFormat(param1:int, param2:uint, param3:String, param4:Boolean) : TextFormat
    {
        var _loc5_:TextFormat = new TextFormat();
        _loc5_.color = param2;
        _loc5_.bold = param4;
        _loc5_.font = "Myriad Pro";
        _loc5_.size = param1;
        _loc5_.align = param3;
        return _loc5_;
    }

    public static function questDescriptionLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = createTextFormat(16,13224136,TextFormatAlign.CENTER,false);
        applyTextFromat(_loc2_,param1);
    }

    public static function questRewardLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = createTextFormat(16,16777215,TextFormatAlign.CENTER,true);
        applyTextFromat(_loc2_,param1);
    }

    public static function questChoiceLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = createTextFormat(14,13224136,TextFormatAlign.CENTER,false);
        applyTextFromat(_loc2_,param1);
    }

    public static function questButtonCompleteLabel(param1:UILabel) : void
    {
        var _loc2_:TextFormat = createTextFormat(18,16777215,TextFormatAlign.CENTER,true);
        applyTextFromat(_loc2_,param1);
    }

    public static function questNameListLabel(param1:UILabel, param2:uint) : void
    {
        var _loc3_:TextFormat = createTextFormat(14,param2,TextFormatAlign.LEFT,true);
        applyTextFromat(_loc3_,param1);
    }
}
}
