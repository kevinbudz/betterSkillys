package kabam.rotmg.stage3D.Object3D
{
   import flash.display3D.Context3D;
   import flash.display3D.VertexBuffer3D;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class Model3D_stage3d
   {
       
      
      public var name:String;
      
      public var groups:Vector.<OBJGroup>;
      
      public var vertexBuffer:VertexBuffer3D;
      
      protected var _materials:Dictionary;
      
      protected var _tupleIndex:uint;
      
      protected var _tupleIndices:Dictionary;
      
      protected var _vertices:Vector.<Number>;
      
      public function Model3D_stage3d()
      {
         super();
         this.groups = new Vector.<OBJGroup>();
         this._materials = new Dictionary();
         this._vertices = new Vector.<Number>();
      }
      
      public function dispose() : void
      {
         var group:OBJGroup = null;
         for each(group in this.groups)
         {
            group.dispose();
         }
         this.groups.length = 0;
         if(this.vertexBuffer !== null)
         {
            this.vertexBuffer.dispose();
            this.vertexBuffer = null;
         }
         this._vertices.length = 0;
         this._tupleIndex = 0;
         this._tupleIndices = new Dictionary();
      }
      
      public function CreatBuffer(context:Context3D) : void
      {
         var group:OBJGroup = null;
         for each(group in this.groups)
         {
            if(group._indices.length > 0)
            {
               group.indexBuffer = context.createIndexBuffer(group._indices.length);
               group.indexBuffer.uploadFromVector(group._indices,0,group._indices.length);
               group._faces = null;
            }
         }
         this.vertexBuffer = context.createVertexBuffer(this._vertices.length / 8,8);
         this.vertexBuffer.uploadFromVector(this._vertices,0,this._vertices.length / 8);
      }
      
      public function readBytes(bytes:ByteArray) : void
      {
         var face:Vector.<String> = null;
         var group:OBJGroup = null;
         var line:String = null;
         var fields:Array = null;
         var tuple:String = null;
         var il:int = 0;
         var i:int = 0;
         this.dispose();
         var materialName:String = "";
         var positions:Vector.<Number> = new Vector.<Number>();
         var normals:Vector.<Number> = new Vector.<Number>();
         var uvs:Vector.<Number> = new Vector.<Number>();
         bytes.position = 0;
         var text:String = bytes.readUTFBytes(bytes.bytesAvailable);
         var lines:Array = text.split(/[\r\n]+/);
         for each(line in lines)
         {
            line = line.replace(/^\s*|\s*$/g,"");
            if(line == "" || line.charAt(0) === "#")
            {
               continue;
            }
            fields = line.split(/\s+/);
            switch(fields[0].toLowerCase())
            {
               case "v":
                  positions.push(parseFloat(fields[1]),parseFloat(fields[2]),parseFloat(fields[3]));
                  continue;
               case "vn":
                  normals.push(parseFloat(fields[1]),parseFloat(fields[2]),parseFloat(fields[3]));
                  continue;
               case "vt":
                  uvs.push(parseFloat(fields[1]),1 - parseFloat(fields[2]));
                  continue;
               case "f":
                  face = new Vector.<String>();
                  for each(tuple in fields.slice(1))
                  {
                     face.push(tuple);
                  }
                  if(group === null)
                  {
                     group = new OBJGroup(null,materialName);
                     this.groups.push(group);
                  }
                  group._faces.push(face);
                  continue;
               case "g":
                  group = new OBJGroup(fields[1],materialName);
                  this.groups.push(group);
                  continue;
               case "o":
                  this.name = fields[1];
                  continue;
               case "mtllib":
                  continue;
               case "usemtl":
                  materialName = fields[1];
                  if(group !== null)
                  {
                     group.materialName = materialName;
                  }
                  continue;
               default:
                  continue;
            }
         }
         for each(group in this.groups)
         {
            group._indices.length = 0;
            for each(face in group._faces)
            {
               il = face.length - 1;
               for(i = 1; i < il; i++)
               {
                  group._indices.push(this.mergeTuple(face[i],positions,normals,uvs));
                  group._indices.push(this.mergeTuple(face[0],positions,normals,uvs));
                  group._indices.push(this.mergeTuple(face[i + 1],positions,normals,uvs));
               }
            }
            group._faces = null;
         }
         this._tupleIndex = 0;
         this._tupleIndices = null;
      }
      
      protected function mergeTuple(tuple:String, positions:Vector.<Number>, normals:Vector.<Number>, uvs:Vector.<Number>) : uint
      {
         var faceIndices:Array = null;
         var index:uint = 0;
         if(this._tupleIndices[tuple] !== undefined)
         {
            return this._tupleIndices[tuple];
         }
         faceIndices = tuple.split("/");
         index = parseInt(faceIndices[0],10) - 1;
         this._vertices.push(positions[index * 3 + 0],positions[index * 3 + 1],positions[index * 3 + 2]);
         if(faceIndices.length > 2 && faceIndices[2].length > 0)
         {
            index = parseInt(faceIndices[2],10) - 1;
            this._vertices.push(normals[index * 3 + 0],normals[index * 3 + 1],normals[index * 3 + 2]);
         }
         else
         {
            this._vertices.push(0,0,0);
         }
         if(faceIndices.length > 1 && faceIndices[1].length > 0)
         {
            index = parseInt(faceIndices[1],10) - 1;
            this._vertices.push(uvs[index * 2 + 0],uvs[index * 2 + 1]);
         }
         else
         {
            this._vertices.push(0,0);
         }
         return this._tupleIndices[tuple] = this._tupleIndex++;
      }
   }
}
