package kabam.rotmg.market.tabs {
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.assembleegameclient.ui.TextButton;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.ui.dropdown.DropDown;
import com.company.assembleegameclient.util.Currency;

import flash.display.Bitmap;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import io.decagames.rotmg.ui.buttons.SliceScalingButton;
import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
import io.decagames.rotmg.ui.texture.TextureParser;

import kabam.rotmg.market.content.MemMarketInventoryItem;
import kabam.rotmg.market.content.MemMarketItem;
import kabam.rotmg.market.content.MemMarketSellItem;
import kabam.rotmg.market.signals.MemMarketAddSignal;
import kabam.rotmg.market.signals.MemMarketMyOffersSignal;
import kabam.rotmg.market.signals.MemMarketRemoveSignal;
import kabam.rotmg.market.utils.DialogUtils;
import kabam.rotmg.market.utils.SortUtils;
import kabam.rotmg.messaging.impl.data.MarketData;
import kabam.rotmg.messaging.impl.incoming.market.MarketAddResult;
import kabam.rotmg.messaging.impl.incoming.market.MarketMyOffersResult;
import kabam.rotmg.messaging.impl.incoming.market.MarketRemoveResult;

public class MemMarketSellTab extends MemMarketTab
{
    private static const SLOT_X_OFFSET:int = 16;
    private static const SLOT_Y_OFFSET:int = 130;

    private static const RESULT_X_OFFSET:int = 270;
    private static const RESULT_Y_OFFSET:int = 120;

    /* Signals */
    public const addSignal_:MemMarketAddSignal = new MemMarketAddSignal();
    public const removeSignal_:MemMarketRemoveSignal = new MemMarketRemoveSignal();
    public const myOffersSignal_:MemMarketMyOffersSignal = new MemMarketMyOffersSignal();

    private var inventorySlots_:Vector.<MemMarketInventoryItem>;
    private var priceField_:TextInputField;
    private var currencyFame_:Bitmap;
    private var sellButton_:TextButton;
    private var shape_:Shape;
    private var resultMask_:Sprite;
    private var resultBackground_:Sprite;
    private var resultItems_:Vector.<MemMarketSellItem>;
    private var resultScroll_:Scrollbar;
    private var sortChoices_:DropDown;
    private var uptime_:int;
    private var slots_:Vector.<int>;
    private var price_:int;
    private var selectedCurrency_:int;

    public function MemMarketSellTab(gameSprite:GameSprite)
    {
        super(gameSprite);

        /* Initialize signals */
        this.addSignal_.add(this.onAdd);
        this.removeSignal_.add(this.onRemove);
        this.myOffersSignal_.add(this.onMyOffers);

        this.inventorySlots_ = new Vector.<MemMarketInventoryItem>();
        for (var i:int = 4; i < this.gameSprite_.map.player_.equipment_.length; i++) /* Start at index 4 so we dont include equipment */
        {
            var item:MemMarketInventoryItem = new MemMarketInventoryItem(this.gameSprite_, this.gameSprite_.map.player_.equipment_[i], i, this.gameSprite_.map.player_.equipData_[i]);
            this.inventorySlots_.push(item);
        }

        var space:int = 0;
        var index:int = 0;
        for each (var o:MemMarketInventoryItem in this.inventorySlots_)
        {
            if (index < 8)
            {
                o.x = MemMarketItem.SLOT_WIDTH * int(index % 4) + SLOT_X_OFFSET  + (int(index % 4) * 6);
                o.y = MemMarketItem.SLOT_HEIGHT * int(index / 4) + SLOT_Y_OFFSET + (int(index / 4) * 6);
            } else
            {
                o.x = MemMarketItem.SLOT_WIDTH * int(index % 4) + SLOT_X_OFFSET  + (int(index % 4) * 6);
                o.y = 20 + MemMarketItem.SLOT_HEIGHT * int(index / 4) + SLOT_Y_OFFSET + (int(index / 4) * 6);
            }
            index++; /* Increase before we check spacing */
            if (index % 8 == 0) /* Add small space between each inventory */
            {
                space = 40;
            }
            addChild(o);
        }

        this.priceField_ = new TextInputField("", false, "", "Price", 170);
        this.priceField_.inputText_.restrict = "0-9";
        this.priceField_.x = 54;
        this.priceField_.y = 43;
        addChild(this.priceField_);

        this.uptime_ = 24; // 24 Hours

        this.sellButton_ = new TextButton(18, "Sell", 150);
        this.sellButton_.x = 52;
        this.sellButton_.y = 380;
        this.sellButton_.addEventListener(MouseEvent.CLICK, this.onSell);
        addChild(this.sellButton_);

        this.shape_ = new Shape();
        this.shape_.graphics.beginFill(0);
        this.shape_.graphics.drawRect(RESULT_X_OFFSET, RESULT_Y_OFFSET, 500, 415);
        this.shape_.graphics.endFill();
        this.resultMask_ = new Sprite();
        this.resultMask_.addChild(this.shape_);
        this.resultMask_.mask = this.shape_;
        addChild(this.resultMask_);
        this.resultBackground_ = new Sprite();
        this.resultMask_.addChild(this.resultBackground_);

        this.resultItems_= new Vector.<MemMarketSellItem>();

        this.sortChoices_ = new DropDown(SortUtils.SORT_CHOICES, 200, 26);
        this.sortChoices_.y = 75;
        this.sortChoices_.setValue(SortUtils.JUST_ADDED);
        this.sortChoices_.addEventListener(Event.CHANGE, this.onSortChoicesChanged);
        addChild(this.sortChoices_);

        this.gameSprite_.gsc_.marketMyOffers();
        this.positionAssets();
        if (WebMain.STAGE)
            WebMain.STAGE.addEventListener(Event.RESIZE, positionAssets);
    }

    private function positionAssets(e:Event = null):void
    {
        var width:int = WebMain.STAGE.stage.stageWidth;
        var height:int = WebMain.STAGE.stage.stageHeight;
        var sWidth:* = 800 / width;
        var sHeight:* = 600 / height;
        var result:* = sHeight / sWidth;
        this.sortChoices_.x = (800 * result) - this.sortChoices_.width - 10;
    }

    private function onSortChoicesChanged(event:Event) : void
    {
        this.sortOffers();
    }

    private function onSell(event:MouseEvent) : void
    {
        this.price_ = int(this.priceField_.text());
        if (this.price_ <= 0)
        {
            DialogUtils.makeSimpleDialog(this.gameSprite_, "Error", "Invalid price.");
            return;
        }

        this.slots_ = new Vector.<int>();
        for each (var i:MemMarketInventoryItem in this.inventorySlots_)
        {
            if (!i.selected_)
            {
                continue;
            }
            this.slots_.push(i.slot_);
        }

        if (this.slots_.length <= 0)
        {
            DialogUtils.makeSimpleDialog(this.gameSprite_, "Error", "You must select at least 1 item.");
            return;
        }

        this.selectedCurrency_ = Currency.FAME;

        var dialog:Dialog = new DialogUtils().returnDialog(this.gameSprite_, "Verification", "Are you sure you want to sell these items?", "Yes", "No");

        dialog.addEventListener(Dialog.BUTTON1_EVENT, this.onVerified);
        dialog.addEventListener(Dialog.BUTTON2_EVENT, DialogUtils.onDialogClose);

        this.gameSprite_.mui_.layers.overlay.addChild(dialog);
    }

    private function onVerified(event:Event) : void
    {
        this.gameSprite_.gsc_.marketAdd(this.slots_, this.price_, this.selectedCurrency_, this.uptime_);
        this.removeDialog(event.target as Dialog);
    }

    private function removeDialog(dialog:Dialog) : void
    {
        dialog.removeEventListener(Dialog.BUTTON1_EVENT, this.onVerified);
        dialog.removeEventListener(Dialog.BUTTON1_EVENT, DialogUtils.onDialogClose);
        dialog.removeEventListener(Dialog.BUTTON2_EVENT, DialogUtils.onDialogClose);
        dialog.parent.removeChild(dialog);
    }

    /* Adds and refresh all of our offers */
    private function onAdd(result:MarketAddResult) : void
    {
        if (result.code_ != -1)
        {
            this.slots_.length = 0;
            DialogUtils.makeSimpleDialog(this.gameSprite_, "Error", result.description_);
            return;
        }

        /* Reset sold inventory slots */
        for each (var i:MemMarketInventoryItem in this.inventorySlots_)
        {
            for each (var x:int in this.slots_)
            {
                if (i.slot_ == x)
                {
                    i.reset();
                }
            }
        }

        /* Reset slots */
        this.slots_.length = 0;

        /* Request our items back */
        this.gameSprite_.gsc_.marketMyOffers();

        DialogUtils.makeSimpleDialog(this.gameSprite_, "Success", result.description_);
    }

    /* This really only gets called when there's an error */
    private function onRemove(result:MarketRemoveResult) : void
    {
        if (result.description_ != "")
        {
            DialogUtils.makeSimpleDialog(this.gameSprite_, "Error", result.description_);
        }
    }

    /* Refresh all of our offers */
    private function onMyOffers(result:MarketMyOffersResult) : void
    {
        /* Remove old scrollbar */
        if (this.resultScroll_ != null)
        {
            this.resultScroll_.removeEventListener(Event.CHANGE, this.onResultScrollChanged);
            removeChild(this.resultScroll_);
            this.resultScroll_ = null;
        }

        for each (var x:MemMarketSellItem in this.resultItems_) /* Clean old Results. */
        {
            x.dispose();
            this.resultBackground_.removeChild(x);
            x = null;
        }
        this.resultItems_.length = 0;

        for each (var i:MarketData in result.results_)
        {
            var item:MemMarketSellItem = new MemMarketSellItem(this.gameSprite_, i);
            this.resultItems_.push(item);
        }

        this.sortOffers();

        for each (var o:MemMarketSellItem in this.resultItems_)
        {
            this.resultBackground_.addChild(o);
        }

        this.resultBackground_.y = 0; /* Reset height */
        if (this.resultBackground_.height > 436)
        {
            this.resultScroll_ = new Scrollbar(22, 415);
            this.resultScroll_.x = 774;
            this.resultScroll_.y = RESULT_Y_OFFSET;
            this.resultScroll_.setIndicatorSize(415, this.resultBackground_.height);
            this.resultScroll_.addEventListener(Event.CHANGE, this.onResultScrollChanged);
            addChild(this.resultScroll_);
        }
    }

    private function onResultScrollChanged(event:Event) : void
    {
        this.resultBackground_.y = -this.resultScroll_.pos() * (this.resultBackground_.height - 418);
    }

    private function sortOffers() : void
    {
        switch (SortUtils.SORT_CHOICES[this.sortChoices_.getIndex()])
        {
            case SortUtils.LOWEST_TO_HIGHEST:
                this.resultItems_.sort(SortUtils.lowestToHighest);
                break;
            case SortUtils.HIGHEST_TO_LOWEST:
                this.resultItems_.sort(SortUtils.highestToLowest);
                break;
            case SortUtils.JUST_ADDED:
                this.resultItems_.sort(SortUtils.justAdded);
                break;
            case SortUtils.ENDING_SOON:
                this.resultItems_.sort(SortUtils.endingSoon);
                break;
        }

        var index:int = 0;
        for each (var i:MemMarketSellItem in this.resultItems_)
        {
            i.x = MemMarketItem.OFFER_WIDTH * int(index % 5) + RESULT_X_OFFSET;
            i.y = MemMarketItem.OFFER_HEIGHT * int(index / 5) + RESULT_Y_OFFSET;
            index++;
        }
    }

    /* Clear */
    public override function dispose() : void
    {
        if (WebMain.STAGE)
            WebMain.STAGE.removeEventListener(Event.RESIZE, positionAssets);
        this.addSignal_.remove(this.onAdd);
        this.removeSignal_.remove(this.onRemove);
        this.myOffersSignal_.remove(this.onMyOffers);

        for each (var i:MemMarketInventoryItem in this.inventorySlots_)
        {
            i.dispose();
            i = null;
        }
        this.inventorySlots_.length = 0;
        this.inventorySlots_ = null;

        this.priceField_ = null;
        this.currencyFame_ = null;

        this.sellButton_.removeEventListener(MouseEvent.CLICK, this.onSell);
        this.sellButton_ = null;

        this.shape_.parent.removeChild(this.shape_);
        this.shape_ = null;

        for each (var x:MemMarketSellItem in this.resultItems_) /* Clean old Results. */
        {
            x.dispose();
            this.resultBackground_.removeChild(x);
            x = null;
        }
        this.resultItems_.length = 0;

        this.resultItems_ = null;

        this.resultMask_.removeChild(this.resultBackground_);
        this.resultMask_ = null;
        this.resultBackground_ = null;

        if (this.resultScroll_ != null)
        {
            this.resultScroll_.removeEventListener(Event.CHANGE, this.onResultScrollChanged);
            this.resultScroll_ = null;
        }

        this.sortChoices_.removeEventListener(Event.CHANGE, this.onSortChoicesChanged);
        this.sortChoices_ = null;

        if (this.slots_ != null)
        {
            this.slots_.length = 0;
            this.slots_ = null;
        }

        super.dispose();
    }
}
}
