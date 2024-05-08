package com.company.assembleegameclient.util
{
   import com.company.util.AssetLibrary;
   import flash.display.BitmapData;
   
   public class GuildUtil
   {
      
      public static const INITIATE:int = 0;
      
      public static const MEMBER:int = 10;
      
      public static const OFFICER:int = 20;
      
      public static const LEADER:int = 30;
      
      public static const FOUNDER:int = 40;
      
      public static const MAX_MEMBERS:int = 128;
       
      
      public function GuildUtil()
      {
         super();
      }
      
      public static function rankToString(rank:int) : String
      {
         switch(rank)
         {
            case INITIATE:
               return "Initiate";
            case MEMBER:
               return "Member";
            case OFFICER:
               return "Officer";
            case LEADER:
               return "Leader";
            case FOUNDER:
               return "Founder";
            default:
               return "Unknown";
         }
      }
      
      public static function rankToIcon(rank:int, size:int) : BitmapData
      {
         var icon:BitmapData = null;
         switch(rank)
         {
            case INITIATE:
               icon = AssetLibrary.getImageFromSet("lofiInterfaceBig",20);
               break;
            case MEMBER:
               icon = AssetLibrary.getImageFromSet("lofiInterfaceBig",19);
               break;
            case OFFICER:
               icon = AssetLibrary.getImageFromSet("lofiInterfaceBig",18);
               break;
            case LEADER:
               icon = AssetLibrary.getImageFromSet("lofiInterfaceBig",17);
               break;
            case FOUNDER:
               icon = AssetLibrary.getImageFromSet("lofiInterfaceBig",16);
         }
         return TextureRedrawer.redraw(icon,size,true,0,true);
      }
      
      public static function guildFameIcon(size:int) : BitmapData
      {
         var icon:BitmapData = AssetLibrary.getImageFromSet("lofiObj3",226);
         return TextureRedrawer.redraw(icon,size,true,0,true);
      }
      
      public static function allowedChange(authRank:int, oldRank:int, newRank:int) : Boolean
      {
         if(oldRank == newRank)
         {
            return false;
         }
         if(authRank == FOUNDER && oldRank < FOUNDER && newRank < FOUNDER)
         {
            return true;
         }
         if(authRank == LEADER && oldRank < LEADER && newRank <= LEADER)
         {
            return true;
         }
         if(authRank == OFFICER && oldRank < OFFICER && newRank < OFFICER)
         {
            return true;
         }
         return false;
      }
      
      public static function promotedRank(rank:int) : int
      {
         switch(rank)
         {
            case INITIATE:
               return MEMBER;
            case MEMBER:
               return OFFICER;
            case OFFICER:
               return LEADER;
            default:
               return FOUNDER;
         }
      }
      
      public static function canPromote(myRank:int, rank:int) : Boolean
      {
         var newRank:int = promotedRank(rank);
         return allowedChange(myRank,rank,newRank);
      }
      
      public static function demotedRank(rank:int) : int
      {
         switch(rank)
         {
            case OFFICER:
               return MEMBER;
            case LEADER:
               return OFFICER;
            case FOUNDER:
               return LEADER;
            default:
               return INITIATE;
         }
      }
      
      public static function canDemote(myRank:int, rank:int) : Boolean
      {
         var newRank:int = demotedRank(rank);
         return allowedChange(myRank,rank,newRank);
      }
      
      public static function canRemove(myRank:int, rank:int) : Boolean
      {
         return myRank >= OFFICER && rank < myRank;
      }
   }
}
