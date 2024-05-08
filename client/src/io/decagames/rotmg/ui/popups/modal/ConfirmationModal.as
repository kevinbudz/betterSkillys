package io.decagames.rotmg.ui.popups.modal
{
   import io.decagames.rotmg.ui.buttons.BaseButton;
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.popups.modal.buttons.ClosePopupButton;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class ConfirmationModal extends TextModal
   {
       
      
      public var confirmButton:SliceScalingButton;
      
      public function ConfirmationModal(param1:int, param2:String, param3:String, param4:String, param5:String, param6:int = 100)
      {
         var _loc7_:Vector.<BaseButton> = null;
         _loc7_ = new Vector.<BaseButton>();
         var _loc8_:ClosePopupButton = new ClosePopupButton(param5);
         _loc8_.width = param6;
         this.confirmButton = new SliceScalingButton(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
         this.confirmButton.setLabel(param4,DefaultLabelFormat.defaultButtonLabel);
         this.confirmButton.width = param6;
         _loc7_.push(this.confirmButton);
         _loc7_.push(_loc8_);
         super(param1,param2,param3,_loc7_);
      }
   }
}
