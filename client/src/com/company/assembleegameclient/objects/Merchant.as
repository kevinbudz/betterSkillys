package com.company.assembleegameclient.objects {
import com.company.assembleegameclient.constants.InventoryOwnerTypes;
import com.company.assembleegameclient.map.Camera;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.ui.SimpleText;
import com.company.util.IntPoint;
import com.gskinner.motion.GTween;
import com.gskinner.motion.easing.Sine;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.AddSpeechBalloonVO;
import kabam.rotmg.game.signals.AddSpeechBalloonSignal;

public class Merchant extends SellableObject implements IInteractiveObject {

    private static const NONE_MESSAGE:int = 0;

    private static const NEW_MESSAGE:int = 1;

    private static const MINS_LEFT_MESSAGE:int = 2;

    private static const ITEMS_LEFT_MESSAGE:int = 3;

    private static const DISCOUNT_MESSAGE:int = 4;

    private static const T:Number = 1;

    private static const DOSE_MATRIX:Matrix = function ():Matrix {
        var m:* = new Matrix();
        m.translate(10, 5);
        return m;
    }();

    public function Merchant(objectXML:XML) {
        this.ct_ = new ColorTransform(1, 1, 1, 1);
        this.addSpeechBalloon = StaticInjectorContext.getInjector().getInstance(AddSpeechBalloonSignal);
        super(objectXML);
        isInteractive_ = true;
    }
    public var merchandiseType_:int = -1;
    public var count_:int = -1;
    public var minsLeft_:int = -1;
    public var discount_:int = 0;
    public var merchandiseTexture_:BitmapData = null;
    public var untilNextMessage_:int = 0;
    public var alpha_:Number = 1.0;
    private var addSpeechBalloon:AddSpeechBalloonSignal;
    private var firstUpdate_:Boolean = true;
    private var messageIndex_:int = 0;
    private var ct_:ColorTransform;

    override public function setPrice(price:int):void {
        super.setPrice(price);
        this.untilNextMessage_ = 0;
    }

    override public function setRankReq(rankReq:int):void {
        super.setRankReq(rankReq);
        this.untilNextMessage_ = 0;
    }

    override public function addTo(map:Map, x:Number, y:Number):Boolean {
        if (!super.addTo(map, x, y)) {
            return false;
        }
        map.merchLookup_[new IntPoint(x_, y_)] = this;
        return true;
    }

    override public function removeFromMap():void {
        var p:IntPoint = new IntPoint(x_, y_);
        if (map_.merchLookup_[p] == this) {
            map_.merchLookup_[p] = null;
        }
        super.removeFromMap();
    }

    override public function update(time:int, dt:int):Boolean {
        var tween0:GTween = null;
        var tween1:GTween = null;

        super.update(time, dt);

        if (this.firstUpdate_) {
            if (this.minsLeft_ == 2147483647) {
                this.alpha_ = 0;
                tween0 = new GTween(this, 0.5 * T, {"alpha_": 1});
                tween1 = new GTween(this, 0.5 * T, {"size_": 150}, {"ease": Sine.easeOut});
                tween1.nextTween = new GTween(this, 0.5 * T, {"size_": 100}, {"ease": Sine.easeIn});
                tween1.nextTween.paused = true;
            }
            this.firstUpdate_ = false;
        }
        this.untilNextMessage_ = this.untilNextMessage_ - dt;
        if (this.untilNextMessage_ > 0) {
            return true;
        }
        this.untilNextMessage_ = 5000;
        var messages:Vector.<int> = new Vector.<int>();
        if (this.minsLeft_ == 2147483647) {
            messages.push(NEW_MESSAGE);
        }
        else if (this.minsLeft_ >= 0 && this.minsLeft_ <= 5) {
            messages.push(MINS_LEFT_MESSAGE);
        }
        if (this.count_ >= 1 && this.count_ <= 2) {
            messages.push(ITEMS_LEFT_MESSAGE);
        }
        if (this.discount_ > 0) {
            messages.push(DISCOUNT_MESSAGE);
        }
        if (messages.length == 0) {
            return true;
        }
        this.messageIndex_ = ++this.messageIndex_ % messages.length;
        var message:int = messages[this.messageIndex_];
        this.addSpeechBalloon.dispatch(this.getSpeechBalloon(message));
        return true;
    }

    override public function soldObjectName():String {
        return ObjectLibrary.typeToDisplayId_[this.merchandiseType_];
    }

    override public function soldObjectInternalName():String {
        var objectXML:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
        return objectXML.@id.toString();
    }

    override public function getTooltip():ToolTip {
        var toolTip:ToolTip = new EquipmentToolTip(this.merchandiseType_, map_.player_, -1, InventoryOwnerTypes.NPC);
        return toolTip;
    }

    override public function getIcon():BitmapData {
        var tempText:SimpleText = null;
        var texture:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_, 80, true);
        var eqXML:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
        if (eqXML.hasOwnProperty("Doses")) {
            texture = texture.clone();
            tempText = new SimpleText(12, 16777215, false, 0, 0);
            tempText.text = String(eqXML.Doses);
            tempText.updateMetrics();
            texture.draw(tempText, DOSE_MATRIX);
        }
        else if (eqXML && eqXML.hasOwnProperty("Quantity")) {
            texture = texture.clone();
            tempText = new SimpleText(12, 16777215, false, 0, 0);
            tempText.text = String(eqXML.Quantity);
            tempText.updateMetrics();
            texture.draw(tempText, DOSE_MATRIX);
        }
        return texture;
    }

    override protected function getTexture(camera:Camera, time:int):BitmapData {
        if (this.alpha_ == 1 && size_ == 100) {
            return this.merchandiseTexture_;
        }
        var tempTexture:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_, size_, false, false);
        if (this.alpha_ != 1) {
            this.ct_.alphaMultiplier = this.alpha_;
            tempTexture.colorTransform(tempTexture.rect, this.ct_);
        }
        return tempTexture;
    }

    public function getSpeechBalloon(message:int):AddSpeechBalloonVO {
        var text:String = null;
        var backColor:uint = 0;
        var outlineColor:uint = 0;
        var textColor:uint = 0;
        switch (message) {
            case NEW_MESSAGE:
                text = "New!";
                backColor = 15132390;
                outlineColor = 16777215;
                textColor = 5931045;
                break;
            case MINS_LEFT_MESSAGE:
                if (this.minsLeft_ == 0) {
                    text = "Going soon!";
                }
                else if (this.minsLeft_ == 1) {
                    text = "Going in 1 min!";
                }
                else {
                    text = "Going in " + this.minsLeft_ + " mins!";
                }
                backColor = 5973542;
                outlineColor = 16549442;
                textColor = 16549442;
                break;
            case ITEMS_LEFT_MESSAGE:
                text = this.count_ + " left!";
                backColor = 5973542;
                outlineColor = 16549442;
                textColor = 16549442;
                break;
            case DISCOUNT_MESSAGE:
                text = this.discount_ + "% off!";
                backColor = 6324275;
                outlineColor = 16777103;
                textColor = 16777103;
                break;
            default:
                return null;
        }
        return (new AddSpeechBalloonVO(this, text.toString(), "", false, false, backColor, 1, outlineColor, 1, textColor, 6, true, false));
    }

    public function getTex1Id(defaultTexId:int):int {
        var objXML:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
        if (objXML == null) {
            return defaultTexId;
        }
        if (objXML.Activate == "Dye" && objXML.hasOwnProperty("Tex1")) {
            return int(objXML.Tex1);
        }
        return defaultTexId;
    }

    public function getTex2Id(defaultTexId:int):int {
        var objXML:XML = ObjectLibrary.xmlLibrary_[this.merchandiseType_];
        if (objXML == null) {
            return defaultTexId;
        }
        if (objXML.Activate == "Dye" && objXML.hasOwnProperty("Tex2")) {
            return int(objXML.Tex2);
        }
        return defaultTexId;
    }

    public function setMerchandiseType(merchandiseType:int):void {
        this.merchandiseType_ = merchandiseType;
        this.merchandiseTexture_ = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_, 100, false);
    }
}
}
