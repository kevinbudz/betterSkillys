package kabam.rotmg.storage {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.sound.SoundEffectLibrary;

import flash.events.Event;
import flash.events.MouseEvent;

import kabam.lib.net.api.MessageProvider;
import kabam.lib.net.impl.SocketServer;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.messaging.impl.GameServerConnection;
import kabam.rotmg.messaging.impl.outgoing.UsePotion;
import kabam.rotmg.messaging.impl.outgoing.potionStorage.PotionStorage;

import org.swiftsuspenders.Injector;

import robotlegs.bender.bundles.mvcs.Mediator;

public class PotionStorageModalMediator extends Mediator {

    [Inject]
    public var view:PotionStorageModal;
    [Inject]
    public var closeDialogs:CloseDialogsSignal;

    override public function initialize():void {
        this.view.close.add(this.onCancel);
    }

    override public function destroy():void {
        this.view.close.remove(this.onCancel);
    }

    private function onCancel():void {
        SoundEffectLibrary.play("button_click");
        this.closeDialogs.dispatch();
    }
}
}