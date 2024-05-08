package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.editor.Command;
   
   public class MEObjectNameCommand extends Command
   {
       
      
      private var map_:MEMap;
      
      private var x_:int;
      
      private var y_:int;
      
      private var oldName_:String;
      
      private var newName_:String;
      
      public function MEObjectNameCommand(map:MEMap, x:int, y:int, oldName:String, newName:String)
      {
         super();
         this.map_ = map;
         this.x_ = x;
         this.y_ = y;
         this.oldName_ = oldName;
         this.newName_ = newName;
      }
      
      override public function execute() : void
      {
         this.map_.modifyObjectName(this.x_,this.y_,this.newName_);
      }
      
      override public function unexecute() : void
      {
         this.map_.modifyObjectName(this.x_,this.y_,this.oldName_);
      }
   }
}
