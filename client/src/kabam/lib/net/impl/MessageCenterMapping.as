package kabam.lib.net.impl
{
   import kabam.lib.net.api.MessageHandlerProxy;
   import kabam.lib.net.api.MessageMapping;
   import org.swiftsuspenders.Injector;
   
   public class MessageCenterMapping implements MessageMapping
   {
      private const nullHandler:NullHandlerProxy = new NullHandlerProxy();
      
      private var id:int;
      
      private var injector:Injector;
      
      private var messageType:Class;
      
      private var population:int = 1;
      
      private var handler:MessageHandlerProxy;
      
      public function MessageCenterMapping()
      {
         this.handler = this.nullHandler;
         super();
      }
      
      public function setID(id:int) : MessageMapping
      {
         this.id = id;
         return this;
      }
      
      public function setInjector(injector:Injector) : MessageCenterMapping
      {
         this.injector = injector;
         return this;
      }
      
      public function toMessage(messageType:Class) : MessageMapping
      {
         this.messageType = messageType;
         return this;
      }
      
      public function toHandler(handlerType:Class) : MessageMapping
      {
         this.handler = new ClassHandlerProxy().setType(handlerType).setInjector(this.injector);
         return this;
      }
      
      public function toMethod(method:Function) : MessageMapping
      {
         this.handler = new MethodHandlerProxy().setMethod(method);
         return this;
      }
      
      public function setPopulation(population:int) : MessageMapping
      {
         this.population = population;
         return this;
      }
      
      public function makePool() : MessagePool
      {
         var pool:MessagePool = new MessagePool(this.id,this.messageType,this.handler.getMethod());
         pool.populate(this.population);
         return pool;
      }
   }
}

import kabam.lib.net.api.MessageHandlerProxy;

class NullHandlerProxy implements MessageHandlerProxy
{
    
   
   function NullHandlerProxy()
   {
      super();
   }
   
   public function getMethod() : Function
   {
      return null;
   }
}
