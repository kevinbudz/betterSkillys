// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//io.decagames.rotmg.fame.FameContentPopup

package io.decagames.rotmg.fame
{
    import io.decagames.rotmg.ui.popups.modal.ModalPopup;
    import io.decagames.rotmg.ui.sliceScaling.SliceScalingBitmap;
    import flash.display.Bitmap;
    import io.decagames.rotmg.ui.labels.UILabel;
    import flash.display.Sprite;
    import io.decagames.rotmg.ui.buttons.SliceScalingButton;
    import io.decagames.rotmg.ui.tabs.UITabs;
    import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
    import flash.geom.Rectangle;
    import io.decagames.rotmg.ui.texture.TextureParser;
    import io.decagames.rotmg.ui.popups.header.PopupHeader;
    import kabam.rotmg.assets.services.IconFactory;
    import flash.display.BitmapData;
    import io.decagames.rotmg.ui.tabs.UITab;
    import io.decagames.rotmg.ui.scroll.UIScrollbar;

import kabam.rotmg.stage3D.Renderer;

public class FameContentPopup extends ModalPopup
    {

        private var characterDecorationBG:SliceScalingBitmap;
        private var contentTabs:SliceScalingBitmap;
        private var contentInset:SliceScalingBitmap;
        private var fameBitmap:Bitmap;
        private var fameOnDeathTitle:UILabel;
        private var fameOnDeathLabel:UILabel;
        private var statsLinesPosition:int = 0;
        private var dungeonLinesPosition:int = 0;
        private var statsContainer:Sprite;
        private var dungeonContainer:Sprite;
        private var totalFameBitmap:Bitmap;
        private var totalFame:UILabel;
        private var characterNameLabel:UILabel;
        private var characterInfoLabel:UILabel;
        private var characterDateLabel:UILabel;
        public var infoButton:SliceScalingButton;
        public var characterId:int;
        private var tabs:UITabs;

        public function FameContentPopup(_arg_1:int=-1)
        {
            super(340, 505, "Fame Overview", DefaultLabelFormat.defaultSmallPopupTitle);
            this.x = Renderer.inGame ? 130 : 230;
            this.y = 17;
            this.characterId = _arg_1;
            this.infoButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI", "info_button"));
            _header.addButton(this.infoButton, PopupHeader.LEFT_BUTTON);
            this.characterNameLabel = new UILabel();
            this.characterInfoLabel = new UILabel();
            this.characterDateLabel = new UILabel();
            DefaultLabelFormat.characterFameNameLabel(this.characterNameLabel);
            DefaultLabelFormat.characterFameInfoLabel(this.characterInfoLabel);
            DefaultLabelFormat.characterFameInfoLabel(this.characterDateLabel);
            this.characterNameLabel.x = 75;
            this.characterNameLabel.y = 8;
            this.characterInfoLabel.x = 75;
            this.characterInfoLabel.y = 30;
            this.characterDateLabel.x = 75;
            this.characterDateLabel.y = 42;
            addChild(this.characterNameLabel);
            addChild(this.characterInfoLabel);
            addChild(this.characterDateLabel);
            this.totalFame = new UILabel();
            DefaultLabelFormat.currentFameLabel(this.totalFame);
            addChild(this.totalFame);
            var _local_2:BitmapData = IconFactory.makeFame();
            this.fameBitmap = new Bitmap(_local_2);
            addChild(this.fameBitmap);
            var _local_3:BitmapData = IconFactory.makeFame();
            this.totalFameBitmap = new Bitmap(_local_3);
            addChild(this.totalFameBitmap);
            this.characterDecorationBG = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_decoration", 69);
            addChild(this.characterDecorationBG);
            this.characterDecorationBG.height = 80;
            this.characterDecorationBG.x = 0;
            this.characterDecorationBG.y = 5;
            this.contentTabs = TextureParser.instance.getSliceScalingBitmap("UI", "tab_inset_content_background", 340);
            addChild(this.contentTabs);
            this.contentTabs.height = 45;
            this.contentTabs.x = 0;
            this.contentTabs.y = 90;
            this.contentInset = TextureParser.instance.getSliceScalingBitmap("UI", "popup_content_inset", 340);
            addChild(this.contentInset);
            this.contentInset.height = 353;
            this.contentInset.x = 0;
            this.contentInset.y = 125;
            this.tabs = new UITabs(340, true);
            this.tabs.addTab(this.createStatsTab(), true);
            this.tabs.addTab(this.createDungeonTab());
            this.tabs.y = 91;
            this.tabs.x = 0;
            addChild(this.tabs);
            this.fameOnDeathTitle = new UILabel();
            DefaultLabelFormat.deathFameLabel(this.fameOnDeathTitle);
            addChild(this.fameOnDeathTitle);
            this.fameOnDeathLabel = new UILabel();
            DefaultLabelFormat.deathFameCount(this.fameOnDeathLabel);
            addChild(this.fameOnDeathLabel);
        }

        private function createStatsTab():UITab
        {
            var _local_1:UITab;
            var _local_2:Sprite;
            var _local_4:Sprite;
            _local_1 = new UITab("Statistics", true);
            _local_2 = new Sprite();
            this.statsContainer = new Sprite();
            this.statsContainer.x = this.contentInset.x;
            this.statsContainer.y = 2;
            _local_2.addChild(this.statsContainer);
            var _local_3:UIScrollbar = new UIScrollbar(338);
            _local_3.mouseRollSpeedFactor = 1;
            _local_3.scrollObject = _local_1;
            _local_3.content = this.statsContainer;
            _local_2.addChild(_local_3);
            _local_3.x = ((this.contentInset.x + this.contentInset.width) - 25);
            _local_3.y = 7;
            _local_4 = new Sprite();
            _local_4.graphics.beginFill(0);
            _local_4.graphics.drawRect(0, 0, 340, 342);
            _local_4.x = this.statsContainer.x;
            _local_4.y = this.statsContainer.y;
            this.statsContainer.mask = _local_4;
            _local_2.addChild(_local_4);
            _local_1.addContent(_local_2);
            return (_local_1);
        }

        private function createDungeonTab():UITab
        {
            var _local_1:UITab = new UITab("Dungeons", true);
            var _local_2:Sprite = new Sprite();
            this.dungeonContainer = new Sprite();
            this.dungeonContainer.x = this.contentInset.x;
            this.dungeonContainer.y = 2;
            _local_2.addChild(this.dungeonContainer);
            var _local_3:UIScrollbar = new UIScrollbar(338);
            _local_3.mouseRollSpeedFactor = 1;
            _local_3.scrollObject = _local_1;
            _local_3.content = this.dungeonContainer;
            _local_2.addChild(_local_3);
            _local_3.x = ((this.contentInset.x + this.contentInset.width) - 25);
            _local_3.y = 7;
            var _local_4:Sprite = new Sprite();
            _local_4.graphics.beginFill(0);
            _local_4.graphics.drawRect(0, 0, 340, 342);
            _local_4.x = this.dungeonContainer.x;
            _local_4.y = this.dungeonContainer.y;
            this.dungeonContainer.mask = _local_4;
            _local_2.addChild(_local_4);
            _local_1.addContent(_local_2);
            return (_local_1);
        }

        public function set fameOnDeath(_arg_1:int):void
        {
            this.fameOnDeathTitle.text = "Fame on Death:";
            this.fameOnDeathTitle.x = 0;
            this.fameOnDeathTitle.y = 485;
            this.fameOnDeathLabel.text = _arg_1.toString();
            this.fameOnDeathLabel.x = ((330 - this.fameOnDeathLabel.textWidth) - this.fameBitmap.width);
            this.fameOnDeathLabel.y = 485;
            this.fameBitmap.x = ((this.fameOnDeathLabel.x + this.fameOnDeathLabel.textWidth) + 3);
            this.fameBitmap.y = this.fameOnDeathLabel.y;
        }

        public function setCharacterData(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:String, _arg_5:String, _arg_6:BitmapData):void
        {
            this.totalFame.text = _arg_1.toString();
            this.totalFame.x = 75;
            this.totalFame.y = 60;
            this.totalFameBitmap.x = ((this.totalFame.x + this.totalFame.textWidth) + 3);
            this.totalFameBitmap.y = (this.totalFame.y + 1);
            this.characterNameLabel.text = _arg_2;
            this.characterInfoLabel.text = ((("Level " + _arg_3) + ", ") + _arg_4);
            this.characterDateLabel.text = ("Created on " + _arg_5);
            var _local_7:Bitmap = new Bitmap(_arg_6);
            _local_7.x = Math.round((this.characterDecorationBG.x + ((68 - _local_7.width) / 2)));
            _local_7.y = Math.round((this.characterDecorationBG.y + ((80 - _local_7.height) / 2)));
            addChild(_local_7);
        }

        public function addDungeonLine(_arg_1:StatsLine):void
        {
            var _local_2:int;
            if (this.dungeonLinesPosition >= 1)
            {
                _local_2 = 5;
            }
            else
            {
                _local_2 = 0;
            }
            _arg_1.x = 6;
            _arg_1.y = ((this.dungeonLinesPosition * 27) - _local_2);
            this.dungeonContainer.addChild(_arg_1);
            if ((this.dungeonLinesPosition % 2) == 1)
            {
                _arg_1.drawBrightBackground();
            }
            this.dungeonLinesPosition++;
        }

        public function addStatLine(_arg_1:StatsLine):void
        {
            _arg_1.x = 6;
            _arg_1.y = (this.statsLinesPosition * 22);
            this.statsContainer.addChild(_arg_1);
            if ((this.statsLinesPosition % 2) == 1)
            {
                _arg_1.drawBrightBackground();
            }
            this.statsLinesPosition++;
        }


    }
}//package io.decagames.rotmg.fame

