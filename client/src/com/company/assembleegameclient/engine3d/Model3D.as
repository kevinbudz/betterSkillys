package com.company.assembleegameclient.engine3d
{
import com.company.util.ConversionUtil;
import flash.display3D.Context3D;
import flash.utils.ByteArray;
import kabam.rotmg.stage3D.Object3D.Model3D_stage3d;
import kabam.rotmg.stage3D.Object3D.Object3DStage3D;

public class Model3D
{

   private static var modelLib_:Object = new Object();

   private static var models:Object = new Object();


   public var vL_:Vector.<Number>;

   public var uvts_:Vector.<Number>;

   public var faces_:Vector.<ModelFace3D>;

   public function Model3D()
   {
      this.vL_ = new Vector.<Number>();
      this.uvts_ = new Vector.<Number>();
      this.faces_ = new Vector.<ModelFace3D>();
      super();
   }

   public static function parse3DOBJ(name:String, bytes:ByteArray) : void
   {
      var obj:Model3D_stage3d = new Model3D_stage3d();
      obj.readBytes(bytes);
      models[name] = obj;
   }

   public static function Create3dBuffer(context3d:Context3D) : void
   {
      var obj:Model3D_stage3d = null;
      for each(obj in models)
      {
         obj.CreatBuffer(context3d);
      }
   }

   public static function parseFromOBJ(name:String, obj:String) : void
   {
      var line:String = null;
      var model:Model3D = null;
      var vvt:String = null;
      var fi:int = 0;
      var fields:Array = null;
      var typeName:String = null;
      var vvtField:String = null;
      var v_vt:Array = null;
      var f:Array = null;
      var mtl:String = null;
      var faceIndicies:Vector.<int> = null;
      var i:int = 0;
      var lines:Array = obj.split(/\s*\n\s*/);
      var vs:Array = [];
      var vts:Array = [];
      var vvts:Array = [];
      var vvtsMap:Object = {};
      var fs:Array = [];
      var currentMtl:String = null;
      var mtls:Array = [];
      for each(line in lines)
      {
         if(line.charAt(0) == "#" || line.length == 0)
         {
            continue;
         }
         fields = line.split(/\s+/);
         if(fields.length == 0)
         {
            continue;
         }
         typeName = fields.shift();
         if(typeName.length == 0)
         {
            continue;
         }
         switch(typeName)
         {
            case "v":
               if(fields.length != 3)
               {
                  trace("ERROR: In file \"" + name + "\", incorrect fields in vertex: " + line);
                  return;
               }
               vs.push(fields);
               continue;
            case "vt":
               if(fields.length != 2)
               {
                  trace("ERROR: In file \"" + name + "\", incorrect fields in vt: " + line);
                  return;
               }
               vts.push(fields);
               continue;
            case "f":
               if(fields.length < 3)
               {
                  trace("ERROR: In file \"" + name + "\", too few vertexes in face: " + line);
                  return;
               }
               fs.push(fields);
               mtls.push(currentMtl);
               for each(vvtField in fields)
               {
                  if(!vvtsMap.hasOwnProperty(vvtField))
                  {
                     vvtsMap[vvtField] = vvts.length;
                     vvts.push(vvtField);
                  }
               }
               continue;
            case "usemtl":
               if(fields.length != 1)
               {
                  trace("ERROR: In file \"" + name + "\", incorrect fields in usemtl: " + line);
                  return;
               }
               currentMtl = fields[0];
               continue;
            default:
               continue;
         }
      }
      model = new Model3D();
      for each(vvt in vvts)
      {
         v_vt = vvt.split("/");
         ConversionUtil.addToNumberVector(vs[int(v_vt[0]) - 1],model.vL_);
         if(v_vt.length > 1 && v_vt[1].length > 0)
         {
            ConversionUtil.addToNumberVector(vts[int(v_vt[1]) - 1],model.uvts_);
            model.uvts_.push(0);
         }
         else
         {
            model.uvts_.push(0,0,0);
         }
      }
      for(fi = 0; fi < fs.length; fi++)
      {
         f = fs[fi];
         mtl = mtls[fi];
         faceIndicies = new Vector.<int>();
         for(i = 0; i < f.length; i++)
         {
            faceIndicies.push(vvtsMap[f[i]]);
         }
         model.faces_.push(new ModelFace3D(model,faceIndicies,mtl == null || mtl.substr(0,5) != "Solid"));
      }
      model.orderFaces();
      modelLib_[name] = model;
   }

   public static function getModel(name:String) : Model3D
   {
      return modelLib_[name];
   }

   public static function getObject3D(name:String) : Object3D
   {
      var m:Model3D = modelLib_[name];
      if(m == null)
      {
         return null;
      }
      return new Object3D(m);
   }

   public static function getStage3dObject3D(name:String) : Object3DStage3D
   {
      var m:Model3D_stage3d = models[name];
      if(m == null)
      {
         return null;
      }
      return new Object3DStage3D(m);
   }

   public function toString() : String
   {
      var str:String = "";
      str = str + ("vL(" + this.vL_.length + "): " + this.vL_.join() + "\n");
      str = str + ("uvts(" + this.uvts_.length + "): " + this.uvts_.join() + "\n");
      str = str + ("faces_(" + this.faces_.length + "): " + this.faces_.join() + "\n");
      return str;
   }

   public function orderFaces() : void
   {
      this.faces_.sort(ModelFace3D.compare);
   }
}
}
