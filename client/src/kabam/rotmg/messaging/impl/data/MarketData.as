package kabam.rotmg.messaging.impl.data
{
import flash.utils.IDataInput;

public class MarketData
{
    public var id_:int;
    public var itemType_:Number;
    public var sellerName_:String;
    public var sellerId_:int;
    public var currency_:int;
    public var price_:int;
    public var startTime_:int;
    public var timeLeft_:int;
    public var itemData_:String;

    public function MarketData()
    {
        super();
    }

    public function parseFromInput(data:IDataInput) : void
    {
        this.id_ = data.readInt();
        this.itemType_ = data.readUnsignedShort();
        this.sellerName_ = data.readUTF();
        this.sellerId_ = data.readInt();
        this.currency_ = data.readInt();
        this.price_ = data.readInt();
        this.startTime_ = data.readInt();
        this.timeLeft_ = data.readInt();
        this.itemData_ = data.readUTF();
    }
}
}
