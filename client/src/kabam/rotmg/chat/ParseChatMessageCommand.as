package kabam.rotmg.chat {
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.DisplayObject;
import flash.display.StageScaleMode;

import flash.events.Event;

import kabam.rotmg.game.model.AddTextLineVO;
import kabam.rotmg.game.signals.AddTextLineSignal;

public class ParseChatMessageCommand {

    [Inject]
    public var data:String;
    [Inject]
    public var addTextLine:AddTextLineSignal;

    public function execute():void{
        if (this.fsCommands(this.data))
        {
            return;
        }
    }


    private function fsCommands(_arg_1:String):Boolean
    {
        var _local_4:* = undefined;
        _arg_1 = _arg_1.toLowerCase();
        var _local_2:DisplayObject = Parameters.root;
        if (_arg_1 == "/mscale")
        {
            this.addTextLine.dispatch(new AddTextLineVO(Parameters.HELP_CHAT_NAME, (("Map Scale: " + Parameters.data_.mscale) + " - Usage: /mscale <any decimal number from 0.5 to 5>.")));
            return true;
        }
        var _local_3:Array = _arg_1.match("^/mscale (\\d*\\.*\\d+)$");
        if (_local_3 != null)
        {
            _local_4 = Number(_local_3[1]);
            _local_4 = _local_4 > 0.5? _local_4 : 0.5;
            _local_4 = _local_4 < 5? _local_4 : 5;
            Parameters.data_["mscale"] = _local_4;
            Parameters.save();
            _local_2.dispatchEvent(new Event(Event.RESIZE));
            this.addTextLine.dispatch(new AddTextLineVO(Parameters.HELP_CHAT_NAME, ("Map Scale: " + _local_3[1])));
            return true;
        }
        return false;
    }


}
}
