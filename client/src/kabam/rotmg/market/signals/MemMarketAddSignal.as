package kabam.rotmg.market.signals {
import kabam.rotmg.messaging.impl.incoming.market.MarketAddResult;

import org.osflash.signals.Signal;

public class MemMarketAddSignal extends Signal
{
    public static var instance:MemMarketAddSignal;

    public function MemMarketAddSignal()
    {
        super(MarketAddResult);
        instance = this;
    }
}
}
