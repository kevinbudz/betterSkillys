package kabam.rotmg.servers.api
{
   public final class LatLong
   {
      
      private static const TO_DEGREES:Number = 180 / Math.PI;
      
      private static const TO_RADIANS:Number = Math.PI / 180;
      
      private static const DISTANCE_SCALAR:Number = 60 * 1.1515 * 1.609344 * 1000;
       
      
      public var latitude:Number;
      
      public var longitude:Number;
      
      public function LatLong(latitude:Number, longitude:Number)
      {
         super();
         this.latitude = latitude;
         this.longitude = longitude;
      }
      
      public static function distance(a:LatLong, b:LatLong) : Number
      {
         var theta:Number = TO_RADIANS * (a.longitude - b.longitude);
         var lat1:Number = TO_RADIANS * a.latitude;
         var lat2:Number = TO_RADIANS * b.latitude;
         var dist:Number = Math.sin(lat1) * Math.sin(lat2) + Math.cos(lat1) * Math.cos(lat2) * Math.cos(theta);
         dist = TO_DEGREES * Math.acos(dist) * DISTANCE_SCALAR;
         return dist;
      }
      
      public function toString() : String
      {
         return "(" + this.latitude + ", " + this.longitude + ")";
      }
   }
}
