package com.company.assembleegameclient.ui.panels.itemgrids.engineInventory {
import com.company.assembleegameclient.ui.panels.itemgrids.engineInventory.*;
import com.company.assembleegameclient.constants.InventoryOwnerTypes;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Forge;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.Slot;
import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.ui.SimpleText;
import com.company.util.MoreColorUtil;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;

import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.constants.GeneralConstants;
import kabam.rotmg.messaging.impl.data.ForgeItem;
import kabam.rotmg.messaging.impl.data.FuelEngine;

public class EngineInventory extends Sprite {


    private static const NO_CUT:Array = [0,0,0,0];

    private static const cuts:Array = [[1,0,0,1],NO_CUT,NO_CUT,[0,1,1,0],[1,0,0,0],NO_CUT,NO_CUT,[0,1,0,0],[0,0,0,1],NO_CUT,NO_CUT,[0,0,1,0]];

    public var gs_:GameSprite;

    public var slots_:Vector.<EngineSlot>;

    public var slotId:Vector.<int> = new Vector.<int>();

    public var boxInv:SliceScalingBitmap;
    public var boxBackpack:SliceScalingBitmap;

    public function EngineInventory(gs:GameSprite, items:Vector.<int>, equipData:Vector.<Object>, backPack:Boolean) {
        this.slots_ = new Vector.<EngineSlot>();
        super();
        this.gs_ = gs;
        for(var i:int = 4; i < GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS; i++)
        {
            var inventory:EngineSlot = new EngineSlot(items[i], cuts, i, equipData[i]);
            inventory.x = int(i % 4) * (Slot.WIDTH + 4);
            inventory.y = int(i / 4) * (Slot.HEIGHT + 4) + 46;
            var itemXML:XML = ObjectLibrary.xmlLibrary_[items[i]];
            if((itemXML != null))
                inventory.addEventListener(MouseEvent.MOUSE_DOWN,this.onSlotClick);
            else
                inventory.transform.colorTransform = MoreColorUtil.veryDarkCT;
            this.slots_.push(inventory);
            addChild(inventory);

            if(backPack)
            {
                var backpackInv:EngineSlot = new EngineSlot(items[i + 8], cuts, i, equipData[i + 8]);
                backpackInv.x = int(i % 4) * (Slot.WIDTH + 4);
                backpackInv.y = inventory.y + 100;
                var itembackpackXML:XML = ObjectLibrary.xmlLibrary_[items[i + 8]];
                if((itembackpackXML != null))
                    backpackInv.addEventListener(MouseEvent.MOUSE_DOWN,this.onSlotClick);
                else
                    backpackInv.transform.colorTransform = MoreColorUtil.veryDarkCT;
                this.slots_.push(backpackInv);
                addChild(backpackInv);
            }
            this.slotId.push(i);
            if(backPack){
                this.slotId.push(i + 8);
            }
        }
    }

    private function onSlotClick(event:MouseEvent) : void
    {
        var slot:EngineSlot = event.currentTarget as EngineSlot;
        slot.setIncluded(!slot.included_);
        dispatchEvent(new Event(Event.CHANGE));
    }


    public function getIncludedItems() : Vector.<FuelEngine>
    {
        var included:Vector.<FuelEngine> = new Vector.<FuelEngine>();
        for(var i:int = 0; i < this.slots_.length; i++)
        {
            if(this.slots_[i].included_)
            {
                var forgeItem:FuelEngine = new FuelEngine();
                forgeItem.objectType_ = this.slots_[i].item_;
                forgeItem.slotId_ = this.slotId[i];
                forgeItem.included_ = this.slots_[i].included_;
                forgeItem.itemData_ = this.slots_[i].itemData_;
                included.push(forgeItem);
            }
        }
        return included;
    }


}
}
