package kabam.rotmg.ui.model
{
   import com.company.assembleegameclient.objects.GameObject;
   
   public class UpdateGameObjectTileVO
   {
       
      
      public var tileX:int;
      
      public var tileY:int;
      
      public var gameObject:GameObject;
      
      public function UpdateGameObjectTileVO(tileX:int, tileY:int, gameObject:GameObject)
      {
         super();
         this.tileX = tileX;
         this.tileY = tileY;
         this.gameObject = gameObject;
      }
   }
}
