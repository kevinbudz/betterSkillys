package kabam.rotmg.ui.view {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.game.events.DeathEvent;
import com.company.assembleegameclient.game.events.ReconnectEvent;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.RegionLibrary;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.AnimatedChars;
import com.company.util.AssetLibrary;

import flash.display.NativeWindow;

import flash.display.Sprite;
import flash.events.Event;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.GotoPreviousScreenSignal;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.servers.api.ServerModel;

import org.swiftsuspenders.Injector;

import realmeditor.EditorLoader;
import realmeditor.RealmEditorTestEvent;

public class NewEditorScreen extends Sprite {

    private var injector:Injector;
    private var editorView:Sprite;
    private var gameSprite:GameSprite;
    private var server:Server;
    private var model:PlayerModel;
    private var window:NativeWindow;

    public function NewEditorScreen() {
        this.injector = StaticInjectorContext.getInjector();
        var servers:ServerModel = injector.getInstance(ServerModel);
        this.server = servers.getServer();
        this.model = injector.getInstance(PlayerModel);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
    }

    private function onAddedToStage(e:Event):void {
        EditorLoader.loadAssets(
                AssetLibrary.images_,
                AssetLibrary.imageSets_,
                AssetLibrary.imageLookup_
        );
        EditorLoader.loadAnimChars(AnimatedChars.nameMap_);
        EditorLoader.loadGround(GroundLibrary.xmlLibrary_);
        EditorLoader.loadObjects(ObjectLibrary.xmlLibrary_);
        EditorLoader.loadRegions(RegionLibrary.xmlLibrary_);
        this.editorView = EditorLoader.load(this);
        this.editorView.addEventListener(Event.REMOVED_FROM_STAGE, this.onEditorExit);
        this.editorView.addEventListener(Event.CONNECT, this.onMapTest);
        this.window = stage.nativeWindow;
        this.window.addEventListener(Event.CLOSING, this.onMapTestDone); // Closing the window
    }

    private function onEditorExit(e:Event):void { // Go back to title screen
        this.injector.getInstance(GotoPreviousScreenSignal).dispatch();
    }

    private function onMapTest(e:RealmEditorTestEvent):void {
        this.editorView.visible = false;
        this.gameSprite = new GameSprite(this.server, Parameters.MAPTEST_GAMEID, false, this.model.getSavedCharacters()[0].charId(), -1, null, this.model, e.mapJSON_);
        this.gameSprite.isEditor = true;
        this.gameSprite.addEventListener(Event.COMPLETE, this.onMapTestDone);
        this.gameSprite.addEventListener(ReconnectEvent.RECONNECT, this.onMapTestDone);
        this.gameSprite.addEventListener(DeathEvent.DEATH, this.onMapTestDone);
        addChild(this.gameSprite);
    }

    private function onMapTestDone(event:Event):void {
        this.cleanupGameSprite();
        this.editorView.visible = true;
    }

    private function cleanupGameSprite():void {
        this.gameSprite.removeEventListener(Event.COMPLETE, this.onMapTestDone);
        this.gameSprite.removeEventListener(ReconnectEvent.RECONNECT, this.onMapTestDone);
        this.gameSprite.removeEventListener(DeathEvent.DEATH, this.onMapTestDone);
        removeChild(this.gameSprite);
        this.gameSprite = null;
    }
}
}
