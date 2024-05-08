package kabam.rotmg.stage3D.graphic3D
{
   import kabam.rotmg.stage3D.proxies.Context3DProxy;
   import kabam.rotmg.stage3D.proxies.Program3DProxy;
   import kabam.rotmg.stage3D.shaders.FragmentShader;
   import kabam.rotmg.stage3D.shaders.FragmentShaderRepeat;
   import kabam.rotmg.stage3D.shaders.VertextShader;
   
   public class Program3DFactory
   {
      
      private static var instance:Program3DFactory;
      
      public static const TYPE_REPEAT_ON:Boolean = true;
      
      public static const TYPE_REPEAT_OFF:Boolean = false;
       
      
      private var repeatProgram:Program3DProxy;
      
      private var noRepeatProgram:Program3DProxy;
      
      public function Program3DFactory(password:String = "")
      {
         super();
         if(password != "yoThisIsInternal")
         {
            throw new Error("Program3DFactory is a singleton. Use Program3DFactory.getInstance()");
         }
      }
      
      public static function getInstance() : Program3DFactory
      {
         if(instance == null)
         {
            instance = new Program3DFactory("yoThisIsInternal");
         }
         return instance;
      }
      
      public function dispose() : void
      {
         if(this.repeatProgram != null)
         {
            this.repeatProgram.getProgram3D().dispose();
         }
         if(this.noRepeatProgram != null)
         {
            this.noRepeatProgram.getProgram3D().dispose();
         }
         instance = null;
      }
      
      public function getProgram(context3D:Context3DProxy, type:Boolean) : Program3DProxy
      {
         var program:Program3DProxy = null;
         switch(type)
         {
            case TYPE_REPEAT_ON:
               if(this.repeatProgram == null)
               {
                  this.repeatProgram = context3D.createProgram();
                  this.repeatProgram.upload(new VertextShader().getVertexProgram(),new FragmentShaderRepeat().getVertexProgram());
               }
               program = this.repeatProgram;
               break;
            case TYPE_REPEAT_OFF:
               if(this.noRepeatProgram == null)
               {
                  this.noRepeatProgram = context3D.createProgram();
                  this.noRepeatProgram.upload(new VertextShader().getVertexProgram(),new FragmentShader().getVertexProgram());
               }
               program = this.noRepeatProgram;
               break;
            default:
               if(this.repeatProgram == null)
               {
                  this.repeatProgram = context3D.createProgram();
                  this.repeatProgram.upload(new VertextShader().getVertexProgram(),new FragmentShaderRepeat().getVertexProgram());
               }
               program = this.repeatProgram;
         }
         return program;
      }
   }
}
