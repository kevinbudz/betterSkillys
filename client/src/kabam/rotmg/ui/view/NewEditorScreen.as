package kabam.rotmg.ui.view {
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.RegionLibrary;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.util.AnimatedChars;
import com.company.util.AssetLibrary;

import flash.display.Sprite;
import flash.events.Event;

import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.signals.GotoPreviousScreenSignal;

import org.swiftsuspenders.Injector;

import realmeditor.EditorLoader;

public class NewEditorScreen extends Sprite {

    public function NewEditorScreen() {
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
        var editorView:Sprite = EditorLoader.load(this);
        editorView.addEventListener(Event.REMOVED_FROM_STAGE, this.onEditorExit);
    }

    private function onEditorExit(e:Event):void { // Go back to title screen
        var injector:Injector = StaticInjectorContext.getInjector();
        injector.getInstance(GotoPreviousScreenSignal).dispatch();
    }
}
}
