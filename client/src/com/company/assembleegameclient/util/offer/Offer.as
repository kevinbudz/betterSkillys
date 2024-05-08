package com.company.assembleegameclient.util.offer
{
   public class Offer
   {
       
      
      public var id_:String;
      
      public var price_:Number;
      
      public var realmGold_:int;
      
      public var jwt_:String;
      
      public var data_:String;
      
      public var currency_:String;
      
      public var tagline:String;
      
      public var bonus:int;
      
      public function Offer(id:String, price:Number, realmGold:int, jwt:String, data:String, currency:String = null)
      {
         super();
         this.id_ = id;
         this.price_ = price;
         this.realmGold_ = realmGold;
         this.jwt_ = jwt;
         this.data_ = data;
         this.currency_ = currency != null?currency:"USD";
      }
   }
}
