package kabam.rotmg.game.view.components
{
   import flash.display.DisplayObjectContainer;
   
   public class QueuedStatusTextList
   {
      public var target:DisplayObjectContainer;
      private var head:QueuedStatusText;
      private var tail:QueuedStatusText;

      public function shift() : void
      {
         this.target.removeChild(this.head);
         this.head = this.head.next;
         if (this.head){
            this.target.addChild(this.head);
         } else {
            this.tail = null;
         }
      }
      
      public function append(text:QueuedStatusText) : void
      {
         text.list = this;
         if(this.tail)
         {
            this.tail.next = text;
            this.tail = text;
         }
         else
         {
            this.head = this.tail = text;
            this.target.addChild(text);
         }
      }
   }
}
