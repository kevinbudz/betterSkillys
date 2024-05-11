package com.company.assembleegameclient.appengine
{
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import flash.events.Event;
   import kabam.rotmg.account.core.Account;
   import kabam.rotmg.core.StaticInjectorContext;
   import kabam.rotmg.servers.api.LatLong;
   import org.swiftsuspenders.Injector;
   
   public class SavedCharactersList extends Event
   {
      public static const SAVED_CHARS_LIST:String = "SAVED_CHARS_LIST";
      public static const AVAILABLE:String = "available";
      public static const UNAVAILABLE:String = "unavailable";
      public static const UNRESTRICTED:String = "unrestricted";
      private static const DEFAULT_LATLONG:LatLong = new LatLong(37.4436,-122.412);

      private var origData_:String;
      private var charsXML_:XML;
      public var accountId_:int;
      public var nextCharId_:int;
      public var maxNumChars_:int;
      public var numChars_:int = 0;
      public var savedChars_:Vector.<SavedCharacter>;
      public var charStats_:Object;
      public var totalFame_:int = 0;
      public var bestCharFame_:int = 0;
      public var fame_:int = 0;
      public var credits_:int = 0;
      public var numStars_:int = 0;
      public var nextCharSlotPrice_:int;
      public var nextCharSlotCurrency_:int;
      public var guildName_:String;
      public var guildRank_:int;
      public var name_:String = null;
      public var nameChosen_:Boolean;
      public var isAdmin_:Boolean;
      public var news_:Vector.<SavedNewsItem>;
      public var myPos_:LatLong;
      public var hasPlayerDied:Boolean = false;
      public var classAvailability:Object;
      public var menuMusic_:String;
      public var deadMusic_:String;
      private var account:Account;
      
      public function SavedCharactersList(data:String)
      {
         var value:* = undefined;
         var account:Account = null;
         this.savedChars_ = new Vector.<SavedCharacter>();
         this.charStats_ = {};
         this.news_ = new Vector.<SavedNewsItem>();
         super(SAVED_CHARS_LIST);
         this.origData_ = data;
         this.charsXML_ = new XML(this.origData_);
         var accountXML:XML = XML(this.charsXML_.Account);
         this.parseUserData(accountXML);
         this.parseGuildData(accountXML);
         this.parseCharacterData();
         this.parseCharacterStatsData();
         this.parseNewsData();
         this.parseGeoPositioningData();
         this.reportUnlocked();
         var injector:Injector = StaticInjectorContext.getInjector();
         if(injector)
         {
            account = injector.getInstance(Account);
            account.reportIntStat("BestLevel",this.bestOverallLevel());
            account.reportIntStat("BestFame",this.bestOverallFame());
            account.reportIntStat("NumStars",this.numStars_);
         }
         this.classAvailability = new Object();
         for each(value in this.charsXML_.ClassAvailabilityList.ClassAvailability)
         {
            this.classAvailability[value.@id.toString()] = value.toString();
         }
      }
      
      public function getCharById(id:int) : SavedCharacter
      {
         var savedChar:SavedCharacter = null;
         for each(savedChar in this.savedChars_)
         {
            if(savedChar.charId() == id)
            {
               return savedChar;
            }
         }
         return null;
      }
      
      private function parseUserData(accountXML:XML) : void
      {
         this.accountId_ = accountXML.AccountId;
         this.name_ = accountXML.Name;
         this.nameChosen_ = accountXML.hasOwnProperty("NameChosen");
         this.isAdmin_ = accountXML.hasOwnProperty("Admin");
         this.totalFame_ = int(accountXML.Stats.TotalFame);
         this.fame_ = int(accountXML.Stats.Fame);
         this.bestCharFame_ = int(accountXML.Stats.BestCharFame);
         this.credits_ = int(accountXML.Credits);
         this.nextCharSlotPrice_ = int(accountXML.NextCharSlotPrice);
         this.nextCharSlotCurrency_ = int(accountXML.NextCharSlotCurrency);
         this.hasPlayerDied = !accountXML.hasOwnProperty("isFirstDeath");
         this.menuMusic_ = accountXML.MenuMusic;
         this.deadMusic_ = accountXML.DeadMusic;
      }

      private function parseGuildData(accountXML:XML) : void
      {
         var guildXML:XML = null;
         if(accountXML.hasOwnProperty("Guild"))
         {
            guildXML = XML(accountXML.Guild);
            this.guildName_ = guildXML.Name;
            this.guildRank_ = int(guildXML.Rank);
         }
      }
      
      private function parseCharacterData() : void
      {
         var charXML:XML = null;
         this.nextCharId_ = int(this.charsXML_.@nextCharId);
         this.maxNumChars_ = int(this.charsXML_.@maxNumChars);
         for each(charXML in this.charsXML_.Char)
         {
            this.savedChars_.push(new SavedCharacter(charXML,this.name_));
            this.numChars_++;
         }
         this.savedChars_.sort(SavedCharacter.compare);
      }
      
      private function parseCharacterStatsData() : void
      {
         var charStatsXML:XML = null;
         var type:int = 0;
         var charStats:CharacterStats = null;
         var statsXML:XML = XML(this.charsXML_.Account.Stats);
         for each(charStatsXML in statsXML.ClassStats)
         {
            type = int(charStatsXML.@objectType);
            charStats = new CharacterStats(charStatsXML);
            this.numStars_ = this.numStars_ + charStats.numStars();
            this.charStats_[type] = charStats;
         }
      }
      
      private function parseNewsData() : void
      {
         var newsItemXML:XML = null;
         var newsXML:XML = XML(this.charsXML_.News);
         for each(newsItemXML in newsXML.Item)
         {
            this.news_.push(new SavedNewsItem(newsItemXML.Icon,newsItemXML.Title,newsItemXML.TagLine,newsItemXML.Link,int(newsItemXML.Date)));
         }
      }
      
      private function parseGeoPositioningData() : void
      {
         if(this.charsXML_.hasOwnProperty("Lat") && this.charsXML_.hasOwnProperty("Long"))
         {
            this.myPos_ = new LatLong(Number(this.charsXML_.Lat),Number(this.charsXML_.Long));
         }
         else
         {
            this.myPos_ = DEFAULT_LATLONG;
         }
      }
      
      public function bestLevel(objectType:int) : int
      {
         var charStats:CharacterStats = this.charStats_[objectType];
         return charStats == null?int(0):int(charStats.bestLevel());
      }
      
      public function bestOverallLevel() : int
      {
         var charStats:CharacterStats = null;
         var bestLevel:int = 0;
         for each(charStats in this.charStats_)
         {
            if(charStats.bestLevel() > bestLevel)
            {
               bestLevel = charStats.bestLevel();
            }
         }
         return bestLevel;
      }
      
      public function bestFame(objectType:int) : int
      {
         var charStats:CharacterStats = this.charStats_[objectType];
         return charStats == null?int(0):int(charStats.bestFame());
      }
      
      public function bestOverallFame() : int
      {
         var charStats:CharacterStats = null;
         var bestFame:int = 0;
         for each(charStats in this.charStats_)
         {
            if(charStats.bestFame() > bestFame)
            {
               bestFame = charStats.bestFame();
            }
         }
         return bestFame;
      }
      
      public function levelRequirementsMet(objectType:int) : Boolean
      {
         var unlockLevelXML:XML = null;
         var unlockType:int = 0;
         var playerXML:XML = ObjectLibrary.xmlLibrary_[objectType];
         for each(unlockLevelXML in playerXML.UnlockLevel)
         {
            unlockType = ObjectLibrary.idToType_[unlockLevelXML.toString()];
            if(this.bestLevel(unlockType) < int(unlockLevelXML.@level))
            {
               return false;
            }
         }
         return true;
      }
      
      public function availableCharSlots() : int
      {
         return this.maxNumChars_ - this.numChars_;
      }
      
      public function hasAvailableCharSlot() : Boolean
      {
         return this.numChars_ < this.maxNumChars_;
      }
      
      public function newUnlocks(type:int, level:int) : Array
      {
         var playerXML:XML = null;
         var objectType:int = 0;
         var satisfied:Boolean = false;
         var newlySatisfied:Boolean = false;
         var unlockLevelXML:XML = null;
         var unlockType:int = 0;
         var unlockLevel:int = 0;
         var ret:Array = new Array();
         for(var i:int = 0; i < ObjectLibrary.playerChars_.length; i++)
         {
            playerXML = ObjectLibrary.playerChars_[i];
            objectType = int(playerXML.@type);
            if(!this.levelRequirementsMet(objectType))
            {
               satisfied = true;
               newlySatisfied = false;
               for each(unlockLevelXML in playerXML.UnlockLevel)
               {
                  unlockType = ObjectLibrary.idToType_[unlockLevelXML.toString()];
                  unlockLevel = int(unlockLevelXML.@level);
                  if(this.bestLevel(unlockType) < unlockLevel)
                  {
                     if(unlockType != type || unlockLevel != level)
                     {
                        satisfied = false;
                        break;
                     }
                     newlySatisfied = true;
                  }
               }
               if(satisfied && newlySatisfied)
               {
                  ret.push(objectType);
               }
            }
         }
         return ret;
      }
      
      override public function clone() : Event
      {
         return new SavedCharactersList(this.origData_);
      }
      
      override public function toString() : String
      {
         return "[" + " numChars: " + this.numChars_ + " maxNumChars: " + this.maxNumChars_ + " ]";
      }
      
      private function reportUnlocked() : void
      {
         var injector:Injector = StaticInjectorContext.getInjector();
         if(injector)
         {
            this.account = injector.getInstance(Account);
            this.account && this.updateAccount();
         }
      }
      
      private function updateAccount() : void
      {
         var playerXML:XML = null;
         var objectType:int = 0;
         var unlocked:int = 0;
         for(var i:int = 0; i < ObjectLibrary.playerChars_.length; i++)
         {
            playerXML = ObjectLibrary.playerChars_[i];
            objectType = int(playerXML.@type);
            if(this.levelRequirementsMet(objectType))
            {
               this.account.reportIntStat(playerXML.@id + "Unlocked",1);
               unlocked++;
            }
         }
         this.account.reportIntStat("ClassesUnlocked",unlocked);
      }
   }
}
