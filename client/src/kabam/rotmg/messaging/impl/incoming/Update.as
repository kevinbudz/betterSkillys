package kabam.rotmg.messaging.impl.incoming
{
   import com.company.assembleegameclient.util.FreeList;
   import flash.utils.IDataInput;
   import kabam.rotmg.messaging.impl.data.GroundTileData;
   import kabam.rotmg.messaging.impl.data.ObjectData;
   
   public class Update extends IncomingMessage
   {
       
      
      public var tiles_:Vector.<GroundTileData>;
      
      public var newObjs_:Vector.<ObjectData>;
      
      public var drops_:Vector.<int>;
      
      public function Update(id:uint, callback:Function)
      {
         this.tiles_ = new Vector.<GroundTileData>();
         this.newObjs_ = new Vector.<ObjectData>();
         this.drops_ = new Vector.<int>();
         super(id,callback);
      }
      
      override public function parseFromInput(data:IDataInput) : void
      {
         var i:int = 0;
         var len:int = data.readShort();
         for(i = len; i < this.tiles_.length; i++)
         {
            FreeList.deleteObject(this.tiles_[i]);
         }
         this.tiles_.length = Math.min(len,this.tiles_.length);
         while(this.tiles_.length < len)
         {
            this.tiles_.push(FreeList.newObject(GroundTileData) as GroundTileData);
         }
         for(i = 0; i < len; i++)
         {
            this.tiles_[i].parseFromInput(data);
         }
         this.newObjs_.length = 0;
         len = data.readShort();
         for(i = len; i < this.newObjs_.length; i++)
         {
            FreeList.deleteObject(this.newObjs_[i]);
         }
         this.newObjs_.length = Math.min(len,this.newObjs_.length);
         while(this.newObjs_.length < len)
         {
            this.newObjs_.push(FreeList.newObject(ObjectData) as ObjectData);
         }
         for(i = 0; i < len; i++)
         {
            this.newObjs_[i].parseFromInput(data);
         }
         this.drops_.length = 0;
         var numDrops:int = data.readShort();
         for(i = 0; i < numDrops; i++)
         {
            this.drops_.push(data.readInt());
         }
      }
      
      override public function toString() : String
      {
         return formatToString("UPDATE","tiles_","newObjs_","drops_");
      }
   }
}
