package kabam.lib.net.impl
{
   import kabam.lib.net.api.MessageMap;
   import kabam.lib.net.api.MessageMapping;
   import kabam.lib.net.api.MessageProvider;
   import org.swiftsuspenders.Injector;
   
   public class MessageCenter implements MessageMap, MessageProvider
   {
      private static const MAX_ID:int = 256;

      private const maps:Vector.<MessageCenterMapping> = new Vector.<MessageCenterMapping>(MAX_ID,true);
      
      private const pools:Vector.<MessagePool> = new Vector.<MessagePool>(MAX_ID,true);
      
      private var injector:Injector;
      
      public function MessageCenter()
      {
         super();
      }
      
      public function setInjector(injector:Injector) : MessageCenter
      {
         this.injector = injector;
         return this;
      }
      
      public function map(id:int) : MessageMapping
      {
         return this.maps[id] = this.maps[id] || this.makeMapping(id);
      }
      
      public function unmap(id:int) : void
      {
         this.pools[id] && this.pools[id].dispose();
         this.pools[id] = null;
         this.maps[id] = null;
      }
      
      private function makeMapping(id:int) : MessageCenterMapping
      {
         return new MessageCenterMapping().setInjector(this.injector).setID(id) as MessageCenterMapping;
      }
      
      public function require(id:int) : Message
      {
         var pool:MessagePool = this.pools[id] = this.pools[id] || this.makePool(id);
         return pool.require();
      }
      
      private function makePool(id:uint) : MessagePool
      {
         var mapping:MessageCenterMapping = this.maps[id];
         return Boolean(mapping)?mapping.makePool():null;
      }
   }
}
