package com.company.assembleegameclient.objects
{
import com.company.assembleegameclient.engine3d.ObjectFace3D;
import com.company.assembleegameclient.parameters.Parameters;
import flash.display.BitmapData;
import flash.geom.Vector3D;
import kabam.rotmg.stage3D.GraphicsFillExtra;

public class CaveWall extends ConnectedObject
{


   public function CaveWall(objectXML:XML)
   {
      super(objectXML);
   }

   override protected function buildDot() : void
   {
      var face:ObjectFace3D = null;
      var v0:Vector3D = new Vector3D(-0.25 - Math.random() * 0.25,-0.25 - Math.random() * 0.25,0);
      var v1:Vector3D = new Vector3D(0.25 + Math.random() * 0.25,-0.25 - Math.random() * 0.25,0);
      var v2:Vector3D = new Vector3D(0.25 + Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
      var v3:Vector3D = new Vector3D(-0.25 - Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
      var v4:Vector3D = new Vector3D(-0.25 + Math.random() * 0.5,-0.25 + Math.random() * 0.5,1);
      this.faceHelper(null,texture_,v4,v0,v1);
      this.faceHelper(null,texture_,v4,v1,v2);
      this.faceHelper(null,texture_,v4,v2,v3);
      this.faceHelper(null,texture_,v4,v3,v0);
      if(Parameters.isGpuRender())
      {
         for each(face in obj3D_.faces_)
         {
            GraphicsFillExtra.setSoftwareDraw(face.bitmapFill_,true);
         }
      }
   }

   override protected function buildShortLine() : void
   {
      var face:ObjectFace3D = null;
      var v0:Vector3D = this.getVertex(0,0);
      var v1:Vector3D = this.getVertex(0,3);
      var v2:Vector3D = new Vector3D(0.25 + Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
      var v3:Vector3D = new Vector3D(-0.25 - Math.random() * 0.25,0.25 + Math.random() * 0.25,0);
      var v4:Vector3D = this.getVertex(0,1);
      var v5:Vector3D = this.getVertex(0,2);
      var v6:Vector3D = new Vector3D(Math.random() * 0.25,Math.random() * 0.25,0.5);
      var v7:Vector3D = new Vector3D(Math.random() * -0.25,Math.random() * 0.25,0.5);
      this.faceHelper(null,texture_,v4,v7,v3,v0);
      this.faceHelper(null,texture_,v7,v6,v2,v3);
      this.faceHelper(null,texture_,v6,v5,v1,v2);
      this.faceHelper(null,texture_,v4,v5,v6,v7);
      if(Parameters.isGpuRender())
      {
         for each(face in obj3D_.faces_)
         {
            GraphicsFillExtra.setSoftwareDraw(face.bitmapFill_,true);
         }
      }
   }

   override protected function buildL() : void
   {
      var face:ObjectFace3D = null;
      var v0:Vector3D = this.getVertex(0,0);
      var v1:Vector3D = this.getVertex(0,3);
      var v2:Vector3D = this.getVertex(1,0);
      var v3:Vector3D = this.getVertex(1,3);
      var v4:Vector3D = new Vector3D(-Math.random() * 0.25,Math.random() * 0.25,0);
      var v5:Vector3D = this.getVertex(0,1);
      var v6:Vector3D = this.getVertex(0,2);
      var v7:Vector3D = this.getVertex(1,1);
      var v8:Vector3D = this.getVertex(1,2);
      var v9:Vector3D = new Vector3D(Math.random() * 0.25,-Math.random() * 0.25,1);
      this.faceHelper(null,texture_,v5,v9,v4,v0);
      this.faceHelper(null,texture_,v9,v8,v3,v4);
      this.faceHelper(N2,texture_,v7,v6,v1,v2);
      this.faceHelper(null,texture_,v5,v6,v7,v8,v9);
      if(Parameters.isGpuRender())
      {
         for each(face in obj3D_.faces_)
         {
            GraphicsFillExtra.setSoftwareDraw(face.bitmapFill_,true);
         }
      }
   }

   override protected function buildLine() : void
   {
      var face:ObjectFace3D = null;
      var v0:Vector3D = this.getVertex(0,0);
      var v1:Vector3D = this.getVertex(0,3);
      var v2:Vector3D = this.getVertex(2,3);
      var v3:Vector3D = this.getVertex(2,0);
      var v4:Vector3D = this.getVertex(0,1);
      var v5:Vector3D = this.getVertex(0,2);
      var v6:Vector3D = this.getVertex(2,2);
      var v7:Vector3D = this.getVertex(2,1);
      this.faceHelper(N7,texture_,v4,v7,v3,v0);
      this.faceHelper(N3,texture_,v6,v5,v1,v2);
      this.faceHelper(null,texture_,v4,v5,v6,v7);
      if(Parameters.isGpuRender())
      {
         for each(face in obj3D_.faces_)
         {
            GraphicsFillExtra.setSoftwareDraw(face.bitmapFill_,true);
         }
      }
   }

   override protected function buildT() : void
   {
      var face:ObjectFace3D = null;
      var v0:Vector3D = this.getVertex(0,0);
      var v1:Vector3D = this.getVertex(0,3);
      var v2:Vector3D = this.getVertex(1,0);
      var v3:Vector3D = this.getVertex(1,3);
      var v4:Vector3D = this.getVertex(3,3);
      var v5:Vector3D = this.getVertex(3,0);
      var v6:Vector3D = this.getVertex(0,1);
      var v7:Vector3D = this.getVertex(0,2);
      var v8:Vector3D = this.getVertex(1,1);
      var v9:Vector3D = this.getVertex(1,2);
      var va:Vector3D = this.getVertex(3,2);
      var vb:Vector3D = this.getVertex(3,1);
      this.faceHelper(N2,texture_,v8,v7,v1,v2);
      this.faceHelper(null,texture_,va,v9,v3,v4);
      this.faceHelper(N0,texture_,v6,vb,v5,v0);
      this.faceHelper(null,texture_,v6,v7,v8,v9,va,vb);
      if(Parameters.isGpuRender())
      {
         for each(face in obj3D_.faces_)
         {
            GraphicsFillExtra.setSoftwareDraw(face.bitmapFill_,true);
         }
      }
   }

   override protected function buildCross() : void
   {
      var face:ObjectFace3D = null;
      var v0:Vector3D = this.getVertex(0,0);
      var v1:Vector3D = this.getVertex(0,3);
      var v2:Vector3D = this.getVertex(1,0);
      var v3:Vector3D = this.getVertex(1,3);
      var v4:Vector3D = this.getVertex(2,3);
      var v5:Vector3D = this.getVertex(2,0);
      var v6:Vector3D = this.getVertex(3,3);
      var v7:Vector3D = this.getVertex(3,0);
      var v8:Vector3D = this.getVertex(0,1);
      var v9:Vector3D = this.getVertex(0,2);
      var va:Vector3D = this.getVertex(1,1);
      var vb:Vector3D = this.getVertex(1,2);
      var vc:Vector3D = this.getVertex(2,2);
      var vd:Vector3D = this.getVertex(2,1);
      var ve:Vector3D = this.getVertex(3,2);
      var vf:Vector3D = this.getVertex(3,1);
      this.faceHelper(N2,texture_,va,v9,v1,v2);
      this.faceHelper(N4,texture_,vc,vb,v3,v4);
      this.faceHelper(N6,texture_,ve,vd,v5,v6);
      this.faceHelper(N0,texture_,v8,vf,v7,v0);
      this.faceHelper(null,texture_,v8,v9,va,vb,vc,vd,ve,vf);
      if(Parameters.isGpuRender())
      {
         for each(face in obj3D_.faces_)
         {
            GraphicsFillExtra.setSoftwareDraw(face.bitmapFill_,true);
         }
      }
   }

   protected function getVertex(side:int, id:int) : Vector3D
   {
      var r:int = 0;
      var v:Number = NaN;
      var h:Number = NaN;
      var x:int = x_;
      var y:int = y_;
      var rside:int = (side + rotation_) % 4;
      switch(rside)
      {
         case 1:
            x++;
            break;
         case 2:
            y++;
      }
      switch(id)
      {
         case 0:
         case 3:
            r = 15 + (x * 1259 ^ y * 2957) % 35;
            break;
         case 1:
         case 2:
            r = 3 + (x * 2179 ^ y * 1237) % 35;
      }
      switch(id)
      {
         case 0:
            v = -r / 100;
            h = 0;
            break;
         case 1:
            v = -r / 100;
            h = 1;
            break;
         case 2:
            v = r / 100;
            h = 1;
            break;
         case 3:
            v = r / 100;
            h = 0;
      }
      switch(side)
      {
         case 0:
            return new Vector3D(v,-0.5,h);
         case 1:
            return new Vector3D(0.5,v,h);
         case 2:
            return new Vector3D(v,0.5,h);
         case 3:
            return new Vector3D(-0.5,v,h);
         default:
            return null;
      }
   }

   protected function faceHelper(normalL:Vector3D, texture:BitmapData, ... args) : void
   {
      var v:Vector3D = null;
      var oldLen:int = 0;
      var i:int = 0;
      var offset:int = obj3D_.vL_.length / 3;
      for each(v in args)
      {
         obj3D_.vL_.push(v.x,v.y,v.z);
      }
      oldLen = obj3D_.faces_.length;
      if(args.length == 4)
      {
         obj3D_.uvts_.push(0,0,0,1,0,0,1,1,0,0,1,0);
         if(Math.random() < 0.5)
         {
            obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[offset,offset + 1,offset + 3]),new ObjectFace3D(obj3D_,new <int>[offset + 1,offset + 2,offset + 3]));
         }
         else
         {
            obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[offset,offset + 2,offset + 3]),new ObjectFace3D(obj3D_,new <int>[offset,offset + 1,offset + 2]));
         }
      }
      else if(args.length == 3)
      {
         obj3D_.uvts_.push(0,0,0,0,1,0,1,1,0);
         obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[offset,offset + 1,offset + 2]));
      }
      else if(args.length == 5)
      {
         obj3D_.uvts_.push(0.2,0,0,0.8,0,0,1,0.2,0,1,0.8,0,0,0.8,0);
         obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[offset,offset + 1,offset + 2,offset + 3,offset + 4]));
      }
      else if(args.length == 6)
      {
         obj3D_.uvts_.push(0,0,0,0.2,0,0,1,0.2,0,1,0.8,0,0,0.8,0,0,0.2,0);
         obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[offset,offset + 1,offset + 2,offset + 3,offset + 4,offset + 5]));
      }
      else if(args.length == 8)
      {
         obj3D_.uvts_.push(0,0,0,0.2,0,0,1,0.2,0,1,0.8,0,0.8,1,0,0.2,1,0,0,0.8,0,0,0.2,0);
         obj3D_.faces_.push(new ObjectFace3D(obj3D_,new <int>[offset,offset + 1,offset + 2,offset + 3,offset + 4,offset + 5,offset + 6,offset + 7]));
      }
      if(normalL != null || texture != null)
      {
         for(i = oldLen; i < obj3D_.faces_.length; i++)
         {
            obj3D_.faces_[i].normalL_ = normalL;
            obj3D_.faces_[i].texture_ = texture;
         }
      }
   }
}
}
