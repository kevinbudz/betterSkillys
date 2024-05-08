package kabam.lib.ui.api
{
   import org.osflash.signals.Signal;
   
   public interface Scrollbar
   {
       
      
      function get positionChanged() : Signal;
      
      function setSize(param1:int, param2:int) : void;
      
      function getBarSize() : int;
      
      function getGrooveSize() : int;
      
      function getPosition() : Number;
      
      function setPosition(param1:Number) : void;
   }
}
