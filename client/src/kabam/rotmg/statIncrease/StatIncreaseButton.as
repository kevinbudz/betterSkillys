package kabam.rotmg.statIncrease {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.LineBreakDesign;
import com.company.assembleegameclient.ui.TextButton;
import com.company.rotmg.graphics.DeleteXGraphic;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.GraphicsUtil;
import com.company.util.MoreObjectUtil;
import com.gskinner.motion.GTween;

import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.display.CapsStyle;
import flash.display.Graphics;

import flash.display.GraphicsPath;

import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;

import flash.display.Sprite;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.text.TextFieldAutoSize;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.popups.header.PopupHeader;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;

import kabam.rotmg.account.core.Account;
import kabam.rotmg.appengine.api.AppEngineClient;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.messaging.impl.incoming.Text;
import kabam.rotmg.statIncrease.StatIncreaseView;

import org.osflash.signals.Signal;

public class StatIncreaseButton extends Sprite {

    private var host:StatIncreaseView;
    private var statIndex:int;

    private var container:Sprite;
    private var icon:Bitmap;
    private var titleText:SimpleText;

    private var plusOneButton:TextButton;
    private var plusTenButton:TextButton;

    public static const statIndexes:Array = [38, 39, 52, 53, 54, 55, 48, 49];
    public static const statNames:Array = ["Life", "Mana", "Attack", "Defense", "Speed", "Dexterity", "Vitality", "Wisdom"];

    public function StatIncreaseButton(host:StatIncreaseView, statIndex:int) {
        this.host = host;
        this.statIndex = statIndex;

        this.container = GraphicsUtil.drawCellBackground(210, 35, 8);
        addChild(this.container);

        var statIcon:BitmapData = AssetLibrary.getImageFromSet("lofiObj2", statIndexes[statIndex]);
        this.icon = new Bitmap(statIcon);
        this.icon.scaleX = this.icon.scaleY = 4;
        this.icon.x = 5;
        this.icon.y = 2;
        addChild(this.icon);

        this.titleText = new SimpleText(16, 0xffffff, false);
        this.titleText.setBold(true);
        this.titleText.autoSize = "center";
        this.titleText.text = statNames[statIndex];
        this.titleText.x = this.icon.x + this.icon.width;
        this.titleText.y = 35 / 2 - this.titleText.height / 2;
        addChild(this.titleText);

        this.plusOneButton = new TextButton(16, "+1", 40);
        this.plusOneButton.x = 115;
        this.plusOneButton.y = 35 / 2 - this.plusOneButton.height / 2 + 1;
        this.plusOneButton.addEventListener("click", onPlusOne);
        addChild(this.plusOneButton);

        this.plusTenButton = new TextButton(16, "+10", 40);
        this.plusTenButton.x = 160;
        this.plusTenButton.y = 35 / 2 - this.plusTenButton.height / 2 + 1;
        this.plusTenButton.addEventListener("click", onPlusTen);
        addChild(this.plusTenButton);
    }

    private function onPlusOne(e:Event):void
    {
        trace(this.statIndex, 1);
        this.host.onPlus(this.statIndex, 1);
    }

    private function onPlusTen(e:Event):void
    {
        trace(this.statIndex, 10);
        this.host.onPlus(this.statIndex, 10);
    }
}
}
