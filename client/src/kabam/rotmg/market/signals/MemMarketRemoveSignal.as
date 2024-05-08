package kabam.rotmg.market.signals {
import kabam.rotmg.messaging.impl.incoming.market.MarketRemoveResult;

import org.osflash.signals.Signal;

public class MemMarketRemoveSignal extends Signal
{
    public static var instance:MemMarketRemoveSignal;

    public function MemMarketRemoveSignal()
    {
        super(MarketRemoveResult);
        instance = this;
    }
}
}
