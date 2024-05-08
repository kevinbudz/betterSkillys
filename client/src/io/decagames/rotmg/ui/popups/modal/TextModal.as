package io.decagames.rotmg.ui.popups.modal
{
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.labels.UILabel;
   
   public class TextModal extends ModalPopup
   {
       
      
      private var buttonsMargin:int = 30;
      
      public function TextModal(param1:int, param2:String, param3:String, param4:Vector.<BaseButton>, param5:Boolean = false)
      {
         var _loc6_:UILabel = null;
         var _loc8_:BaseButton = null;
         var _loc9_:int = 0;
         super(param1,0,param2);
         _loc6_ = new UILabel();
         _loc6_.multiline = true;
         DefaultLabelFormat.defaultTextModalText(_loc6_);
         _loc6_.multiline = true;
         _loc6_.width = param1;
         if(param5)
         {
            _loc6_.htmlText = param3;
         }
         else
         {
            _loc6_.text = param3;
         }
         _loc6_.wordWrap = true;
         addChild(_loc6_);
         var _loc7_:int = 0;
         for each(_loc8_ in param4)
         {
            _loc7_ = _loc7_ + _loc8_.width;
         }
         _loc7_ = _loc7_ + this.buttonsMargin * (param4.length - 1);
         _loc9_ = (param1 - _loc7_) / 2;
         for each(_loc8_ in param4)
         {
            _loc8_.x = _loc9_;
            _loc9_ = _loc9_ + (this.buttonsMargin + _loc8_.width);
            _loc8_.y = _loc6_.y + _loc6_.textHeight + 15;
            addChild(_loc8_);
            registerButton(_loc8_);
         }
      }
   }
}
