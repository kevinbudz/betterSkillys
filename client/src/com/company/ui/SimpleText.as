package com.company.ui
{

import com.company.ui.fonts.MyriadPro;
import com.company.ui.fonts.MyriadProBold;
import com.company.ui.fonts.MyriadProBoldCFF;
import com.company.ui.fonts.MyriadProCFF;

import flash.events.Event;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.text.TextLineMetrics;

import org.osflash.signals.Signal;

public class SimpleText extends TextField
   {
      private static const GUTTER:int = 16;

      public const textChanged:Signal = new Signal();

      public static const _MyriadPro:Class = MyriadPro;
      public static const _MyriadProBold:Class = MyriadProBold;
      public static const _MyriadProCFF:Class = MyriadProCFF;
      public static const _MyriadProBoldCFF:Class = MyriadProBoldCFF;
      public static const _MyriadProG:Class = BaseSimpleText_MyriadPro;
      public static var _Font:Font;
      public static var _FontRegistered:Boolean = false;
      
      public var inputWidth_:int;
      public var inputHeight_:int;
      public var actualWidth_:int;
      public var actualHeight_:int;
      
      public function SimpleText(textSize:int, color:uint, settable:Boolean = false, widthParam:int = 0, heightParam:int = 0, isLink:Boolean = false)
      {
         if (!_FontRegistered)
         {
            Font.registerFont(_MyriadPro);
            Font.registerFont(_MyriadProBold);
            Font.registerFont(_MyriadProCFF);
            Font.registerFont(_MyriadProBoldCFF);
            Font.registerFont(_MyriadProG);
            _Font = new _MyriadPro();
            _FontRegistered = true;
         }

         super();
         this.inputWidth_ = widthParam;
         if(this.inputWidth_ != 0)
         {
            width = widthParam;
         }
         this.inputHeight_ = heightParam;
         if(this.inputHeight_ != 0)
         {
            height = heightParam;
         }
         var format:TextFormat = defaultTextFormat;
         format.font = _Font.fontName;
         format.bold = false;
         format.size = textSize;
         format.color = color;
         embedFonts = true;
         defaultTextFormat = format;
         if(settable)
         {
            selectable = true;
            mouseEnabled = true;
            type = TextFieldType.INPUT;
            border = true;
            borderColor = color;
            addEventListener(Event.CHANGE,this.onChange);
         }
         else
         {
            selectable = false;
            mouseEnabled = false;
         }

         if (isLink)
         {
            mouseEnabled = true;
         }
      }
      
      public function setSize(size:int) : SimpleText
      {
         var format:TextFormat = defaultTextFormat;
         format.size = size;
         this.applyFormat(format);
         return this;
      }
      
      public function setColor(color:uint) : SimpleText
      {
         var format:TextFormat = defaultTextFormat;
         format.color = color;
         this.applyFormat(format);
         return this;
      }
      
      public function setBold(bold:Boolean) : SimpleText
      {
         var format:TextFormat = defaultTextFormat;
         format.bold = bold;
         this.applyFormat(format);
         return this;
      }
      
      public function setAlignment(alignment:String) : SimpleText
      {
         var format:TextFormat = defaultTextFormat;
         format.align = alignment;
         this.applyFormat(format);
         return this;
      }
      
      public function setText(text:String) : SimpleText
      {
         this.text = text;
         return this;
      }
      
      private function applyFormat(format:TextFormat) : void
      {
         setTextFormat(format);
         defaultTextFormat = format;
      }
      
      private function onChange(event:Event) : void
      {
         this.updateMetrics();
      }
      
      public function updateMetrics() : SimpleText
      {
         this.textChanged.dispatch();
         var textMetrics:TextLineMetrics = null;
         var textWidth:int = 0;
         var textHeight:int = 0;
         this.actualWidth_ = 0;
         this.actualHeight_ = 0;
         for(var i:int = 0; i < numLines; i++)
         {
            textMetrics = getLineMetrics(i);
            textWidth = textMetrics.width + 4;
            textHeight = textMetrics.height + 4;
            if(textWidth > this.actualWidth_)
            {
               this.actualWidth_ = textWidth;
            }
            this.actualHeight_ = this.actualHeight_ + textHeight;
         }
         width = this.inputWidth_ == 0 ? this.actualWidth_ : this.inputWidth_;
         height = this.inputHeight_ == 0 ? this.actualHeight_ :this.inputHeight_;
         return this;
      }

      public function useTextDimensions() : void
      {
         width = this.inputWidth_ == 0 ? (textWidth + 4) : (this.inputWidth_);
         height = this.inputHeight_ == 0 ? (textHeight + 4) : (this.inputHeight_);
      }

      /*override public function set x(newValue:Number) : void
      {
         super.x = newValue;
      }

      override public function set y(newValue:Number) : void
      {
         super.y = newValue;
      }*/
   }
}
