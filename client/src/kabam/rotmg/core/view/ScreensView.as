package kabam.rotmg.core.view
{
   import flash.display.Sprite;
   
   public class ScreensView extends Sprite
   {
       
      
      private var current:Sprite;
      
      private var previous:Sprite;
      
      public function ScreensView()
      {
         super();
      }
      
      public function setScreen(sprite:Sprite) : void
      {
         if(this.current == sprite)
         {
            return;
         }
         this.removePrevious();
         this.current = sprite;
         addChild(sprite);
      }
      
      private function removePrevious() : void
      {
         if(this.current && contains(this.current))
         {
            this.previous = this.current;
            removeChild(this.current);
         }
      }
      
      public function getPrevious() : Sprite
      {
         return this.previous;
      }
   }
}
