package com.company.assembleegameclient.objects.particles
{
   public class ParticleLibrary
   {
      
      public static const propsLibrary_:Object = {};
       
      
      public function ParticleLibrary()
      {
         super();
      }
      
      public static function parseFromXML(xml:XML) : void
      {
         var particleXML:XML = null;
         for each(particleXML in xml.Particle)
         {
            propsLibrary_[particleXML.@id] = new ParticleProperties(particleXML);
         }
      }
   }
}
