package com.company.assembleegameclient.util {
import com.company.util.MoreColorUtil;

import flash.filters.BitmapFilterQuality;
import flash.filters.ColorMatrixFilter;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;

public class FilterUtil {

    private static const UILABEL_DROP_SHADOW_FILTER_01:Array = [new DropShadowFilter(0, 90, 212992, 0.6, 4, 4)];
    private static const UILABEL_DROP_SHADOW_FILTER_02:Array = [new DropShadowFilter(1, 90, 0, 0.6, 4, 4)];
    private static const UILABEL_COMBO_FILTER:Array = [new DropShadowFilter(1, 90, 0, 1, 2, 2), new DropShadowFilter(0, 90, 0, 0.4, 4, 4, 1, BitmapFilterQuality.HIGH)];
    private static const STANDARD_DROP_SHADOW_FILTER:Array = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
    private static const STANDARD_OUTLINE_FILTER:Array = [new GlowFilter(0, 1, 2, 2, 10, 1)];
    private static const GREY_COLOR_FILTER:Array = [new ColorMatrixFilter(MoreColorUtil.singleColorFilterMatrix(3552822))];
    private static const DARK_GREY_COLOR_FILTER:Array = [new ColorMatrixFilter(MoreColorUtil.singleColorFilterMatrix(1842204))];
    private static const DEFAULT_TEXT_SHADOW_FILTER:Array = [new DropShadowFilter(0,0,0,0.5,12,12)];


    public function FilterUtil() {
        super();
    }

    public static function getUILabelDropShadowFilter01():Array {
        return UILABEL_DROP_SHADOW_FILTER_01;
    }

    public static function getUILabelDropShadowFilter02():Array {
        return UILABEL_DROP_SHADOW_FILTER_02;
    }

    public static function getUILabelComboFilter():Array {
        return UILABEL_COMBO_FILTER;
    }

    public static function getStandardDropShadowFilter():Array {
        return STANDARD_DROP_SHADOW_FILTER;
    }

    public static function getTextOutlineFilter():Array {
        return STANDARD_OUTLINE_FILTER;
    }

    public static function getGreyColorFilter():Array {
        return GREY_COLOR_FILTER;
    }

    public static function getDarkGreyColorFilter():Array {
        return DARK_GREY_COLOR_FILTER;
    }

    public static function getTextShadowFilter():Array {
        return DEFAULT_TEXT_SHADOW_FILTER;
    }
}
}
