package kabam.rotmg.market.content {
import com.company.assembleegameclient.game.GameSprite;

import flash.events.MouseEvent;

import kabam.rotmg.market.utils.GeneralUtils;
import kabam.rotmg.market.utils.TintUtils;

public class MemMarketInventoryItem extends MemMarketItem
{
    public var slot_:int;
    public var selected_:Boolean;

    public function MemMarketInventoryItem(gameSprite:GameSprite, itemType:int, slot:int, itemData:Object)
    {
        super(gameSprite, SLOT_WIDTH, SLOT_HEIGHT, 80, itemType, null, itemData);

        this.slot_ = slot;

        if (this.itemType_ != -1)
        {
            if (GeneralUtils.isBanned(this.itemType_)) /* Apply red tint on banned items */
                TintUtils.addTint(this.shape_, 0x5C1D1D, 0.4);
            else
                addEventListener(MouseEvent.CLICK, this.onClick);
        }
    }

    private function onClick(event:MouseEvent) : void
    {
        this.selected_ = !this.selected_;
        if (this.selected_)
            TintUtils.addTint(this.shape_, 0xFFB63F, 0.4);
        else
            TintUtils.removeTint(this.shape_);
    }

    public function reset() : void
    {
        this.itemType_ = -1;
        this.selected_ = false;
        TintUtils.removeTint(this.shape_);
        removeEventListener(MouseEvent.CLICK, this.onClick);
        removeChild(this.icon_);
        this.icon_ = null;
        if (this.toolTip_ != null)
        {
            this.toolTip_.parent.removeChild(this.toolTip_);
            this.toolTip_ = null;
        }
        this.removeListeners();
    }

    /* Clear */
    public override function dispose() : void
    {
        removeEventListener(MouseEvent.CLICK, this.onClick);
        super.dispose();
    }
}
}
