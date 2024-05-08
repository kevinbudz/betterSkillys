package kabam.rotmg.stage3D.proxies
{
   import flash.display3D.Program3D;
   import flash.utils.ByteArray;
   
   public class Program3DProxy
   {
       
      
      private var program3D:Program3D;
      
      public function Program3DProxy(program3D:Program3D)
      {
         super();
         this.program3D = program3D;
      }
      
      public function upload(vertexProgram:ByteArray, fragmentProgram:ByteArray) : void
      {
         this.program3D.upload(vertexProgram,fragmentProgram);
      }
      
      public function getProgram3D() : Program3D
      {
         return this.program3D;
      }
   }
}
