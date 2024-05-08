package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.editor.Command;
   
   public class MEModifyCommand extends Command
   {
       
      
      private var map_:MEMap;
      
      private var x_:int;
      
      private var y_:int;
      
      private var layer_:int;
      
      private var oldType_:int;
      
      private var newType_:int;
      
      public function MEModifyCommand(map:MEMap, x:int, y:int, layer:int, oldType:int, type:int)
      {
         super();
         this.map_ = map;
         this.x_ = x;
         this.y_ = y;
         this.layer_ = layer;
         this.oldType_ = oldType;
         this.newType_ = type;
      }
      
      override public function execute() : void
      {
         this.map_.modifyTile(this.x_,this.y_,this.layer_,this.newType_);
      }
      
      override public function unexecute() : void
      {
         this.map_.modifyTile(this.x_,this.y_,this.layer_,this.oldType_);
      }
   }
}
