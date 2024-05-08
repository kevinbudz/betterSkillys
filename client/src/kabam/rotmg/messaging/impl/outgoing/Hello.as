package kabam.rotmg.messaging.impl.outgoing {
import flash.utils.ByteArray;
import flash.utils.IDataOutput;

public class Hello extends OutgoingMessage {
    public function Hello(id:uint, callback:Function) {
        this.buildVersion_ = "";
        this.guid_ = "";
        this.password_ = "";
        this.key_ = new ByteArray();
        this.mapJSON_ = "";
        super(id, callback);
    }

    public var buildVersion_:String;
    public var gameId_:int = 0;
    public var guid_:String;
    public var password_:String;
    public var keyTime_:int = 0;
    public var key_:ByteArray;
    public var mapJSON_:String;

    override public function writeToOutput(data:IDataOutput):void {
        data.writeUTF(this.buildVersion_);
        data.writeInt(this.gameId_);
        data.writeUTF(this.guid_);
        data.writeUTF(this.password_);
        data.writeInt(this.keyTime_);
        data.writeShort(this.key_.length);
        data.writeBytes(this.key_);
        data.writeInt(this.mapJSON_.length);
        data.writeUTFBytes(this.mapJSON_);
    }

    override public function toString():String {
        return formatToString("HELLO", "buildVersion_", "gameId_", "guid_", "password_");
    }
}
}
