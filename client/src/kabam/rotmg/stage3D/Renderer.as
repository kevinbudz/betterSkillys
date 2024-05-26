package kabam.rotmg.stage3D
{
   import com.adobe.utils.AGALMiniAssembler;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.parameters.Parameters;
   import flash.display.GraphicsBitmapFill;
   import flash.display.GraphicsGradientFill;
   import flash.display.IGraphicsData;
   import flash.display.Stage3D;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.Context3DTriangleFace;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.Program3D;
   import flash.display3D.VertexBuffer3D;
   import flash.display3D.textures.Texture;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.ByteArray;
   import kabam.rotmg.stage3D.Object3D.Object3DStage3D;
   import kabam.rotmg.stage3D.Object3D.Util;
   import kabam.rotmg.stage3D.graphic3D.Graphic3D;
   import kabam.rotmg.stage3D.graphic3D.TextureFactory;
   import kabam.rotmg.stage3D.proxies.Context3DProxy;
   import org.swiftsuspenders.Injector;

   public class Renderer
   {
      public static const STAGE3D_FILTER_PAUSE:uint = 1;
      public static const STAGE3D_FILTER_BLIND:uint = 2;
      public static const STAGE3D_FILTER_DRUNK:uint = 3;
      private static const POST_FILTER_VERTEX_CONSTANTS:Vector.<Number> = new <Number>[1, 2, 0, 0];
      private static const GRAYSCALE_FRAGMENT_CONSTANTS:Vector.<Number> = new <Number>[0.3, 0.59, 0.11, 0];
      private static const BLIND_FRAGMENT_CONSTANTS:Vector.<Number> = new <Number>[0.05, 0.05, 0.05, 0];
      private static const POST_FILTER_POSITIONS:Vector.<Number> = new <Number>[-1, 1, 0, 0, 1, 1, 1, 0, 1, -1, 1, 1, -1, -1, 0, 1];
      private static const POST_FILTER_TRIS:Vector.<uint> = new <uint>[0, 2, 3, 0, 1, 2];

      public static var inGame:Boolean;

      [Inject]
      public var context3D:Context3DProxy;

      [Inject]
      public var textureFactory:TextureFactory;

      [Inject]
      public var injector:Injector;

      private var tX:Number;

      private var tY:Number;

      public var program2:Program3D;

      private var postProcessingProgram_:Program3D;

      private var blurPostProcessing_:Program3D;

      private var shadowProgram_:Program3D;

      private var graphic3D_:Graphic3D;

      protected var _projection:Matrix3D;

      protected var cameraMatrix_:Matrix3D;

      private var p_:Vector3D;

      private var f_:Vector3D;

      private var u_:Vector3D;

      private var r_:Vector3D;

      private var rd_:Vector.<Number>;

      protected var widthOffset_:Number;

      protected var heightOffset_:Number;

      private var stageWidth:Number = 600;

      private var stageHeight:Number = 600;

      private var sceneTexture_:Texture;

      private var blurFactor:Number = 0.01;

      private var postFilterVertexBuffer_:VertexBuffer3D;

      private var postFilterIndexBuffer_:IndexBuffer3D;

      protected var _vertexShader:String;

      protected var _fragmentShader:String;

      protected var blurFragmentConstants_:Vector.<Number>;

      public function Renderer(render3D:Render3D)
      {
         this.cameraMatrix_ = new Matrix3D();
         this.p_ = new Vector3D();
         this.f_ = new Vector3D();
         this.u_ = new Vector3D();
         this.r_ = new Vector3D();
         this.rd_ = new Vector.<Number>(16,true);
         this._vertexShader = ["m44 op, va0, vc0","m44 v0, va0, vc8","m44 v1, va1, vc8","mov v2, va2"].join("\n");
         this._fragmentShader = ["tex oc, v2, fs0 <2d,clamp>"].join("\n");
         this.blurFragmentConstants_ = Vector.<Number>([0.4,0.6,0.4,1.5]);
         super();
         Renderer.inGame = false;
         this.setTranslationToTitle();
         render3D.add(this.onRender);
      }

      public function init(context3D:Context3D) : void
      {
         this._projection = Util.perspectiveProjection(56,1,0.1,2048);
         var vsAssembler:AGALMiniAssembler = new AGALMiniAssembler();
         vsAssembler.assemble(Context3DProgramType.VERTEX,this._vertexShader);
         var fsAssembler:AGALMiniAssembler = new AGALMiniAssembler();
         fsAssembler.assemble(Context3DProgramType.FRAGMENT,this._fragmentShader);
         this.program2 = context3D.createProgram();
         this.program2.upload(vsAssembler.agalcode,fsAssembler.agalcode);
         var fragSource:String = "tex ft0, v0, fs0 <2d,clamp,linear>\n" + "dp3 ft0.x, ft0, fc0\n" + "mov ft0.y, ft0.x\n" + "mov ft0.z, ft0.x\n" + "mov oc, ft0\n";
         var vertSource:String = "mov op, va0\n" + "add vt0, vc0.xxxx, va0\n" + "div vt0, vt0, vc0.yyyy\n" + "sub vt0.y, vc0.x, vt0.y\n" + "mov v0, vt0\n";
         var assembler:AGALMiniAssembler = new AGALMiniAssembler();
         assembler.assemble(Context3DProgramType.VERTEX,vertSource);
         var vertexShaderAGAL:ByteArray = assembler.agalcode;
         assembler.assemble(Context3DProgramType.FRAGMENT,fragSource);
         var fragmentShaderAGAL:ByteArray = assembler.agalcode;
         this.postProcessingProgram_ = context3D.createProgram();
         this.postProcessingProgram_.upload(vertexShaderAGAL,fragmentShaderAGAL);
         var blurFS:String = "sub ft0, v0, fc0\n" + "sub ft0.zw, ft0.zw, ft0.zw\n" + "dp3 ft1, ft0, ft0\n" + "sqt ft1, ft1\n" + "div ft1.xy, ft1.xy, fc0.zz\n" + "pow ft1.x, ft1.x, fc0.w\n" + "mul ft0.xy, ft0.xy, ft1.xx\n" + "div ft0.xy, ft0.xy, ft1.yy\n" + "add ft0.xy, ft0.xy, fc0.xy\n" + "tex oc, ft0, fs0<2d,clamp>\n";
         var blurVS:String = "m44 op, va0, vc0\n" + "mov v0, va1\n";
         assembler.assemble(Context3DProgramType.VERTEX,blurVS);
         var blurVSAGAL:ByteArray = assembler.agalcode;
         assembler.assemble(Context3DProgramType.FRAGMENT,blurFS);
         var blurFSAGAL:ByteArray = assembler.agalcode;
         this.blurPostProcessing_ = context3D.createProgram();
         this.blurPostProcessing_.upload(blurVSAGAL,blurFSAGAL);
         var shadowVS:String = "m44 op, va0, vc0\n" + "mov v0, va1\n" + "mov v1, va2\n";
         assembler.assemble(Context3DProgramType.VERTEX,shadowVS);
         var shadowVSAGAL:ByteArray = assembler.agalcode;
         var shadowFS:String = "sub ft0.xy, v1.xy, fc4.xx\n" + "mul ft0.xy, ft0.xy, ft0.xy\n" + "add ft0.x, ft0.x, ft0.y\n" + "slt ft0.y, ft0.x, fc4.y\n" + "mul oc, v0, ft0.yyyy\n";
         assembler.assemble(Context3DProgramType.FRAGMENT,shadowFS);
         var shadowFSAGAL:ByteArray = assembler.agalcode;
         this.shadowProgram_ = context3D.createProgram();
         this.shadowProgram_.upload(shadowVSAGAL,shadowFSAGAL);
         this.sceneTexture_ = context3D.createTexture(1024,1024,Context3DTextureFormat.BGRA,true);
         this.postFilterVertexBuffer_ = context3D.createVertexBuffer(4,4);
         this.postFilterVertexBuffer_.uploadFromVector(POST_FILTER_POSITIONS,0,4);
         this.postFilterIndexBuffer_ = context3D.createIndexBuffer(6);
         this.postFilterIndexBuffer_.uploadFromVector(POST_FILTER_TRIS,0,6);
         this.graphic3D_ = this.injector.getInstance(Graphic3D);
      }

      private function UpdateCameraMatrix(camera:Camera) : void
      {
         var angleRad:Number = -camera.angleRad_;
         this.f_.x = 0;
         this.f_.y = 0;
         this.f_.z = -1;
         this.p_.x = -(camera.x_ + this.widthOffset_);
         this.p_.y = camera.y_ - this.heightOffset_;
         this.p_.z = -camera.z_;
         this.r_.x = Math.cos(angleRad);
         this.r_.y = Math.sin(angleRad);
         this.r_.z = 0;
         this.u_.x = Math.cos(angleRad + Math.PI / 2);
         this.u_.y = Math.sin(angleRad + Math.PI / 2);
         this.u_.z = 0;
         this.rd_[0] = this.r_.x;
         this.rd_[1] = this.u_.x;
         this.rd_[2] = this.f_.x;
         this.rd_[3] = 0;
         this.rd_[4] = this.r_.y;
         this.rd_[5] = this.u_.y;
         this.rd_[6] = this.f_.y;
         this.rd_[7] = 0;
         this.rd_[8] = this.r_.z;
         this.rd_[9] = 1;
         this.rd_[10] = -this.f_.z;
         this.rd_[11] = 0;
         this.rd_[12] = this.p_.dotProduct(this.r_);
         this.rd_[13] = this.p_.dotProduct(this.u_);
         this.rd_[14] = -this.p_.dotProduct(this.f_);
         this.rd_[15] = 1;
         var temp:Matrix3D = new Matrix3D();
         temp.rawData = this.rd_;
         this.cameraMatrix_.identity();
         this.cameraMatrix_.append(temp);
      }

      private function onRender(graphicsDatas:Vector.<IGraphicsData>, grahpicsData3d:Vector.<Object3DStage3D>, mapWidth:Number, mapHeight:Number, camera:Camera, filterIndex:uint) : void
      {
         if(WebMain.STAGE.stageWidth != this.stageWidth || WebMain.STAGE.stageHeight != this.stageHeight)
         {
            this.resizeStage3DBackBuffer();
         }
         if(Renderer.inGame)
         {
            this.setTranslationToGame();
         }
         else
         {
            this.setTranslationToTitle();
         }
         if(filterIndex > 0)
         {
            this.renderWithPostEffect(graphicsDatas,grahpicsData3d,mapWidth,mapHeight,camera,filterIndex);
         }
         else
         {
            this.renderScene(graphicsDatas,grahpicsData3d,mapWidth,mapHeight,camera);
         }
         this.context3D.present();
         WebMain.STAGE.scaleMode = StageScaleMode.NO_SCALE;
      }

      private function resizeStage3DBackBuffer() : void
      {
         if(WebMain.STAGE.stageWidth < 1 || WebMain.STAGE.stageHeight < 1)
         {
            return;
         }
         var stage3d:Stage3D = WebMain.STAGE.stage3Ds[0];
         stage3d.context3D.configureBackBuffer(WebMain.STAGE.stageWidth,WebMain.STAGE.stageHeight,2,true);
         this.stageWidth = WebMain.sWidth;
         this.stageHeight = WebMain.sHeight;
      }

      private function renderWithPostEffect(graphicsDatas:Vector.<IGraphicsData>, grahpicsData3d:Vector.<Object3DStage3D>, mapWidth:Number, mapHeight:Number, camera:Camera, filterIndex:uint) : void
      {
         this.context3D.GetContext3D().setRenderToTexture(this.sceneTexture_,true);
         this.renderScene(graphicsDatas,grahpicsData3d,mapWidth,mapHeight,camera);
         this.context3D.GetContext3D().setRenderToBackBuffer();
         switch(filterIndex)
         {
            case STAGE3D_FILTER_PAUSE:
            case STAGE3D_FILTER_BLIND:
               this.context3D.GetContext3D().setProgram(this.postProcessingProgram_);
               this.context3D.GetContext3D().setTextureAt(0,this.sceneTexture_);
               this.context3D.GetContext3D().clear(0.5,0.5,0.5);
               this.context3D.GetContext3D().setVertexBufferAt(0,this.postFilterVertexBuffer_,0,Context3DVertexBufferFormat.FLOAT_2);
               this.context3D.GetContext3D().setVertexBufferAt(1,null);
               break;
            case STAGE3D_FILTER_DRUNK:
               this.context3D.GetContext3D().setProgram(this.blurPostProcessing_);
               this.context3D.GetContext3D().setTextureAt(0,this.sceneTexture_);
               this.context3D.GetContext3D().clear(0.5,0.5,0.5);
               this.context3D.GetContext3D().setVertexBufferAt(0,this.postFilterVertexBuffer_,0,Context3DVertexBufferFormat.FLOAT_2);
               this.context3D.GetContext3D().setVertexBufferAt(1,this.postFilterVertexBuffer_,2,Context3DVertexBufferFormat.FLOAT_2);
         }
         this.context3D.GetContext3D().setVertexBufferAt(2,null);
         switch(filterIndex)
         {
            case STAGE3D_FILTER_PAUSE:
               this.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,POST_FILTER_VERTEX_CONSTANTS);
               this.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,GRAYSCALE_FRAGMENT_CONSTANTS);
               break;
            case STAGE3D_FILTER_BLIND:
               this.context3D.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,POST_FILTER_VERTEX_CONSTANTS);
               this.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,BLIND_FRAGMENT_CONSTANTS);
               break;
            case STAGE3D_FILTER_DRUNK:
               if(this.blurFragmentConstants_[3] <= 0.2 || this.blurFragmentConstants_[3] >= 1.8)
               {
                  this.blurFactor = this.blurFactor * -1;
               }
               this.blurFragmentConstants_[3] = this.blurFragmentConstants_[3] + this.blurFactor;
               this.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,new Matrix3D());
               this.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.blurFragmentConstants_,this.blurFragmentConstants_.length / 4);
         }
         this.context3D.GetContext3D().clear(0,0,0,1);
         this.context3D.GetContext3D().drawTriangles(this.postFilterIndexBuffer_);
      }

      private function renderScene(graphicsDatas:Vector.<IGraphicsData>, grahpicsData3d:Vector.<Object3DStage3D>, mapWidth:Number, mapHeight:Number, camera:Camera) : void
      {
         var test:int = 0;
         var graphicsData:IGraphicsData = null;
         this.context3D.clear();
         var finalTransform:Matrix3D = new Matrix3D();
         var index3d:uint = 0;
         this.widthOffset_ = -mapWidth / 2;
         this.heightOffset_ = mapHeight / 2;
         this.UpdateCameraMatrix(camera);
         for each(graphicsData in graphicsDatas)
         {
            this.context3D.GetContext3D().setCulling(Context3DTriangleFace.NONE);
            if(graphicsData is GraphicsBitmapFill && !GraphicsFillExtra.isSoftwareDraw(GraphicsBitmapFill(graphicsData)))
            {
               try
               {
                  test = GraphicsBitmapFill(graphicsData).bitmapData.width;
               }
               catch(e:Error)
               {
                  //trace("ERROR CAUGHT -- Invalid Bitmap Data");
                  continue;
               }
               this.graphic3D_.setGraphic(GraphicsBitmapFill(graphicsData),this.context3D);
               finalTransform.identity();
               finalTransform.append(this.graphic3D_.getMatrix3D());
               finalTransform.appendScale(1 / Stage3DConfig.HALF_WIDTH,1 / Stage3DConfig.HALF_HEIGHT,1);
               finalTransform.appendTranslation(this.tX / Stage3DConfig.WIDTH,this.tY / Stage3DConfig.HEIGHT,0);
               this.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,finalTransform,true);
               this.graphic3D_.render(this.context3D);
            }
            if(graphicsData is GraphicsGradientFill)
            {
               this.context3D.GetContext3D().setProgram(this.shadowProgram_);
               this.graphic3D_.setGradientFill(GraphicsGradientFill(graphicsData),this.context3D,Stage3DConfig.HALF_WIDTH,Stage3DConfig.HALF_HEIGHT);
               finalTransform.identity();
               finalTransform.append(this.graphic3D_.getMatrix3D());
               finalTransform.appendTranslation(this.tX / Stage3DConfig.WIDTH,this.tY / Stage3DConfig.HEIGHT,0);
               this.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,finalTransform,true);
               this.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,4,Vector.<Number>([0.5,0.25,0,0]));
               this.graphic3D_.renderShadow(this.context3D);
            }
            if(graphicsData == null && grahpicsData3d.length != 0)
            {
               try
               {
                  this.context3D.GetContext3D().setProgram(this.program2);
                  this.context3D.GetContext3D().setCulling(Context3DTriangleFace.BACK);
                  grahpicsData3d[index3d].UpdateModelMatrix(this.widthOffset_,this.heightOffset_);
                  finalTransform.identity();
                  finalTransform.append(grahpicsData3d[index3d].GetModelMatrix());
                  finalTransform.append(this.cameraMatrix_);
                  finalTransform.append(this._projection);
                  finalTransform.appendTranslation(this.tX / Stage3DConfig.WIDTH,this.tY / Stage3DConfig.HEIGHT * 11.5,0);
                  this.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,finalTransform,true);
                  this.context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,8,grahpicsData3d[index3d].GetModelMatrix(),true);
                  grahpicsData3d[index3d].draw(this.context3D.GetContext3D());
                  index3d++;
               }
               catch(e:Error)
               {
                  trace("ERROR CAUGHT -- Invalid Bitmap Data");
                  continue;
               }
            }
         }
      }

      private function setTranslationToGame() : void
      {
         this.tX = 0;
         this.tX = -200 / Parameters.data_.mscale * (WebMain.STAGE.stageHeight / 600);
         this.tY = !Parameters.data_.centerOnPlayer?Number(Number((Camera.OFFSET_SCREEN_RECT.y + Camera.CENTER_SCREEN_RECT.height / 2) * 2)):Number(Number(-50 / Parameters.data_.mscale * (WebMain.STAGE.stageHeight / 600)));
      }

      private function setTranslationToTitle() : void
      {
         this.tX = -200;
         this.tY = 0;
      }
   }
}
