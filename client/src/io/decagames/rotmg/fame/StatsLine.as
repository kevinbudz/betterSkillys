// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//io.decagames.rotmg.fame.StatsLine

package io.decagames.rotmg.fame
{
    import flash.display.Sprite;
    import flash.display.GraphicsSolidFill;
    import flash.display.GraphicsPath;
    import io.decagames.rotmg.ui.labels.UILabel;
    import flash.display.Bitmap;
    import flash.text.TextFormat;
    import kabam.rotmg.text.model.FontModel;
    import flash.text.TextFormatAlign;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.util.AssetLibrary;
    import io.decagames.rotmg.utils.colors.Tint;
    import flash.display.IGraphicsData;
    import com.company.util.GraphicsUtil;
    
    

    public class StatsLine extends Sprite 
    {

        public static const TYPE_BONUS:int = 0;
        public static const TYPE_STAT:int = 1;
        public static const TYPE_TITLE:int = 2;

        private var backgroundFill_:GraphicsSolidFill = new GraphicsSolidFill(0x1E1E1E);
        private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        private var lineWidth:int = 306;
        protected var lineHeight:int;
        private var _tooltipText:String;
        private var _lineType:int;
        private var isLocked:Boolean;
        protected var fameValue:UILabel = new UILabel();
        protected var label:UILabel;
        protected var lock:Bitmap;
        private var _labelText:String;

        public function StatsLine(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:int, _arg_5:Boolean=false)
        {
            var _local_8:int;
            super();
            var _local_6:TextFormat = new TextFormat();
            _local_6.color = 0x8A8A8A;
            _local_6.font = FontModel.DEFAULT_FONT_NAME;
            _local_6.size = 13;
            _local_6.bold = true;
            _local_6.align = TextFormatAlign.LEFT;
            this.isLocked = _arg_5;
            this._lineType = _arg_4;
            this._labelText = _arg_1;
            if (_arg_4 == TYPE_TITLE)
            {
                _local_6.size = 15;
                _local_6.color = 0xFFFFFF;
            }
            var _local_7:TextFormat = new TextFormat();
            if (_arg_4 == TYPE_BONUS)
            {
                _local_7.color = 0xFFC800;
            }
            else
            {
                _local_7.color = 5544494;
            }
            _local_7.font = FontModel.DEFAULT_FONT_NAME;
            _local_7.size = 13;
            _local_7.bold = true;
            _local_7.align = TextFormatAlign.LEFT;
            this.label = new UILabel();
            this.label.defaultTextFormat = _local_6;
            addChild(this.label);
            this.label.text = _arg_1;
            if (!_arg_5)
            {
                this.fameValue = new UILabel();
                this.fameValue.defaultTextFormat = _local_7;
                if (((_arg_2 == "0") || (_arg_2 == "0.00%")))
                {
                    this.fameValue.defaultTextFormat = _local_6;
                }
                if (_arg_4 == TYPE_BONUS)
                {
                    this.fameValue.text = ("+" + _arg_2);
                }
                else
                {
                    this.fameValue.text = _arg_2;
                }
                this.fameValue.x = ((this.lineWidth - 4) - this.fameValue.textWidth);
                addChild(this.fameValue);
                this.fameValue.y = 2;
            }
            else
            {
                _local_8 = 36;
                this.lock = new Bitmap(TextureRedrawer.resize(AssetLibrary.getImageFromSet("lofiInterface2", 5), null, _local_8, true, 0, 0));
                Tint.add(this.lock, 9971490, 1);
                addChild(this.lock);
                this.lock.x = ((this.lineWidth - _local_8) + 5);
                this.lock.y = -8;
            }
            this.setLabelsPosition();
            this._tooltipText = _arg_3;
        }

        protected function setLabelsPosition():void
        {
            this.label.y = 2;
            this.label.x = 2;
            this.lineHeight = 20;
        }

        public function clean():void
        {
            if (this.lock)
            {
                removeChild(this.lock);
                this.lock.bitmapData.dispose();
            }
        }

        public function drawBrightBackground():void
        {
            var _local_1:Vector.<IGraphicsData> = new <IGraphicsData>[this.backgroundFill_, this.path_, GraphicsUtil.END_FILL];
            GraphicsUtil.drawCutEdgeRect(0, 0, this.lineWidth, this.lineHeight, 5, [1, 1, 1, 1], this.path_);
            graphics.drawGraphicsData(_local_1);
        }

        public function get tooltipText():String
        {
            return (this._tooltipText);
        }

        public function get lineType():int
        {
            return (this._lineType);
        }

        public function get labelText():String
        {
            return (this._labelText);
        }


    }
}//package io.decagames.rotmg.fame

