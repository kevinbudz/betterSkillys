package io.decagames.rotmg.ui.buttons
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.text.TextFormatAlign;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   
   public class InfoButton extends BaseButton
   {
       
      
      private var _background:Shape;
      
      private var _label:UILabel;
      
      private var _radius:int;
      
      public function InfoButton(param1:int)
      {
         super();
         this._radius = param1;
         this.init();
      }
      
      private function init() : void
      {
         this.createBackground();
         this.createLabel();
         this.buttonMode = true;
      }
      
      private function createBackground() : void
      {
         this._background = new Shape();
         var _loc1_:Graphics = this._background.graphics;
         _loc1_.beginFill(16777215);
         _loc1_.drawCircle(0,0,this._radius);
         addChild(this._background);
      }
      
      private function createLabel() : void
      {
         this._label = new UILabel();
         DefaultLabelFormat.createLabelFormat(this._label,16,255,TextFormatAlign.CENTER,true);
         this._label.text = "i";
         this._label.x = -this._radius / 2 + 1;
         this._label.y = -this._radius / 2 - 4;
         addChild(this._label);
      }
   }
}
