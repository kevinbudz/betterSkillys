package kabam.rotmg.death.model
{
   import kabam.rotmg.messaging.impl.incoming.Death;
   
   public class DeathModel
   {
       
      
      private var isDeathFameViewPending:Boolean;
      
      private var lastDeath:Death;
      
      public function DeathModel()
      {
         super();
      }
      
      public function setLastDeath(death:Death) : void
      {
         this.lastDeath = death;
         this.isDeathFameViewPending = true;
      }
      
      public function getLastDeath() : Death
      {
         return this.lastDeath;
      }
      
      public function getIsDeathViewPending() : Boolean
      {
         return this.isDeathFameViewPending;
      }
      
      public function clearPendingDeathView() : void
      {
         this.isDeathFameViewPending = false;
      }
   }
}
