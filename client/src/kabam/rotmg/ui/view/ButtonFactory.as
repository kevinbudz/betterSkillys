package kabam.rotmg.ui.view
{
import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.utils.colors.GreyScale;

public class ButtonFactory
{


    public function ButtonFactory()
    {
        super();
    }

    public static function getPlayButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"play",100,false);
        return _loc1_;
    }

    public static function getTextureEditorButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"Texture Editor",150);
        return _loc1_;
    }

    public static function getClassesButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"classes");
        return _loc1_;
    }

    public static function getMainButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"main");
        return _loc1_;
    }

    public static function getBattlePassButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"Battle Pass");
        return _loc1_;
    }

    public static function getBackButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"back");
        return _loc1_;
    }

    public static function getAccountButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"account");
        return _loc1_;
    }

    public static function getLegendsButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"legends");
        return _loc1_;
    }

    public static function getServersButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"servers");
        return _loc1_;
    }

    public static function getSupportButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"support");
        return _loc1_;
    }

    public static function getEditorButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"editor");
        return _loc1_;
    }

    public static function getQuitButton() : SliceScalingButton
    {
        var _loc1_:SliceScalingButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
        setDefault(_loc1_,"quit");
        return _loc1_;
    }

    private static function setDefault(param1:SliceScalingButton, param2:String, param3:int = 100, param4:Boolean = true) : void
    {
        param1.setLabel(param2,DefaultLabelFormat.questButtonCompleteLabel);
        param1.x = 0;
        param1.y = 0;
        param1.width = param3;
        if(param4)
        {
            GreyScale.greyScaleToDisplayObject(param1,true);
        }
    }
}
}
