package kabam.lib.net.impl {
import flash.utils.ByteArray;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

import kabam.rotmg.core.StaticInjectorContext;

public class Message
{
    public var pool:MessagePool;
    public var prev:Message;
    public var next:Message;

    private var isCallback:Boolean;

    public var id:uint;
    public var callback:Function;

    public function Message(id:uint, callback:Function = null) {
        this.id = id;
        isCallback = callback != null;
        this.callback = callback;
    }

    public function parseFromInput(data:IDataInput):void { }
    public function writeToOutput(data:IDataOutput):void { }

    public function toString():String {
        return formatToString("MESSAGE", "id");
    }

    protected function formatToString(name:String, ...args):String {
        var str:String = "[" + name;
        for (var i:int = 0; i < args.length; i++) {
            str = str + (" " + args[i] + "=\"" + this[args[i]] + "\"");
        }
        str = str + "]";
        return str;
    }

    public function consume():void
    {
        isCallback && callback(this);
        prev = null;
        next = null;
        pool.append(this);
    }
}
}
