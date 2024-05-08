package com.company.assembleegameclient.objects
{
import com.company.assembleegameclient.util.ConditionEffect;

public class ProjectileProperties
{

   public var bulletType_:int;
   public var objectId_:String;
   public var lifetime_:int;
   public var speed_:int;
   public var size_:int;
   public var minDamage_:int;
   public var maxDamage_:int;
   public var effects_:Vector.<uint> = null;
   public var multiHit_:Boolean;
   public var passesCover_:Boolean;
   public var armorPiercing_:Boolean;
   public var particleTrail_:Boolean;
   public var particleTrailIntensity_:int = -1;
   public var particleTrailLifetimeMS:int = -1;
   public var particleTrailColor_:int = 0xFF00FF;
   public var wavy_:Boolean;
   public var parametric_:Boolean;
   public var boomerang_:Boolean;
   public var amplitude_:Number;
   public var frequency_:Number;
   public var magnitude_:Number;
   public var faceDir_:Boolean;
   public var noRotation_:Boolean;

   public function ProjectileProperties(projectileXML:XML)
   {
      var condEffectXML:XML = null;
      super();
      this.bulletType_ = int(projectileXML.@id);
      this.objectId_ = projectileXML.ObjectId;
      this.lifetime_ = int(projectileXML.LifetimeMS);
      this.speed_ = int(projectileXML.Speed);
      this.size_ = Boolean(projectileXML.hasOwnProperty("Size"))?int(Number(projectileXML.Size)):int(-1);
      if(projectileXML.hasOwnProperty("Damage"))
      {
         this.minDamage_ = this.maxDamage_ = int(projectileXML.Damage);
      }
      else
      {
         this.minDamage_ = int(projectileXML.MinDamage);
         this.maxDamage_ = int(projectileXML.MaxDamage);
      }
      for each(condEffectXML in projectileXML.ConditionEffect)
      {
         if(this.effects_ == null)
         {
            this.effects_ = new Vector.<uint>();
         }
         this.effects_.push(ConditionEffect.getConditionEffectFromName(String(condEffectXML)));
      }
      this.multiHit_ = projectileXML.hasOwnProperty("MultiHit");
      this.passesCover_ = projectileXML.hasOwnProperty("PassesCover");
      this.armorPiercing_ = projectileXML.hasOwnProperty("ArmorPiercing");
      this.particleTrail_ = projectileXML.hasOwnProperty("ParticleTrail");
      this.wavy_ = projectileXML.hasOwnProperty("Wavy");
      this.parametric_ = projectileXML.hasOwnProperty("Parametric");
      this.boomerang_ = projectileXML.hasOwnProperty("Boomerang");
      this.amplitude_ = Boolean(projectileXML.hasOwnProperty("Amplitude"))?Number(Number(projectileXML.Amplitude)):Number(0);
      this.frequency_ = Boolean(projectileXML.hasOwnProperty("Frequency"))?Number(Number(projectileXML.Frequency)):Number(1);
      this.magnitude_ = Boolean(projectileXML.hasOwnProperty("Magnitude"))?Number(Number(projectileXML.Magnitude)):Number(3);
      this.faceDir_ = projectileXML.hasOwnProperty("FaceDir");
      this.noRotation_ = projectileXML.hasOwnProperty("NoRotation");
      if (projectileXML.ParticleTrail.hasOwnProperty("@intensity")) {
         this.particleTrailIntensity_ = (Number(projectileXML.ParticleTrail.@intensity) * 100);
      }
      if (projectileXML.ParticleTrail.hasOwnProperty("@lifetimeMS")) {
         this.particleTrailLifetimeMS = Number(projectileXML.ParticleTrail.@lifetimeMS);
      }
      this.particleTrailColor_ = ((this.particleTrail_) ? Number(projectileXML.ParticleTrail) : Number(0xFF00FF));
      if (this.particleTrailColor_ == 0) {
         this.particleTrailColor_ = 0xFF00FF;
      }
   }
}
}
