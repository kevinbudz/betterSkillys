package kabam.rotmg.stage3D.Object3D
{
   import flash.geom.Matrix3D;
   import flash.utils.ByteArray;
   
   public class Util
   {
       
      
      public function Util()
      {
         super();
      }
      
      public static function perspectiveProjection(fov:Number = 90, aspect:Number = 1, near:Number = 1, far:Number = 2048) : Matrix3D
      {
         var y2:Number = near * Math.tan(fov * Math.PI / 360);
         var y1:Number = -y2;
         var x1:Number = y1 * aspect;
         var x2:Number = y2 * aspect;
         var a:Number = 2 * near / (x2 - x1);
         var b:Number = 2 * near / (y2 - y1);
         var c:Number = (x2 + x1) / (x2 - x1);
         var d:Number = (y2 + y1) / (y2 - y1);
         var q:Number = -(far + near) / (far - near);
         var qn:Number = -2 * (far * near) / (far - near);
         return new Matrix3D(Vector.<Number>([a,0,0,0,0,b,0,0,c,d,q,-1,0,0,qn,0]));
      }
      
      public static function readString(bytes:ByteArray, length:int) : String
      {
         var byte:uint = 0;
         var string:String = "";
         for(var i:int = 0; i < length; i++)
         {
            byte = bytes.readUnsignedByte();
            if(byte === 0)
            {
               bytes.position = bytes.position + Math.max(0,length - (i + 1));
               break;
            }
            string = string + String.fromCharCode(byte);
         }
         return string;
      }
      
      public static function upperPowerOfTwo(value:uint) : uint
      {
         value--;
         value = value | value >> 1;
         value = value | value >> 2;
         value = value | value >> 4;
         value = value | value >> 8;
         value = value | value >> 16;
         value++;
         return value;
      }
   }
}
