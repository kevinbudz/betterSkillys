package kabam.rotmg.account.core.model
{
   import com.company.assembleegameclient.util.offer.Offer;
   
   public interface MoneyConfig
   {
       
      
      function showPaymentMethods() : Boolean;
      
      function showBonuses() : Boolean;
      
      function parseOfferPrice(param1:Offer) : String;
      
      function jsInitializeFunction() : String;
   }
}
