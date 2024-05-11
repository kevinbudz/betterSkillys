// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//io.decagames.rotmg.fame.data.bonus.FameBonusConfig

package io.decagames.rotmg.fame.data.bonus
{
    public class FameBonusConfig 
    {

        private static const CONFIG:Array = [[10, 10, 2, "Legacy", "Beat previous best level for this class."], [25, 0, 20, "Thirsty", "Never drank a potion."], [25, 0, 20, "Pacifist", "Never dealt any damage with shots."], [25, 0, 20, "Mundane", "Never used special ability."], [25, 0, 20, "BootsOnGround", "Never teleported."], [10, 0, 1, "TunnelRat", "Completed the Pirate Cave, Spider Den, Forbidden Jungle, Snake Pit, Sprite World, Undead Lair, Abyss of Demons, Tomb of The Ancients, Ocean Trench and Manor of the Immortals."], [10, 0, 20, "GodEnemy", "More than 10% of kills are gods."], [10, 0, 20, "GodSlayer", "More than 50% of kills are gods."], [10, 0, 1, "OryxSlayer", "Dealt the killing blow to Oryx."], [10, 0, 20, "Accurate", "Accuracy of better than 25%."], [10, 0, 20, "SharpShooter", "Accuracy of better than 50%."], [10, 0, 20, "Sniper", "Accuracy of better than 75%."], [5, 0, 1, "Explorer", "More than 1 million tiles uncovered."], [5, 0, 1, "Cartographer", "More than 4 million tiles uncovered."], [10, 0, 20, "CubeFriend", "Never killed a cube."], [5, 0, 20, "", ""], [10, 0, 1, "FirstBorn", "Best fame of any of your previous incarnations."], [10, 0, 1, "", ""], [10, 0, 1, "TeamPlayer", "More than 100 party member level ups."], [10, 0, 1, "LeaderOfMen", "More than 1000 party member level ups."], [10, 20, 1, "Ancestor", "The first in a long line of heros."], [10, 0, 1, "DoerOfDeeds", "More than 1000 quests completed."], [-1, -1, 1, "WellEquipped", "Combined Fame Bonus of all worn equipment."]];


        public static function getBonus(_arg_1:int):FameBonus
        {
            if (_arg_1 > CONFIG.length)
            {
                return (null);
            }
            return (new FameBonus(_arg_1, CONFIG[_arg_1][0], CONFIG[_arg_1][1], CONFIG[_arg_1][2], CONFIG[_arg_1][3], CONFIG[_arg_1][4]));
        }


    }
}//package io.decagames.rotmg.fame.data.bonus

