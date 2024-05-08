package kabam.rotmg.maploading.signals
{
   import kabam.rotmg.messaging.impl.incoming.MapInfo;
   import org.osflash.signals.Signal;
   
   public class ShowMapLoadingSignal extends Signal
   {
       
      
      public function ShowMapLoadingSignal()
      {
         super(MapInfo);
      }
   }
}
