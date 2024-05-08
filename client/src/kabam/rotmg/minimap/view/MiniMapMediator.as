package kabam.rotmg.minimap.view
{
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import flash.utils.Dictionary;
   import kabam.rotmg.game.focus.control.SetGameFocusSignal;
   import kabam.rotmg.game.signals.ExitGameSignal;
   import kabam.rotmg.minimap.control.MiniMapZoomSignal;
   import kabam.rotmg.minimap.control.UpdateGameObjectTileSignal;
   import kabam.rotmg.minimap.control.UpdateGroundTileSignal;
   import kabam.rotmg.minimap.model.UpdateGroundTileVO;
   import kabam.rotmg.ui.model.HUDModel;
   import kabam.rotmg.ui.model.UpdateGameObjectTileVO;
   import kabam.rotmg.ui.signals.UpdateHUDSignal;
   import robotlegs.bender.extensions.mediatorMap.api.IMediator;
   
   public class MiniMapMediator implements IMediator
   {
       
      
      [Inject]
      public var view:MiniMap;
      
      [Inject]
      public var model:HUDModel;
      
      [Inject]
      public var setFocus:SetGameFocusSignal;
      
      [Inject]
      public var updateGroundTileSignal:UpdateGroundTileSignal;
      
      [Inject]
      public var updateGameObjectTileSignal:UpdateGameObjectTileSignal;
      
      [Inject]
      public var miniMapZoomSignal:MiniMapZoomSignal;
      
      [Inject]
      public var updateHUD:UpdateHUDSignal;
      
      [Inject]
      public var exitGameSignal:ExitGameSignal;
      
      public function MiniMapMediator()
      {
         super();
      }
      
      public function initialize() : void
      {
         this.view.setMap(this.model.gameSprite.map);
         this.setFocus.add(this.onSetFocus);
         this.updateHUD.add(this.onUpdateHUD);
         this.updateGameObjectTileSignal.add(this.onUpdateGameObjectTile);
         this.updateGroundTileSignal.add(this.onUpdateGroundTile);
         this.miniMapZoomSignal.add(this.onMiniMapZoom);
         this.exitGameSignal.add(this.onExitGame);
      }
      
      private function onExitGame() : void
      {
         this.view.deactivate();
      }
      
      public function destroy() : void
      {
         this.setFocus.remove(this.onSetFocus);
         this.updateHUD.remove(this.onUpdateHUD);
         this.updateGameObjectTileSignal.remove(this.onUpdateGameObjectTile);
         this.updateGroundTileSignal.remove(this.onUpdateGroundTile);
         this.miniMapZoomSignal.remove(this.onMiniMapZoom);
         this.exitGameSignal.remove(this.onExitGame);
      }
      
      private function onSetFocus(id:String) : void
      {
         var object:GameObject = this.getFocusById(id);
         this.view.setFocus(object);
      }
      
      private function getFocusById(id:String) : GameObject
      {
         var object:GameObject = null;
         if(id == "")
         {
            return this.view.map.player_;
         }
         var objects:Dictionary = this.view.map.goDict_;
         for each(object in objects)
         {
            if(object.name_ == id)
            {
               return object;
            }
         }
         return this.view.map.player_;
      }
      
      private function onUpdateGroundTile(vo:UpdateGroundTileVO) : void
      {
         this.view.setGroundTile(vo.tileX,vo.tileY,vo.tileType);
      }
      
      private function onUpdateGameObjectTile(vo:UpdateGameObjectTileVO) : void
      {
         this.view.setGameObjectTile(vo.tileX,vo.tileY,vo.gameObject);
      }
      
      private function onMiniMapZoom(direction:String) : void
      {
         if(direction == MiniMapZoomSignal.IN)
         {
            this.view.zoomIn();
         }
         else if(direction == MiniMapZoomSignal.OUT)
         {
            this.view.zoomOut();
         }
      }
      
      private function onUpdateHUD(_:Player) : void
      {
         this.view.draw();
      }
   }
}
