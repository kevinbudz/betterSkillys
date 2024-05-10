package com.company.assembleegameclient.screens
{
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import kabam.rotmg.servers.api.Server;

   public class ServerBox extends Sprite
   {

      public static const WIDTH:int = 384;

      public static const HEIGHT:int = 52;


      public var value_:String;

      private var nameText_:SimpleText;

      private var statusText_:SimpleText;

      private var selected_:Boolean = false;

      private var over_:Boolean = false;

      public function ServerBox(server:Server)
      {
         var color:uint = 0;
         var text:String = null;
         super();
         this.value_ = server == null?null:server.name;
         this.nameText_ = new SimpleText(18,16777215,false,0,0);
         this.nameText_.setBold(true);
         this.nameText_.text = server == null?"Best Server":server.name;
         this.nameText_.updateMetrics();
         this.nameText_.filters = [new DropShadowFilter(0,0,0,1,8,8)];
         this.nameText_.x = 18;
         this.nameText_.y = ServerBox.HEIGHT / 2 - this.nameText_.height / 2;
         addChild(this.nameText_);
         if(server != null) {
             color = 65280;
             text = "Normal";
             if (server.isFull()) {
                 color = 16711680;
                 text = "Full";
             }
             else if (server.isCrowded()) {
                 color = 16549442;
                 text = "Crowded";
             }

             if(server.usageText() != null) {
                 text += " " + server.usageText();
             }

             this.statusText_ = new SimpleText(18, color, false, 0, 0);
             this.statusText_.setBold(true);
             this.statusText_.text = text;
             this.statusText_.updateMetrics();
             this.statusText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
             this.statusText_.x = WIDTH / 2 + (WIDTH / 4 - this.statusText_.width / 2);
             this.statusText_.y = ServerBox.HEIGHT / 2 - this.nameText_.height / 2;
             addChild(this.statusText_);
         }
         this.draw();
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
      }

      public function setSelected(selected:Boolean) : void
      {
         this.selected_ = selected;
         this.draw();
      }

      private function onMouseOver(event:MouseEvent) : void
      {
         this.over_ = true;
         this.draw();
      }

      private function onRollOut(event:MouseEvent) : void
      {
         this.over_ = false;
         this.draw();
      }

      private function draw() : void
      {
         graphics.clear();
         if(this.selected_)
         {
            graphics.lineStyle(2,16777103);
         }
         graphics.beginFill(!!this.over_?uint(7039851):uint(6052956),1);
         graphics.drawRect(0,0,WIDTH,HEIGHT);
         if(this.selected_)
         {
            graphics.lineStyle();
         }
      }
   }
}
