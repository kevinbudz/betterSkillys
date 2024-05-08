package kabam.rotmg.servers.api
{
   public class Server
   {
       
      
      public var name:String;
      
      public var address:String;
      
      public var port:int;
      
      public var latLong:LatLong;
      
      public var usage:Number;

       public var isAdminOnly:Boolean;

       public var usageText_:String;

      public function Server()
      {
         super();
      }
      
      public function setName(name:String) : Server
      {
         this.name = name;
         return this;
      }
      
      public function setAddress(address:String) : Server
      {
         this.address = address;
         return this;
      }
      
      public function setPort(port:int) : Server
      {
         this.port = port;
         return this;
      }
      
      public function setLatLong(latitude:Number, longitude:Number) : Server
      {
         this.latLong = new LatLong(latitude,longitude);
         return this;
      }
      
      public function setUsage(usage:Number) : Server
      {
         this.usage = usage;
         return this;
      }
      
      public function setIsAdminOnly(isAdminOnly:Boolean) : Server
      {
         this.isAdminOnly = isAdminOnly;
         return this;
      }

      public function setUsageText(usageText:String):Server{
          this.usageText_ = usageText;
          return this;
      }
      
      public function priority() : int
      {
         if(this.isAdminOnly)
         {
            return 2;
         }
         if(this.isCrowded())
         {
            return 1;
         }
         return 0;
      }
      
      public function isCrowded() : Boolean
      {
         return this.usage >= 0.66;
      }

       public function isFull() : Boolean
       {
           return this.usage >= 1;
       }

       public function usageText() : String
       {
           return this.usageText_;
       }
      
      public function toString() : String
      {
         return "[" + this.name + ": " + this.address + ":" + this.port + ":" + this.latLong + ":" + this.usage + ":" + this.isAdminOnly + "]";
      }
   }
}
