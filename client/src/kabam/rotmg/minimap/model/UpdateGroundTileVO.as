package kabam.rotmg.minimap.model
{
   public class UpdateGroundTileVO
   {
       
      
      public var tileX:int;
      
      public var tileY:int;
      
      public var tileType:uint;
      
      public function UpdateGroundTileVO(tileX:int, tileY:int, tileType:uint)
      {
         super();
         this.tileX = tileX;
         this.tileY = tileY;
         this.tileType = tileType;
      }
   }
}
