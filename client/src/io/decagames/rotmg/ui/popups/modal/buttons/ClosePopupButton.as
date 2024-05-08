package io.decagames.rotmg.ui.popups.modal.buttons
{
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class ClosePopupButton extends SliceScalingButton
   {
       
      
      public function ClosePopupButton(param1:String)
      {
         super(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
         setLabel(param1,DefaultLabelFormat.defaultButtonLabel);
         width = 100;
      }
   }
}
