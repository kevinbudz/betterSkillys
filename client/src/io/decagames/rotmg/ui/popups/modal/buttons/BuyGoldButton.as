package io.decagames.rotmg.ui.popups.modal.buttons
{
   import io.decagames.rotmg.ui.buttons.SliceScalingButton;
   import io.decagames.rotmg.ui.defaults.DefaultLabelFormat;
   import io.decagames.rotmg.ui.texture.TextureParser;
   
   public class BuyGoldButton extends SliceScalingButton
   {
       
      
      public function BuyGoldButton()
      {
         super(TextureParser.instance.getSliceScalingBitmap("UI","generic_green_button"));
         setLabel("Buy Gold",DefaultLabelFormat.defaultButtonLabel);
         width = 100;
      }
   }
}
