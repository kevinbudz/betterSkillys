package com.company.assembleegameclient.util
{
   import com.company.assembleegameclient.util.offer.Offer;
   import flash.net.URLVariables;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.application.api.ApplicationSetup;
   import kabam.rotmg.core.StaticInjectorContext;
   
   public class PaymentMethod
   {
      
      public static const PAYMENT_METHODS:Vector.<PaymentMethod> = new <PaymentMethod>[new PaymentMethod("Google Checkout","co",""),new PaymentMethod("PayPal","ps","P3"),new PaymentMethod("Credit Cards, etc.","ps","CH")];
       
      
      public var label_:String;
      
      public var provider_:String;
      
      public var paymentid_:String;
      
      public function PaymentMethod(label:String, provider:String, paymentid:String)
      {
         super();
         this.label_ = label;
         this.provider_ = provider;
         this.paymentid_ = paymentid;
      }
      
      public static function getPaymentMethod(label:String) : PaymentMethod
      {
         var paymentMethod:PaymentMethod = null;
         for each(paymentMethod in PAYMENT_METHODS)
         {
            if(paymentMethod.label_ == label)
            {
               return paymentMethod;
            }
         }
         return null;
      }
      
      public function getURL(tok:String, exp:String, offer:Offer) : String
      {
         var account:Account = StaticInjectorContext.getInjector().getInstance(Account);
         var setup:ApplicationSetup = StaticInjectorContext.getInjector().getInstance(ApplicationSetup);
         var vars:URLVariables = new URLVariables();
         vars["tok"] = tok;
         vars["exp"] = exp;
         vars["guid"] = account.getUserId();
         vars["provider"] = this.provider_;
         switch(this.provider_)
         {
            case "co":
               vars["jwt"] = offer.jwt_;
               break;
            case "ps":
               vars["jwt"] = offer.jwt_;
               vars["price"] = offer.price_.toString();
               vars["paymentid"] = this.paymentid_;
         }
         return setup.getAppEngineUrl() + "/credits/add?" + vars.toString();
      }
   }
}
