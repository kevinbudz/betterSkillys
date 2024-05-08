package com.company.assembleegameclient.screens
{
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.servers.api.Server;
   
   public class ServerBoxes extends Sprite
   {
       
      
      private var boxes_:Vector.<ServerBox>;
      
      public function ServerBoxes(servers:Vector.<Server>)
      {
         var serverBox:ServerBox = null;
         var i:int = 0;
         var server:Server = null;
         this.boxes_ = new Vector.<ServerBox>();
         super();
         serverBox = new ServerBox(null);
         serverBox.setSelected(true);
         serverBox.x = ServerBox.WIDTH / 2 + 2;
         serverBox.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addChild(serverBox);
         this.boxes_.push(serverBox);
         i = 2;
         for each(server in servers)
         {
            serverBox = new ServerBox(server);
            if(server.name == Parameters.data_.preferredServer)
            {
               this.setSelected(serverBox);
            }
            serverBox.x = i % 2 * (ServerBox.WIDTH + 4);
            serverBox.y = int(i / 2) * (ServerBox.HEIGHT + 4);
            serverBox.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addChild(serverBox);
            this.boxes_.push(serverBox);
            i++;
         }
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         var serverBox:ServerBox = event.target as ServerBox;
         this.setSelected(serverBox);
         Parameters.data_.preferredServer = serverBox.value_;
         Parameters.save();
      }
      
      private function setSelected(serverBox:ServerBox) : void
      {
         var otherServerBox:ServerBox = null;
         for each(otherServerBox in this.boxes_)
         {
            otherServerBox.setSelected(false);
         }
         serverBox.setSelected(true);
      }
   }
}
