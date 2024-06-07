package kabam.rotmg.ui.view {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.GraphicsUtil;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.filters.BitmapFilterQuality;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.geom.ColorTransform;
import flash.utils.flash_proxy;
import flash.utils.getTimer;

public class BossHealthBar extends Sprite {

    private var overlay_:Sprite;
    private var background:Sprite;
    private var foreground:Sprite;
    private var foregroundMask:Sprite;
    private var portrait_:Bitmap;
    private var go_:GameObject;
    private var timeSinceNull_:int;
    private var hpText_:SimpleText;
    private var dmgText_:SimpleText;
    private var nameText_:SimpleText;
    private var displayName:String;

    private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(0,0.6);
    private var lineStyle_:GraphicsStroke = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
    private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0, 0.45);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,backgroundFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];

    private var hpBarFill_:GraphicsSolidFill = new GraphicsSolidFill(0x20FF20, 0.8);
    private var hpGraphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[hpBarFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];

    public function BossHealthBar() {
        this.overlay_ = new Sprite();
        this.makeOverlay();

        this.foreground = new Sprite();
        this.makeForeground();
        this.foregroundMask = this.hiddenForeground();

        this.background = new Sprite();
        this.makeBackground();

        this.foreground.mask = this.foregroundMask;
        this.displayName = "";

        this.portrait_ = new Bitmap();
        this.portrait_.filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];

        this.hpText_ = new SimpleText(16,16777215,false,0,0);
        this.hpText_.setBold(true);
        this.hpText_.filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];

        this.dmgText_ = new SimpleText(12, 16777215,false,0,0);
        this.dmgText_.setBold(true);
        this.dmgText_.filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];

        this.nameText_ = new SimpleText(13, 16777215,false,0,0);
        this.nameText_.setBold(true);
        this.nameText_.filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];

        addChild(this.overlay_);
        addChild(this.background);
        addChild(this.foreground);
        addChild(this.foregroundMask);
        addChild(this.portrait_);
        addChild(this.hpText_);
        addChild(this.dmgText_);
        addChild(this.nameText_);
        mouseEnabled = false;
        mouseChildren = false;

        this.timeSinceNull_ = getTimer();
    }

    public function makeOverlay():void
    {
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0,0,380, 62,8,[1,1,1,1],this.path_);
        this.overlay_.graphics.drawGraphicsData(this.graphicsData_);
    }

    public function makeForeground():void
    {
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(1,1,298, 34,8,[1,1,1,1],this.path_);
        this.foreground.graphics.drawGraphicsData(this.hpGraphicsData_);
    }

    public function makeBackground():void
    {
        GraphicsUtil.clearPath(this.path_);
        GraphicsUtil.drawCutEdgeRect(0,0,300, 36,8,[1,1,1,1],this.path_);
        this.background.graphics.drawGraphicsData(this.graphicsData_);
    }

    public function hiddenForeground():Sprite
    {
        var s:Sprite = new Sprite();
        s.graphics.clear();
        s.graphics.beginFill(0, 0);
        s.graphics.drawRect(1,1,298, 36);
        s.graphics.endFill();
        return s;
    }

    private var damagePercentage_:Number;

    public function setDamageInflicted(percentage:Number, go:GameObject = null):void{
        if (go != this.go_)
            return;
        if(percentage == -1){
            this.damagePercentage_ = 0;
            this.dmgText_.text = "";
        }
        else{
            this.damagePercentage_ = percentage;
            this.dmgText_.text = Math.floor(percentage) + "%";
        }
        this.dmgText_.updateMetrics();

        this.dmgText_.x = this.background.x + this.background.width / 2 - this.dmgText_.width / 2;
        this.dmgText_.y = 38;
    }

    private function getPortrait(go:GameObject):BitmapData {
        var portraitTexture:BitmapData = go.props_.portrait_ != null ? go.props_.portrait_.getTexture() : go.texture_;
        var size:int = 100 / (portraitTexture.width / 8);
        return GlowRedrawer.outlineGlow(TextureRedrawer.resize(portraitTexture, go.mask_, size, true, go.tex1Id_, go.tex2Id_), 0, 0);
    }

    public function setGameObject(go:GameObject):void {
        if (go_ == go) {
            return;
        }
        go_ = go;

        var isNull:Boolean = go == null;
        if (!isNull) {
            this.portrait_.bitmapData = isNull ? null : getPortrait(go);
            this.background.x = this.portrait_.width + 2;
            this.foreground.x = this.foregroundMask.x = this.portrait_.width + 2;
            this.background.y = this.foregroundMask.y = this.foreground.y = 20;

            switch (go.glowColorEnemy_)
            {
                case 0xD865A5:
                    this.nameText_.htmlText = "<font color=\"#D865A5\">Legendary</font> " + go.name_;
                    break;
                case 0xC183AF:
                    this.nameText_.htmlText = "<font color=\"#C183AF\">Epic</font> " + go.name_;
                    break;
                case 0x82D9BC:
                    this.nameText_.htmlText = "<font color=\"#82D9BC\">Rare</font> " + go.name_;
                    break;
                default:
                    this.nameText_.htmlText = go.name_;

            }
            this.nameText_.updateMetrics();
            this.nameText_.x = this.background.x + this.background.width / 2 - this.nameText_.width / 2;
            this.nameText_.y = 2;
            visible = true;
        }
    }

    public function draw():void {
        if (this.go_ == null || this.go_.rtHp_ <= 0) {
            visible = false;
            return;
        }

        this.hpText_.text = this.go_.hp_ + "/" + this.go_.maxHP_;
        this.hpText_.updateMetrics();
        this.hpText_.x = this.background.x + this.background.width / 2 - this.hpText_.width / 2;
        if (this.dmgText_.text == "")
            this.hpText_.y = this.background.y + this.background.height / 2 - this.hpText_.height / 2 - 1;
        else
            this.hpText_.y = 22;

        if (go_.isInvulnerable()) {
            this.background.transform.colorTransform = new ColorTransform(50 / 255, 100 / 255,  190 / 255);
        } else if (go_.isArmored() && !go_.isArmorBroken()) {
            this.background.transform.colorTransform = new ColorTransform(85 / 255, 60 / 255, 50 / 255);
        } else {
            this.background.transform.colorTransform = new ColorTransform(0, 1, 0);
        }

        if(go_.hp_ > go_.rtHp_)
            go_.rtHp_ = go_.hp_;
        this.foregroundMask.width = (this.go_.rtHp_ / this.go_.maxHP_) * 298;
    }
}
}