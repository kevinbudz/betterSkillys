package com.company.assembleegameclient.ui
{
import flash.text.engine.CFFHinting;
import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.FontLookup;
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;
import flash.text.engine.RenderingMode;

public class ElementFormats
{
   private static var FONT_DESCRIPTION:String = "MyriadProBoldCFF,_sans";

   public var normalFormat_:ElementFormat = null;
   public var serverFormat_:ElementFormat = null;
   public var clientFormat_:ElementFormat = null;
   public var helpFormat_:ElementFormat = null;
   public var errorFormat_:ElementFormat = null;
   public var adminFormat_:ElementFormat = null;
   public var enemyFormat_:ElementFormat = null;
   public var playerFormat_:ElementFormat = null;
   public var sepFormat_:ElementFormat = null;
   public var tellFormat_:ElementFormat = null;
   public var guildFormat_:ElementFormat = null;
   public var exportFormat_:ElementFormat = null;
   public var partyFormat_:ElementFormat = null;
   public var subtextFormat:ElementFormat = null;

   public function ElementFormats(color:int = 0xFFFFFF)
   {
      super();
      this.normalFormat_ = newDefaultFormat();
      this.normalFormat_.color = 0xFFFFFF;
      this.serverFormat_ = newDefaultFormat();
      this.serverFormat_.color = 0xFFFF00;
      this.clientFormat_ = newDefaultFormat();
      this.clientFormat_.color = 0xFF;
      this.helpFormat_ = newDefaultFormat();
      this.helpFormat_.color = 0xFF5B05;
      this.errorFormat_ = newDefaultFormat();
      this.errorFormat_.color = 0xFF0000;
      this.adminFormat_ = newDefaultFormat();
      this.adminFormat_.color = 0xFFFF00;
      this.enemyFormat_ = newDefaultFormat();
      this.enemyFormat_.color = 0xFFA800;
      this.playerFormat_ = newDefaultFormat();
      this.playerFormat_.color = 0xFF00;
      this.sepFormat_ = newDefaultFormat();
      this.sepFormat_.color = 0x363636;
      this.tellFormat_ = newDefaultFormat();
      this.tellFormat_.color = 0xF0FF;
      this.guildFormat_ = newDefaultFormat();
      this.guildFormat_.color = 0xA6FF5D;
      this.partyFormat_ = newDefaultFormat();
      this.partyFormat_.color = 0x78a0ff;
      this.exportFormat_ = newDefaultFormat();
      this.exportFormat_.color = color;
      this.subtextFormat = newDefaultFormat();
      this.subtextFormat.color = 0xCCBB00;
   }

   private static function newDefaultFormat() : ElementFormat
   {
      var elementFormat:ElementFormat = new ElementFormat();
      elementFormat.fontDescription = new FontDescription(FONT_DESCRIPTION,FontWeight.BOLD,FontPosture.NORMAL,FontLookup.EMBEDDED_CFF,RenderingMode.CFF,CFFHinting.HORIZONTAL_STEM);
      elementFormat.fontSize = 14;
      return elementFormat;
   }
}
}
