package kabam.rotmg.storage {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Player;
import com.gskinner.motion.GTween;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.popups.header.PopupHeader;
import io.decagames.rotmg.ui.popups.modal.ModalPopup;
import io.decagames.rotmg.ui.texture.TextureParser;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.AddTextLineSignal;

import org.osflash.signals.Signal;

public class PotionStorageModal extends ModalPopup {

    private var gs_:GameSprite;
    internal var quitButton:SliceScalingButton;
    internal var player:Player;
    internal var text_:String;

    internal var close:Signal = new Signal();

    public var potionContainers:Vector.<PotionStorageContainer>;

    public var gameObject:GameObject;

    public function PotionStorageModal(gs:GameSprite, gm:GameObject) {
        this.gs_ = gs;
        this.gameObject = gm;
        super(440, 425, "Potion Storage");

        this.gs_.map.player_.SPS_Modal = this;

        this.potionContainers = new Vector.<PotionStorageContainer>();

        this.alpha = 0;
        new GTween(this, 0.2, {"alpha": 1});

        this.player = gm as Player;
        this.quitButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "close_button"));
        this.header.addButton(this.quitButton, PopupHeader.RIGHT_BUTTON);
        this.quitButton.addEventListener(MouseEvent.CLICK, this.onClose);


        for(var i:int = 0; i < 8; i++)
        {
            var container:PotionStorageContainer = new PotionStorageContainer(this, gs, i, gs.map.player_);

            container.x = 50 + container.width * int(i % 4) + 70 - container.width;
            if (i < 4)
                container.y = 20 + container.width * int(i / 4);
            else
                container.y = 110 + container.width * int(i / 4);

            addChild(container);

            this.potionContainers.push(container);
        }

        this.x = this.width / 2 - 160;
        this.y = this.height / 2 - 190;

    }



    // type is the potion type in the container

    // 0 is add
    // 1 is remove
    // 2 is consume
    // 3 is sell
    // 4 is max
    public function Interaction(type:int, action:int):void
    {
        this.gs_.gsc_.PotionInteraction(type, action);
    }

    public function onClose(arg1:Event):void {
        this.gs_.map.player_.SPS_Modal = null;
        this.close.dispatch();
    }

    public function draw():void {
        for(var i:int = 0; i < 8; i++)
        {
            this.potionContainers[i].draw();
        }
    }

}
}
