package com.company.assembleegameclient.ui.panels.mediators
{
import com.company.assembleegameclient.ui.panels.itemgrids.EquippedGrid;

import kabam.rotmg.ui.signals.ToggleShowTierTagSignal;

import robotlegs.bender.bundles.mvcs.Mediator;

public class EquippedGridMediator extends Mediator
{


    [Inject]
    public var view:EquippedGrid;

    [Inject]
    public var toggleShowTierTag:ToggleShowTierTagSignal;

    public function EquippedGridMediator()
    {
        super();
    }

    override public function initialize() : void
    {
        this.toggleShowTierTag.add(this.onToggleShowTierTag);
    }

    private function onToggleShowTierTag(_arg_1:Boolean) : void
    {
        this.view.toggleTierTags(_arg_1);
    }
}
}
