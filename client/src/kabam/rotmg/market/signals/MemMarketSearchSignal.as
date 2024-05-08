package kabam.rotmg.market.signals {
import kabam.rotmg.messaging.impl.incoming.market.MarketSearchResult;

import org.osflash.signals.Signal;

public class MemMarketSearchSignal extends Signal
{
    public static var instance:MemMarketSearchSignal;

    public function MemMarketSearchSignal()
    {
        super(MarketSearchResult);
        instance = this;
    }
}
}
