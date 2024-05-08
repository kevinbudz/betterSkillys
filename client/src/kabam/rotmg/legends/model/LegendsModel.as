package kabam.rotmg.legends.model
{
   public class LegendsModel
   {
       
      
      private var timespan:Timespan;
      
      private const map:Object = {};
      
      public function LegendsModel()
      {
         this.timespan = Timespan.WEEK;
         super();
      }
      
      public function getTimespan() : Timespan
      {
         return this.timespan;
      }
      
      public function setTimespan(value:Timespan) : void
      {
         this.timespan = value;
      }
      
      public function hasLegendList() : Boolean
      {
         return this.map[this.timespan.getId()] != null;
      }
      
      public function getLegendList() : Vector.<Legend>
      {
         return this.map[this.timespan.getId()];
      }
      
      public function setLegendList(legends:Vector.<Legend>) : void
      {
         this.map[this.timespan.getId()] = legends;
      }
      
      public function clear() : void
      {
         var key:* = null;
         for(key in this.map)
         {
            this.dispose(this.map[key]);
            delete this.map[key];
         }
      }
      
      private function dispose(legends:Vector.<Legend>) : void
      {
         var legend:Legend = null;
         for each(legend in legends)
         {
            legend.character && this.removeLegendCharacter(legend);
         }
      }
      
      private function removeLegendCharacter(legend:Legend) : void
      {
         legend.character.dispose();
         legend.character = null;
      }
   }
}
