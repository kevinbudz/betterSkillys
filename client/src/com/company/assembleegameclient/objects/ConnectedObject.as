package com.company.assembleegameclient.objects
{
   import com.company.assembleegameclient.engine3d.Object3D;
   import com.company.assembleegameclient.engine3d.ObjectFace3D;
   import com.company.assembleegameclient.map.Camera;
   import com.company.assembleegameclient.map.Square;
   import flash.display.BitmapData;
   import flash.display.IGraphicsData;
   import flash.geom.Utils3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class ConnectedObject extends GameObject
   {
      
      protected static const DOT_TYPE:int = 0;
      
      protected static const SHORT_LINE_TYPE:int = 1;
      
      protected static const L_TYPE:int = 2;
      
      protected static const LINE_TYPE:int = 3;
      
      protected static const T_TYPE:int = 4;
      
      protected static const CROSS_TYPE:int = 5;
      
      private static var dict_:Dictionary = null;
      
      protected static const N0:Vector3D = new Vector3D(-1,-1,0);
      
      protected static const N1:Vector3D = new Vector3D(0,-1,0);
      
      protected static const N2:Vector3D = new Vector3D(1,-1,0);
      
      protected static const N3:Vector3D = new Vector3D(1,0,0);
      
      protected static const N4:Vector3D = new Vector3D(1,1,0);
      
      protected static const N5:Vector3D = new Vector3D(0,1,0);
      
      protected static const N6:Vector3D = new Vector3D(-1,1,0);
      
      protected static const N7:Vector3D = new Vector3D(-1,0,0);
      
      protected static const N8:Vector3D = new Vector3D(0,0,1);
       
      
      protected var rotation_:int = 0;
      
      public function ConnectedObject(objectXML:XML)
      {
         super(objectXML);
         hasShadow_ = false;
      }
      
      private static function init() : void
      {
         dict_ = new Dictionary();
         initHelper(33686018,DOT_TYPE);
         initHelper(16908802,SHORT_LINE_TYPE);
         initHelper(16843266,L_TYPE);
         initHelper(16908546,LINE_TYPE);
         initHelper(16843265,T_TYPE);
         initHelper(16843009,CROSS_TYPE);
      }
      
      private static function getConnectedResults(connectType:int) : ConnectedResults
      {
         if(dict_ == null)
         {
            init();
         }
         var pat:int = connectType & 252645135;
         return dict_[pat];
      }
      
      private static function initHelper(val:int, type:int) : void
      {
         var byte:int = 0;
         for(var rotation:int = 0; rotation < 4; rotation++)
         {
            if(!dict_.hasOwnProperty(val))
            {
               dict_[val] = new ConnectedResults(type,rotation);
               byte = val & 255;
               val = val >> 8 | byte << 24;
            }
         }
      }
      
      override public function draw(graphicsData:Vector.<IGraphicsData>, camera:Camera, time:int) : void
      {
         var face:ObjectFace3D = null;
         var nx:int = 0;
         var ny:int = 0;
         var texture:BitmapData = null;
         var sq:Square = null;
         if(obj3D_ == null)
         {
            this.rebuild3D();
         }
         Utils3D.projectVectors(camera.wToS_,obj3D_.vW_,obj3D_.vS_,obj3D_.uvts_);
         for each(face in obj3D_.faces_)
         {
            nx = face.normalW_.x > 0.4?int(1):face.normalW_.x < -0.4?int(-1):int(0);
            ny = face.normalW_.y > 0.4?int(1):face.normalW_.y < -0.4?int(-1):int(0);
            texture = face.texture_;
            if(nx != 0 || ny != 0)
            {
               sq = map_.lookupSquare(x_ + nx,y_ + ny);
               if(sq == null || sq.texture_ == null)
               {
                  texture = null;
               }
            }
            face.draw(graphicsData,0,texture);
         }
      }
      
      public function rebuild3D() : void
      {
         obj3D_ = new Object3D();
         var connectedResults:ConnectedResults = getConnectedResults(connectType_);
         if(connectedResults == null)
         {
            trace("UNSUPPORTED TYPE: 0x" + connectType_.toString(16));
            obj3D_ = null;
            return;
         }
         this.rotation_ = connectedResults.rotation_;
         switch(connectedResults.type_)
         {
            case DOT_TYPE:
               this.buildDot();
               break;
            case SHORT_LINE_TYPE:
               this.buildShortLine();
               break;
            case L_TYPE:
               this.buildL();
               break;
            case LINE_TYPE:
               this.buildLine();
               break;
            case T_TYPE:
               this.buildT();
               break;
            case CROSS_TYPE:
               this.buildCross();
               break;
            default:
               trace("INVALID TYPE: " + connectedResults.type_ + " (0x" + connectType_.toString(16) + ")");
               obj3D_ = null;
               return;
         }
         obj3D_.setPosition(x_,y_,0,this.rotation_ * 90);
      }
      
      protected function buildDot() : void
      {
      }
      
      protected function buildShortLine() : void
      {
      }
      
      protected function buildL() : void
      {
      }
      
      protected function buildLine() : void
      {
      }
      
      protected function buildT() : void
      {
      }
      
      protected function buildCross() : void
      {
      }
   }
}

class ConnectedResults
{
    
   
   public var type_:int;
   
   public var rotation_:int;
   
   function ConnectedResults(type:int, rotation:int)
   {
      super();
      this.type_ = type;
      this.rotation_ = rotation;
   }
}
