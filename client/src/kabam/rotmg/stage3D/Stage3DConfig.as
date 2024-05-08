package kabam.rotmg.stage3D
{
   import com.company.assembleegameclient.engine3d.Model3D;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.Stage3DProxy;
   import com.company.assembleegameclient.util.StageProxy;

import flash.display.StageScaleMode;
import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DCompareMode;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import kabam.rotmg.stage3D.graphic3D.Graphic3DHelper;
   import kabam.rotmg.stage3D.graphic3D.IndexBufferFactory;
   import kabam.rotmg.stage3D.graphic3D.TextureFactory;
   import kabam.rotmg.stage3D.graphic3D.VertexBufferFactory;
   import kabam.rotmg.stage3D.proxies.Context3DProxy;
   import org.swiftsuspenders.Injector;
   import robotlegs.bender.framework.api.IConfig;

   public class Stage3DConfig implements IConfig
   {

      public static var WIDTH:int = 800;

      public static var HALF_WIDTH:int = WIDTH / 2;

      public static var HEIGHT:int = 600;

      public static var HALF_HEIGHT:int = HEIGHT / 2;


      [Inject]
      public var stageProxy:StageProxy;

      [Inject]
      public var injector:Injector;

      public var renderer:Renderer;

      private var stage3D:Stage3DProxy;

      public function Stage3DConfig()
      {
         super();
      }

      public static function Dimensions() : void
      {
         var mscale:Number = Parameters.data_.mscale;
         var WidthScaled:Number = WebMain.sWidth / mscale;
         var HeightScaled:Number = WebMain.sHeight / mscale;
         WIDTH = WidthScaled;
         HALF_WIDTH = WidthScaled / 2;
         HEIGHT = HeightScaled;
         HALF_HEIGHT = HeightScaled / 2;
      }

      public function configure() : void
      {
         this.mapSingletons();
         this.stage3D = this.stageProxy.getStage3Ds(0);
         this.stage3D.addEventListener(ErrorEvent.ERROR,Parameters.clearGpuRenderEvent);
         this.stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.onContextCreate);
         this.stage3D.requestContext3D();
      }

      private function mapSingletons() : void
      {
         this.injector.map(Render3D).asSingleton();
         this.injector.map(TextureFactory).asSingleton();
         this.injector.map(IndexBufferFactory).asSingleton();
         this.injector.map(VertexBufferFactory).asSingleton();
      }

      private function onContextCreate(e:Event) : void
      {
         this.stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.onContextCreate);
         var context3D:Context3DProxy = this.stage3D.getContext3D();
         if(context3D.GetContext3D().driverInfo.toLowerCase().indexOf("software") != -1)
         {
            Parameters.clearGpuRender();
         }
         context3D.configureBackBuffer(WIDTH,HEIGHT,2,true);
         context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
         context3D.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
         this.injector.map(Context3DProxy).toValue(context3D);
         Graphic3DHelper.map(this.injector);
         this.renderer = this.injector.getInstance(Renderer);
         this.renderer.init(context3D.GetContext3D());
         Model3D.Create3dBuffer(context3D.GetContext3D());
      }
   }
}
