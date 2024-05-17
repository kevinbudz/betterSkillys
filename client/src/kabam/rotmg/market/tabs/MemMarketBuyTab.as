package kabam.rotmg.market.tabs {
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.assembleegameclient.ui.dropdown.DropDown;
import com.company.util.KeyCodes;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import io.decagames.rotmg.ui.scroll.UIScrollbar;

import kabam.rotmg.market.content.MemMarketBuyItem;
import kabam.rotmg.market.content.MemMarketItem;
import kabam.rotmg.market.signals.MemMarketBuySignal;
import kabam.rotmg.market.signals.MemMarketSearchSignal;
import kabam.rotmg.market.utils.DialogUtils;
import kabam.rotmg.market.utils.GeneralUtils;
import kabam.rotmg.market.utils.SortUtils;
import kabam.rotmg.messaging.impl.data.MarketData;
import kabam.rotmg.messaging.impl.incoming.market.MarketBuyResult;
import kabam.rotmg.messaging.impl.incoming.market.MarketSearchResult;

import mx.utils.StringUtil;

public class MemMarketBuyTab extends MemMarketTab
{
    private static const SEARCH_X_OFFSET:int = 10;
    private static const SEARCH_Y_OFFSET:int = 120;
    private static const SEARCH_ITEM_SIZE:int = 50;

    private static const RESULT_X_OFFSET:int = 270;
    private static const RESULT_Y_OFFSET:int = 105;

    private static const PADDING:int = 6;

    /* Signals */
    public const buySignal_:MemMarketBuySignal = new MemMarketBuySignal();
    public const searchSignal_:MemMarketSearchSignal = new MemMarketSearchSignal();

    private var searchField_:TextInputField;
    private var shape_:Shape;
    private var searchMask_:Sprite;
    private var searchBackground:Sprite;
    private var searchItems:Vector.<MemMarketItem>;
    private var searchScroll:Scrollbar;

    private var resultMask_:Sprite;
    private var resultBackground_:Sprite;
    private var resultItems_:Vector.<MemMarketBuyItem>;
    private var resultScroll_:UIScrollbar;

    private var sortChoices_:DropDown;

    public function MemMarketBuyTab(gameSprite:GameSprite)
    {
        super(gameSprite);

        /* Initialize signals */
        this.buySignal_.add(this.onBuy);
        this.searchSignal_.add(this.onSearch);

        this.searchField_ = new TextInputField("", false, "", "", 210);
        this.searchField_.x = SEARCH_X_OFFSET + 4;
        this.searchField_.y = 43;
        this.searchField_.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
        addChild(this.searchField_);

        this.shape_ = new Shape();
        this.shape_.graphics.beginFill(0);
        this.shape_.graphics.drawRect(SEARCH_X_OFFSET, SEARCH_Y_OFFSET, 250, 400);
        this.shape_.graphics.endFill();
        this.searchMask_ = new Sprite();
        this.searchMask_.addChild(this.shape_);
        this.searchMask_.mask = this.shape_;
        addChild(this.searchMask_);
        this.searchBackground = new Sprite();
        this.searchMask_.addChild(this.searchBackground);

        this.searchItems = new Vector.<MemMarketItem>();

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

        this.resultItems_ = new Vector.<MemMarketBuyItem>();

        this.sortChoices_ = new DropDown(SortUtils.SORT_CHOICES, 200, 26);
        this.sortChoices_.y = 75;
        this.sortChoices_.setValue(SortUtils.LOWEST_TO_HIGHEST);
        this.sortChoices_.addEventListener(Event.CHANGE, this.onSortChoicesChanged);
        addChild(this.sortChoices_);

        this.searchItemsFunc(true);
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

    private function onKeyUp(event:KeyboardEvent) : void
    {
        if (event.keyCode == KeyCodes.ENTER)
        {
            if(this.searchField_.inputText_.text == "")
                this.searchItemsFunc(true);
            else
                this.searchItemsFunc();
        }
    }

    private function searchItemsFunc(first:Boolean = false) : void
    {
        /* Remove old scrollbar */
        if (this.searchScroll != null)
        {
            this.searchScroll.removeEventListener(Event.CHANGE, this.onSearchScrollChanged);
            removeChild(this.searchScroll);
            this.searchScroll = null;
        }

        if (!StringUtil.trim(this.searchField_.text()) && !first) /* Clear results if empty */
        {
            this.clearPreviousResults(false);
            return;
        }

        this.clearPreviousResults(false);

        var index:int = 0;
        if (first)
        {
            for each (var w:String in ObjectLibrary.typeToIdItems_)
            {
                /* Skip on banned items */
                if (GeneralUtils.isBanned(ObjectLibrary.idToTypeItems_[w]) || ObjectLibrary.idToTypeItems_[w] == null){
                    continue;
                }

                var preloaded:MemMarketItem = new MemMarketItem(this.gameSprite_, SEARCH_ITEM_SIZE, SEARCH_ITEM_SIZE, 80, ObjectLibrary.idToTypeItems_[w], null);
                preloaded.x = 1 + SEARCH_ITEM_SIZE * int(index % 4) + SEARCH_X_OFFSET + (int(index % 4) * PADDING);
                preloaded.y = SEARCH_ITEM_SIZE * int(index / 4) + SEARCH_Y_OFFSET + (int(index / 4) * PADDING);
                preloaded.addEventListener(MouseEvent.CLICK, this.onSearchClick);
                this.searchItems.push(preloaded);
                index++;
            }
        }
        else
        {
            for each (var i:String in ObjectLibrary.typeToIdItems_)
            {
                if (i.indexOf(this.searchField_.text().toLowerCase()) >= 0)
                {
                    if (GeneralUtils.isBanned(ObjectLibrary.idToTypeItems_[i])) /* Skip on banned items */
                        continue;

                    var item:MemMarketItem = new MemMarketItem(this.gameSprite_, SEARCH_ITEM_SIZE, SEARCH_ITEM_SIZE, 80, ObjectLibrary.idToTypeItems_[i], null);
                    item.x = 1 + SEARCH_ITEM_SIZE * int(index % 4) + SEARCH_X_OFFSET + (int(index % 4) * PADDING);
                    item.y = SEARCH_ITEM_SIZE * int(index / 4) + SEARCH_Y_OFFSET + (int(index / 4) * PADDING);
                    item.addEventListener(MouseEvent.CLICK, this.onSearchClick);
                    this.searchItems.push(item);
                    index++;
                }
            }
        }

        for each (var x:MemMarketItem in this.searchItems) /* Draw our results */
        {
            this.searchBackground.addChild(x);
        }

        this.searchBackground.y = 0; /* Reset height */
        if (this.searchBackground.height > 400)
        {
            this.searchScroll = new Scrollbar(10, 400);
            this.searchScroll.x = 236;
            this.searchScroll.y = SEARCH_Y_OFFSET;
            this.searchScroll.setIndicatorSize(400, this.searchBackground.height);
            this.searchScroll.addEventListener(Event.CHANGE, this.onSearchScrollChanged);
            addChild(this.searchScroll);
        }
    }

    private function onSearchClick(event:MouseEvent) : void
    {
        var item:MemMarketItem = event.currentTarget as MemMarketItem;
        this.gameSprite_.gsc_.marketSearch(item.itemType_);
    }

    private function onSearchScrollChanged(event:Event) : void
    {
        this.searchBackground.y = -this.searchScroll.pos() * (this.searchBackground.height - 356);
    }

    /* Clear previous results */
    private function clearPreviousResults(result:Boolean) : void
    {
        if (result)
        {
            for each (var i:MemMarketBuyItem in this.resultItems_)
            {
                i.dispose();
                this.resultBackground_.removeChild(i);
                i = null;
            }
            this.resultItems_.length = 0;
        }
        else
        {
            for each (var o:MemMarketItem in this.searchItems)
            {
                o.removeEventListener(MouseEvent.CLICK, this.onSearchClick);
                o.dispose();
                this.searchBackground.removeChild(o);
                o = null;
            }
            this.searchItems.length = 0;
        }
    }

    /* Removes an offer from resultItems and sorts */
    private function removeOffer(id:int) : void
    {
        var index:int = 0;
        for each (var o:MemMarketBuyItem in this.resultItems_)
        {
            if (o.id_ == id) /* Item matched, remove */
            {
                this.resultItems_.splice(index, 1);
                o.dispose();
                o.parent.removeChild(o);
                o = null;
                break; /* No need to continue the loop after we got what we looked for */
            }
            index++;
        }

        this.sortOffers();
    }

    private function refreshOffers() : void
    {
        for each (var o:MemMarketBuyItem in this.resultItems_)
        {
            o.updateButton();
        }
    }

    /* Sorts and positions offers */
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
        for each (var i:MemMarketBuyItem in this.resultItems_)
        {
            i.x = 1 + MemMarketItem.OFFER_WIDTH * int(index % 4) + RESULT_X_OFFSET + ((int(index % 4) * PADDING));
            i.y = MemMarketItem.OFFER_HEIGHT * int(index / 4) + RESULT_Y_OFFSET + ((int(index % 4) * PADDING));
            index++;
        }
    }

    /* Buy and refresh offers */
    private function onBuy(result:MarketBuyResult) : void
    {
        if (result.code_ != -1)
        {
            DialogUtils.makeSimpleDialog(this.gameSprite_, "Error", result.description_);
            return;
        }

        this.removeOffer(result.offerId_);
        this.refreshOffers();

        DialogUtils.makeSimpleDialog(this.gameSprite_, "Success", result.description_);
    }

    /* Refresh and add found offers */
    private function onSearch(result:MarketSearchResult) : void {
        if (result.description_ != "") {
            this.clearPreviousResults(true);
            DialogUtils.makeSimpleDialog(this.gameSprite_, "Error", result.description_);
            return;
        }

        /* Remove old scrollbar */
        if (this.resultScroll_ != null) {
            this.resultScroll_.content = null;
            removeChild(this.resultScroll_);
            this.resultScroll_ = null;
        }

        this.clearPreviousResults(true);

        for each (var i:MarketData in result.results_) {
            var item:MemMarketBuyItem = new MemMarketBuyItem(this.gameSprite_, i);
            this.resultItems_.push(item);
        }

        this.sortOffers();

        for each (var o:MemMarketBuyItem in this.resultItems_) {
            this.resultBackground_.addChild(o);
        }

        this.resultBackground_.y = 0; /* Reset height */
        if (this.resultBackground_.height > 436) {
            this.resultScroll_ = new UIScrollbar(415);
            this.resultScroll_.x = 774;
            this.resultScroll_.y = RESULT_Y_OFFSET;
            this.resultScroll_.content = this.resultBackground_;
            addChild(this.resultScroll_);
        }
    }

    /* Clear */
    public override function dispose() : void
    {
        if (WebMain.STAGE)
            WebMain.STAGE.removeEventListener(Event.RESIZE, positionAssets);
        this.buySignal_.remove(this.onBuy);
        this.searchSignal_.remove(this.onSearch);

        this.searchField_.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
        this.searchField_ = null;

        this.shape_.parent.removeChild(this.shape_);
        this.shape_ = null;

        this.clearPreviousResults(false);
        this.searchItems = null;
        this.searchMask_.removeChild(this.searchBackground);
        this.searchMask_ = null;
        this.searchBackground = null;

        if (this.searchScroll != null)
        {
            this.searchScroll.removeEventListener(Event.CHANGE, this.onSearchScrollChanged);
            this.searchScroll = null;
        }

        this.clearPreviousResults(true);
        this.resultItems_ = null;

        this.resultMask_.removeChild(this.resultBackground_);
        this.resultMask_ = null;
        this.resultBackground_ = null;

        if (this.resultScroll_ != null)
        {
            this.resultScroll_.content = null;
            this.resultScroll_ = null;
        }

        this.sortChoices_.removeEventListener(Event.CHANGE, this.onSortChoicesChanged);
        this.sortChoices_ = null;

        super.dispose();
    }
}
}
