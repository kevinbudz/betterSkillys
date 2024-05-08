package io.decagames.rotmg.ui.popups.signals
{
   import io.decagames.rotmg.ui.popups.BasePopup;
   import org.osflash.signals.Signal;
   
   public class ShowPopupSignal extends Signal
   {
       
      
      public function ShowPopupSignal()
      {
         super(BasePopup);
      }
   }
}
