package com.company.assembleegameclient.util
{
import flash.display.Stage3D;
import flash.events.Event;
import flash.events.IEventDispatcher;
import kabam.rotmg.stage3D.proxies.Context3DProxy;

public class Stage3DProxy implements IEventDispatcher
{

    private static var context3D:Context3DProxy;


    private var stage3D:Stage3D;

    public function Stage3DProxy(stage3D:Stage3D)
    {
        super();
        this.stage3D = stage3D;
    }

    public function requestContext3D() : void
    {
        this.stage3D.requestContext3D();
    }

    public function getContext3D() : Context3DProxy
    {
        if(context3D == null)
        {
            context3D = new Context3DProxy(this.stage3D.context3D);
        }
        return context3D;
    }

    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
    {
        this.stage3D.addEventListener(type,listener,useCapture,priority,useWeakReference);
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
    {
        this.stage3D.removeEventListener(type,listener,useCapture);
    }

    public function dispatchEvent(event:Event) : Boolean
    {
        return this.stage3D.dispatchEvent(event);
    }

    public function hasEventListener(type:String) : Boolean
    {
        return this.stage3D.hasEventListener(type);
    }

    public function willTrigger(type:String) : Boolean
    {
        return this.stage3D.willTrigger(type);
    }
}
}
