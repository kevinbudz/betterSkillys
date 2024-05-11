package com.company.assembleegameclient.appengine
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
   import com.company.assembleegameclient.util.AnimatedChar;
   import com.company.assembleegameclient.util.AnimatedChars;
   import com.company.assembleegameclient.util.MaskedImage;
   import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.redrawers.GlowRedrawer;
import com.company.util.CachingColorTransformer;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;

import kabam.rotmg.assets.services.CharacterFactory;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.CharacterSkin;

import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.constants.GeneralConstants;
import kabam.rotmg.core.StaticInjectorContext;

import org.swiftsuspenders.Injector;

public class SavedCharacter
   {
      private static const notAvailableCT:ColorTransform = new ColorTransform(0, 0, 0, 0.5, 0, 0, 0, 0);
      private static const dimCT:ColorTransform = new ColorTransform(0.75, 0.75, 0.75, 1, 0, 0, 0, 0);

      public var charXML_:XML;
      
      public var name_:String = null;
      
      public function SavedCharacter(charXML:XML, name:String)
      {
         super();
         this.charXML_ = charXML;
         this.name_ = name;
      }
      
      public static function getImage(savedChar:SavedCharacter, playerXML:XML, dir:int, action:int, p:Number, available:Boolean, selected:Boolean) : BitmapData
      {
         var animatedChar:AnimatedChar = AnimatedChars.getAnimatedChar(String(playerXML.AnimatedTexture.File),int(playerXML.AnimatedTexture.Index));
         var image:MaskedImage = animatedChar.imageFromDir(dir,action,p);
         var tex1:int = savedChar != null?int(savedChar.tex1()):int(null);
         var tex2:int = savedChar != null?int(savedChar.tex2()):int(null);
         var bd:BitmapData = TextureRedrawer.resize(image.image_,image.mask_,100,false,tex1,tex2);
         bd = GlowRedrawer.outlineGlow(bd,0);
         if(!available)
         {
            bd = CachingColorTransformer.transformBitmapData(bd,notAvailableCT);
         }
         else if(!selected)
         {
            bd = CachingColorTransformer.transformBitmapData(bd,dimCT);
         }
         return bd;
      }
      
      public static function compare(char1:SavedCharacter, char2:SavedCharacter) : Number
      {
         var char1Use:Number = Boolean(Parameters.data_.charIdUseMap.hasOwnProperty(char1.charId().toString()))?Number(Parameters.data_.charIdUseMap[char1.charId()]):Number(0);
         var char2Use:Number = Boolean(Parameters.data_.charIdUseMap.hasOwnProperty(char2.charId().toString()))?Number(Parameters.data_.charIdUseMap[char2.charId()]):Number(0);
         if(char1Use != char2Use)
         {
            return char2Use - char1Use;
         }
         return char2.xp() - char1.xp();
      }

      public function bornOn():String
      {
         if (!this.charXML_.hasOwnProperty("CreationDate"))
         {
            return ("Unknown");
         }
         return (this.charXML_.CreationDate);
      }

       public function fameBonus():int
       {
           var _local_4:int;
           var _local_5:XML;
           var _local_1:Player = Player.fromPlayerXML("", this.charXML_);
           var _local_2:int;
           var _local_3:uint;
           while (_local_3 < GeneralConstants.NUM_EQUIPMENT_SLOTS)
           {
               if (((_local_1.equipment_) && (_local_1.equipment_.length > _local_3)))
               {
                   _local_4 = _local_1.equipment_[_local_3];
                   if (_local_4 != -1)
                   {
                       _local_5 = ObjectLibrary.xmlLibrary_[_local_4];
                       if (((!(_local_5 == null)) && (_local_5.hasOwnProperty("FameBonus"))))
                       {
                           _local_2 = (_local_2 + int(_local_5.FameBonus));
                       }
                   }
               }
               _local_3++;
           }
           return (_local_2);
       }

      public function getIcon(_arg_1:int=100):BitmapData
      {
         var _local_2:Injector = StaticInjectorContext.getInjector();
         var _local_3:ClassesModel = _local_2.getInstance(ClassesModel);
         var _local_4:CharacterFactory = _local_2.getInstance(CharacterFactory);
         var _local_5:CharacterClass = _local_3.getCharacterClass(this.objectType());
         var _local_6:CharacterSkin = ((_local_5.skins.getSkin(this.skinType())) || (_local_5.skins.getDefaultSkin()));
         var _local_7:BitmapData = _local_4.makeIcon(_local_6.template, _arg_1, this.tex1(), this.tex2());
         return (_local_7);
      }
      
      public function charId() : int
      {
         return int(this.charXML_.@id);
      }
      
      public function name() : String
      {
         return this.name_;
      }
      
      public function objectType() : int
      {
         return int(this.charXML_.ObjectType);
      }
      
      public function skinType() : int
      {
         return int(this.charXML_.Texture);
      }
      
      public function level() : int
      {
         return int(this.charXML_.Level);
      }
      
      public function tex1() : int
      {
         return int(this.charXML_.Tex1);
      }
      
      public function tex2() : int
      {
         return int(this.charXML_.Tex2);
      }
      
      public function xp() : int
      {
         return int(this.charXML_.Exp);
      }
      
      public function fame() : int
      {
         return int(this.charXML_.CurrentFame);
      }

      public function hp() : int
      {
         return int(this.charXML_.MaxHitPoints);
      }

      public function mp() : int
      {
         return int(this.charXML_.MaxMagicPoints);
      }

      public function att() : int
      {
         return int(this.charXML_.Attack);
      }

      public function def() : int
      {
         return int(this.charXML_.Defense);
      }

      public function spd() : int
      {
         return int(this.charXML_.Speed);
      }

      public function dex() : int
      {
         return int(this.charXML_.Dexterity);
      }

      public function vit() : int
      {
         return int(this.charXML_.HpRegen);
      }

      public function wis() : int
      {
         return int(this.charXML_.MpRegen);
      }
      
      public function displayId() : String
      {
         return ObjectLibrary.typeToDisplayId_[this.objectType()];
      }
      
      public function toString() : String
      {
         return "SavedCharacter: {" + this.charXML_ + "}";
      }
   }
}
