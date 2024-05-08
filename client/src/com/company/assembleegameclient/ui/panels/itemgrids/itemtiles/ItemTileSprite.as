package com.company.assembleegameclient.ui.panels.itemgrids.itemtiles
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.ColorMatrixFilter;
   import flash.geom.Matrix;
import flash.utils.Timer;

import kabam.rotmg.constants.ItemConstants;
   
   public class ItemTileSprite extends Sprite
   {
      
      protected static const DIM_FILTER:Array = [new ColorMatrixFilter([0.4,0,0,0,0,0,0.4,0,0,0,0,0,0.4,0,0,0,0,0,1,0])];
      
      private static const DOSE_MATRIX:Matrix = function():Matrix
      {
         var m:* = new Matrix();
         m.translate(10,5);
         return m;
      }();
       
      
      public var itemId:int;

      public var itemData:Object;
      
      public var itemBitmap:Bitmap;
      
      public function ItemTileSprite()
      {
         super();
         this.itemBitmap = new Bitmap();
         addChild(this.itemBitmap);
         this.itemId = -1;
         this.itemData = null;
      }
      
      public function setDim(dim:Boolean) : void
      {
         filters = dim?DIM_FILTER:null;
      }
      
      public function setType(displayedItemType:int, data:Object) : void
      {
         var texture:BitmapData = null;
         var eqXML:XML = null;
         var tempText:SimpleText = null;
         this.itemId = displayedItemType;
         this.itemData = data;
         if(this.itemId != ItemConstants.NO_ITEM)
         {
            texture = ObjectLibrary.getRedrawnTextureFromType(this.itemId,80,true);
            eqXML = ObjectLibrary.xmlLibrary_[this.itemId];

             if(eqXML == null){
                 this.itemId = -1;
             }

            if(this.itemData != null && this.itemData.Stack > 0)
            {
               texture = texture.clone();
               tempText = new SimpleText(12,16777215,false,0,0);
               tempText.text = String(this.itemData.Stack);
               tempText.updateMetrics();
               texture.draw(tempText,DOSE_MATRIX);
            }
            else if(eqXML && eqXML.hasOwnProperty("Doses"))
            {
               texture = texture.clone();
               tempText = new SimpleText(12,16777215,false,0,0);
               tempText.text = String(eqXML.Doses);
               tempText.updateMetrics();
               texture.draw(tempText,DOSE_MATRIX);
            }
            else if(eqXML && eqXML.hasOwnProperty("Quantity"))
            {
               texture = texture.clone();
               tempText = new SimpleText(12,16777215,false,0,0);
               tempText.text = String(eqXML.Quantity);
               tempText.updateMetrics();
               texture.draw(tempText,DOSE_MATRIX);
            }
             var spriteFile:String = null;
             var spriteArray:Array = null;
             var spritePeriod:Number = -1;
             var first:Number = -1;
             var last:Number = -1;
             var next:Number = -1;
             var makeAnimation:Function;
             var hasPeriod:Boolean = !eqXML ? false : eqXML.hasOwnProperty("@spritePeriod");
             var hasFile:Boolean = !eqXML ? false : eqXML.hasOwnProperty("@spriteFile");
             var hasArray:Boolean = !eqXML ? false : eqXML.hasOwnProperty("@spriteArray");
             var hasAnimatedSprites:Boolean = hasPeriod && hasFile && hasArray;

             if (hasPeriod)
                 spritePeriod = 1000 / eqXML.attribute("spritePeriod");

             if (hasFile)
                 spriteFile = eqXML.attribute("spriteFile");

             if (hasArray) {
                 spriteArray = String(eqXML.attribute("spriteArray")).split('-');
                 first = Parameters.parse(spriteArray[0]);
                 last = Parameters.parse(spriteArray[1]);
             }

             this.itemBitmap.bitmapData = texture;
            this.itemBitmap.x = -texture.width / 2;
            this.itemBitmap.y = -texture.height / 2;

             if (hasAnimatedSprites && spritePeriod != -1 && spriteFile != null && spriteArray != null && first != -1 && last != -1) {
                 this.spriteFile = spriteFile;
                 this.first = first;
                 this.last = last;
                 this.next = this.first;
                 var animatedTimer:Timer = new Timer(spritePeriod);
                 animatedTimer.addEventListener(TimerEvent.TIMER, this.makeAnimation);
                 animatedTimer.start();
             } else {
                 this.spriteFile = null;
                 this.first = this.last = this.next = -1;
             }

             visible = true;
         }
         else
         {
            visible = false;
         }
      }
       private var iconSize:Number = 60;
       private var spriteFile:String;
       private var first:Number;
       private var last:Number;
       private var next:Number;

       private function makeAnimation(event:TimerEvent = null):void {
           if (this.spriteFile == null)
               return;

           var size:int = this.iconSize;
           var bitmapData:BitmapData = AssetLibrary.getImageFromSet(this.spriteFile, this.next);

         //  if (Parameters.itemTypes16.indexOf(this.itemId) != -1 || bitmapData.height == 16)
         //      size = (size * 0.5);

           bitmapData = TextureRedrawer.redraw(bitmapData, size, true, 0, true, 5);

           this.itemBitmap.bitmapData = bitmapData;
           this.itemBitmap.x = -bitmapData.width/2;
           this.itemBitmap.y = -bitmapData.height/2;

           this.next++;

           if (this.next > this.last)
               this.next = this.first;
       }
   }
}
