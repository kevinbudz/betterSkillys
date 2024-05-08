package kabam.lib.net.impl
{
   import kabam.lib.net.api.MessageHandlerProxy;
   import org.swiftsuspenders.Injector;
   
   public class ClassHandlerProxy implements MessageHandlerProxy
   {
       
      
      private var injector:Injector;
      
      private var handlerType:Class;
      
      private var handler:Object;
      
      public function ClassHandlerProxy()
      {
         super();
      }
      
      public function setType(handlerType:Class) : ClassHandlerProxy
      {
         this.handlerType = handlerType;
         return this;
      }
      
      public function setInjector(injector:Injector) : ClassHandlerProxy
      {
         this.injector = injector;
         return this;
      }
      
      public function getMethod() : Function
      {
         return Boolean(this.handler)?this.handler.execute:this.makeHandlerAndReturnExecute();
      }
      
      private function makeHandlerAndReturnExecute() : Function
      {
         if(!this.handlerType)
         {
            return null;
         }
         this.handler = this.injector.getInstance(this.handlerType);
         return this.handler.execute;
      }
   }
}
