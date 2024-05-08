package com.company.assembleegameclient.util.offer
{
   public class Offers
   {
      
      private static const BEST_DEAL:String = "(Best deal)";
      
      private static const MOST_POPULAR:String = "(Most popular)";
       
      
      public var tok:String;
      
      public var exp:String;
      
      public var offerList:Vector.<Offer>;
      
      public function Offers(offersXML:XML)
      {
         super();
         this.tok = offersXML.Tok;
         this.exp = offersXML.Exp;
         this.makeOffers(offersXML);
      }
      
      private function makeOffers(xml:XML) : void
      {
         this.makeOfferList(xml);
         this.sortOfferList();
         this.defineBonuses();
         this.defineMostPopularTagline();
         this.defineBestDealTagline();
      }
      
      private function makeOfferList(xml:XML) : void
      {
         var offerXML:XML = null;
         this.offerList = new Vector.<Offer>(0);
         for each(offerXML in xml.Offer)
         {
            this.offerList.push(this.makeOffer(offerXML));
         }
      }
      
      private function makeOffer(offerXML:XML) : Offer
      {
         var id:String = offerXML.Id;
         var price:Number = Number(offerXML.Price);
         var realmGold:int = int(offerXML.RealmGold);
         var jwt:String = offerXML.CheckoutJWT;
         var data:String = offerXML.Data;
         var currency:String = Boolean(offerXML.hasOwnProperty("Currency"))?offerXML.Currency:null;
         return new Offer(id,price,realmGold,jwt,data,currency);
      }
      
      private function sortOfferList() : void
      {
         this.offerList.sort(this.sortOffers);
      }
      
      private function defineBonuses() : void
      {
         var offerGold:int = 0;
         var offerDollars:int = 0;
         var expectedGold:Number = NaN;
         var bonusGold:Number = NaN;
         if(this.offerList.length == 0)
         {
            return;
         }
         var baselineGold:int = this.offerList[0].realmGold_;
         var baselineDollars:int = this.offerList[0].price_;
         var goldPerDollar:Number = baselineGold / baselineDollars;
         for(var i:int = 1; i < this.offerList.length; i++)
         {
            offerGold = this.offerList[i].realmGold_;
            offerDollars = this.offerList[i].price_;
            expectedGold = offerDollars * goldPerDollar;
            bonusGold = offerGold - expectedGold;
            this.offerList[i].bonus = bonusGold / offerDollars;
         }
      }
      
      private function sortOffers(a:Offer, b:Offer) : int
      {
         return a.price_ - b.price_;
      }
      
      private function defineMostPopularTagline() : void
      {
         var offer:Offer = null;
         for each(offer in this.offerList)
         {
            if(offer.price_ == 10)
            {
               offer.tagline = MOST_POPULAR;
            }
         }
      }
      
      private function defineBestDealTagline() : void
      {
         this.offerList[this.offerList.length - 1].tagline = BEST_DEAL;
      }
   }
}
