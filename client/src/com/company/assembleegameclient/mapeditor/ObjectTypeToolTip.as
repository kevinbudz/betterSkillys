package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import com.company.ui.SimpleText;
   import flash.filters.DropShadowFilter;
   
   public class ObjectTypeToolTip extends ToolTip
   {
      
      private static const MAX_WIDTH:int = 180;
       
      
      private var titleText_:SimpleText;
      
      private var descText_:SimpleText;
      
      public function ObjectTypeToolTip(objectXML:XML)
      {
         var projectile:XML = null;
         super(3552822,1,10197915,1,true);
         this.titleText_ = new SimpleText(16,16777215,false,MAX_WIDTH - 4,0);
         this.titleText_.setBold(true);
         this.titleText_.wordWrap = true;
         this.titleText_.text = String(objectXML.@id);
         this.titleText_.useTextDimensions();
         this.titleText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.titleText_.x = 0;
         this.titleText_.y = 0;
         addChild(this.titleText_);
         var desc:String = "";
         if(objectXML.hasOwnProperty("Group"))
         {
            desc = desc + ("Group: " + objectXML.Group + "\n");
         }
         if(objectXML.hasOwnProperty("Static"))
         {
            desc = desc + "Static\n";
         }
         if(objectXML.hasOwnProperty("Enemy"))
         {
            desc = desc + "Enemy\n";
            if(objectXML.hasOwnProperty("MaxHitPoints"))
            {
               desc = desc + ("MaxHitPoints: " + objectXML.MaxHitPoints + "\n");
            }
            if(objectXML.hasOwnProperty("Defense"))
            {
               desc = desc + ("Defense: " + objectXML.Defense + "\n");
            }
         }
         if(objectXML.hasOwnProperty("God"))
         {
            desc = desc + "God\n";
         }
         if(objectXML.hasOwnProperty("Quest"))
         {
            desc = desc + "Quest\n";
         }
         if(objectXML.hasOwnProperty("Hero"))
         {
            desc = desc + "Hero\n";
         }
         if(objectXML.hasOwnProperty("Encounter"))
         {
            desc = desc + "Encounter\n";
         }
         if(objectXML.hasOwnProperty("Level"))
         {
            desc = desc + ("Level: " + objectXML.Level + "\n");
         }
         if(objectXML.hasOwnProperty("Terrain"))
         {
            desc = desc + ("Terrain: " + objectXML.Terrain + "\n");
         }
         for each(projectile in objectXML.Projectile)
         {
            desc = desc + ("Projectile " + projectile.@id + ": " + projectile.ObjectId + "\n" + "\tDamage: " + projectile.Damage + "\n" + "\tSpeed: " + projectile.Speed + "\n");
            if(projectile.hasOwnProperty("PassesCover"))
            {
               desc = desc + "\tPassesCover\n";
            }
            if(projectile.hasOwnProperty("MultiHit"))
            {
               desc = desc + "\tMultiHit\n";
            }
            if(projectile.hasOwnProperty("ConditionEffect"))
            {
               desc = desc + ("\t" + projectile.ConditionEffect + " for " + projectile.ConditionEffect.@duration + " secs\n");
            }
            if(projectile.hasOwnProperty("Parametric"))
            {
               desc = desc + "\tParametric\n";
            }
         }
         this.descText_ = new SimpleText(14,11776947,false,MAX_WIDTH,0);
         this.descText_.wordWrap = true;
         this.descText_.text = String(desc);
         this.descText_.useTextDimensions();
         this.descText_.filters = [new DropShadowFilter(0,0,0,0.5,12,12)];
         this.descText_.x = 0;
         this.descText_.y = this.titleText_.height + 2;
         addChild(this.descText_);
      }
   }
}
