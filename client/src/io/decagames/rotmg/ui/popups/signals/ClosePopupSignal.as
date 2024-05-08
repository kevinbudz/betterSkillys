package io.decagames.rotmg.ui.popups.signals
{
   import io.decagames.rotmg.ui.popups.BasePopup;
   import org.osflash.signals.Signal;
   
   public class ClosePopupSignal extends Signal
   {
       
      
      public function ClosePopupSignal()
      {
         super(BasePopup);
      }
   }
}
