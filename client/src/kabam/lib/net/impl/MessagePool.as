package kabam.lib.net.impl
{
   public class MessagePool
   {
       
      
      public var type:Class;
      
      public var callback:Function;
      
      public var id:int;
      
      private var tail:Message;
      
      private var count:int = 0;
      
      public function MessagePool(id:int, type:Class, callback:Function)
      {
         super();
         this.type = type;
         this.id = id;
         this.callback = callback;
      }
      
      public function populate(count:int) : MessagePool
      {
         var message:Message = null;
         this.count = this.count + count;
         while(count--)
         {
            message = new this.type(this.id,this.callback);
            message.pool = this;
            this.tail && (this.tail.next = message);
            message.prev = this.tail;
            this.tail = message;
         }
         return this;
      }
      
      public function require() : Message
      {
         var message:Message = this.tail;
         if(message)
         {
            this.tail = this.tail.prev;
            message.prev = null;
            message.next = null;
         }
         else
         {
            message = new this.type(this.id,this.callback);
            message.pool = this;
            this.count++;
         }
         return message;
      }
      
      public function getCount() : int
      {
         return this.count;
      }
      
      internal function append(message:Message) : void
      {
         this.tail && (this.tail.next = message);
         message.prev = this.tail;
         this.tail = message;
      }
      
      public function dispose() : void
      {
         this.tail = null;
      }
   }
}
