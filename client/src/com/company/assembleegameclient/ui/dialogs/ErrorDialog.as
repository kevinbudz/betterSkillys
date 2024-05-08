package com.company.assembleegameclient.ui.dialogs
{
   import org.osflash.signals.Signal;
   import org.osflash.signals.natives.NativeMappedSignal;
   
   public class ErrorDialog extends Dialog
   {
       
      
      public var ok:Signal;
      
      public function ErrorDialog(errorText:String)
      {
         super("An error has occured:\n" + errorText,"D\'oh, this isn\'t good","Ok",null);
         this.ok = new NativeMappedSignal(this,BUTTON1_EVENT);
      }
   }
}
