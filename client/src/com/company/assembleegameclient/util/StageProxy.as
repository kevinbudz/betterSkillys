package com.company.assembleegameclient.util
{
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.IEventDispatcher;

public class StageProxy implements IEventDispatcher
{

    private static var stage3D:Stage3DProxy = null;


    protected var reference:DisplayObject;

    public function StageProxy(reference:DisplayObject)
    {
        super();
        this.reference = reference;
    }

    public function getStage() : DisplayObjectContainer
    {
        return this.reference.stage;
    }

    public function getStageWidth() : Number
    {
        if(this.reference.stage != null)
        {
            return this.reference.stage.stageWidth;
        }
        return 800;
    }

    public function getStageHeight() : Number
    {
        if(this.reference.stage != null)
        {
            return this.reference.stage.stageHeight;
        }
        return 600;
    }

    public function getFocus() : InteractiveObject
    {
        return this.reference.stage.focus;
    }

    public function setFocus(value:InteractiveObject) : void
    {
        this.reference.stage.focus = value;
    }

    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
    {
        this.reference.stage.addEventListener(type,listener,useCapture,priority,useWeakReference);
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
    {
        this.reference.stage.removeEventListener(type,listener,useCapture);
    }

    public function dispatchEvent(event:Event) : Boolean
    {
        return this.reference.stage.dispatchEvent(event);
    }

    public function hasEventListener(type:String) : Boolean
    {
        return this.reference.stage.hasEventListener(type);
    }

    public function willTrigger(type:String) : Boolean
    {
        return this.reference.stage.willTrigger(type);
    }

    public function getQuality() : String
    {
        return this.reference.stage.quality;
    }

    public function setQuality(quality:String) : void
    {
        this.reference.stage.quality = quality;
    }

    public function getStage3Ds(i:int) : Stage3DProxy
    {
        if(stage3D == null)
        {
            stage3D = new Stage3DProxy(this.reference.stage.stage3Ds[i]);
        }
        return stage3D;
    }
}
}
