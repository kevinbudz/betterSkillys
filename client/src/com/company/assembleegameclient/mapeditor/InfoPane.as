package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.RegionLibrary;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.ui.SimpleText;
   import com.company.util.GraphicsUtil;
   import flash.display.CapsStyle;
   import flash.display.GraphicsPath;
   import flash.display.GraphicsSolidFill;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.display.JointStyle;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.geom.Rectangle;
   import flash.text.StyleSheet;
   
   public class InfoPane extends Sprite
   {
      
      public static const WIDTH:int = 134;
      
      public static const HEIGHT:int = 150;
      
      private static const CSS_TEXT:String = ".in { margin-left:10px; text-indent: -10px; }";
       
      
      private var meMap_:MEMap;
      
      private var rectText_:SimpleText;
      
      private var typeText_:SimpleText;
      
      private var outlineFill_:GraphicsSolidFill = new GraphicsSolidFill(16777215,1);
      
      private var lineStyle_:GraphicsStroke= new GraphicsStroke(1,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,outlineFill_);
      
      private var backgroundFill_:GraphicsSolidFill= new GraphicsSolidFill(3552822,1);
      
      private var path_:GraphicsPath= new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private const graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[lineStyle_,backgroundFill_,path_,GraphicsUtil.END_FILL,GraphicsUtil.END_STROKE];
      
      public function InfoPane(meMap:MEMap)
      {
         super();
         this.meMap_ = meMap;
         this.drawBackground();
         this.rectText_ = new SimpleText(12,16777215,false,WIDTH - 10,0);
         this.rectText_.filters = [new DropShadowFilter(0,0,0)];
         this.rectText_.y = 4;
         this.rectText_.x = 4;
         addChild(this.rectText_);
         var sheet:StyleSheet = new StyleSheet();
         sheet.parseCSS(CSS_TEXT);
         this.typeText_ = new SimpleText(12,16777215,false,WIDTH - 10,0);
         this.typeText_.styleSheet = sheet;
         this.typeText_.wordWrap = true;
         this.typeText_.filters = [new DropShadowFilter(0,0,0)];
         this.typeText_.x = 4;
         this.typeText_.y = 36;
         addChild(this.typeText_);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var mouseRectT:Rectangle = this.meMap_.mouseRectT();
         this.rectText_.text = "Position: " + mouseRectT.x + ", " + mouseRectT.y;
         if(mouseRectT.width > 1 || mouseRectT.height > 1)
         {
            this.rectText_.text = this.rectText_.text + ("\nRect: " + mouseRectT.width + ", " + mouseRectT.height);
         }
         this.rectText_.useTextDimensions();
         var tile:METile = this.meMap_.getTile(mouseRectT.x,mouseRectT.y);
         var types:Vector.<int> = tile == null?Layer.EMPTY_TILE:tile.types_;
         var groundId:String = types[Layer.GROUND] == -1?"None":GroundLibrary.getIdFromType(types[Layer.GROUND]);
         var objectId:String = types[Layer.OBJECT] == -1?"None":ObjectLibrary.getIdFromType(types[Layer.OBJECT]);
         var regionId:String = types[Layer.REGION] == -1?"None":RegionLibrary.getIdFromType(types[Layer.REGION]);
         this.typeText_.text = "<span class=\'in\'>" + "Ground: " + groundId + "\nObject: " + objectId + (tile == null || tile.objName_ == null?"":" (" + tile.objName_ + ")") + "\nRegion: " + regionId + "</span>";
         this.typeText_.useTextDimensions();
      }
      
      private function drawBackground() : void
      {
         GraphicsUtil.clearPath(this.path_);
         GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,[1,1,1,1],this.path_);
         graphics.drawGraphicsData(this.graphicsData_);
      }
   }
}
