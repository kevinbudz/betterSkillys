// Decompiled by AS3 Sorcerer 6.08
// www.as3sorcerer.com

//io.decagames.rotmg.fame.data.FameTracker

package io.decagames.rotmg.fame.data
{
    import io.decagames.rotmg.characterMetrics.tracker.CharactersMetricsTracker;
    import kabam.rotmg.ui.model.HUDModel;
    import kabam.rotmg.core.model.PlayerModel;
    import io.decagames.rotmg.fame.data.bonus.FameBonusConfig;
    import io.decagames.rotmg.fame.data.bonus.FameBonus;
    import io.decagames.rotmg.fame.data.bonus.FameBonusID;
    import io.decagames.rotmg.characterMetrics.data.MetricsID;
    import com.company.assembleegameclient.appengine.SavedCharacter;

    public class FameTracker 
    {

        [Inject]
        public var metrics:CharactersMetricsTracker;
        [Inject]
        public var hudModel:HUDModel;
        [Inject]
        public var player:PlayerModel;


        private function getFameBonus(_arg_1:int, _arg_2:int, _arg_3:int):FameBonus
        {
            var _local_4:FameBonus = FameBonusConfig.getBonus(_arg_2);
            var _local_5:int = this.getCharacterLevel(_arg_1);
            if (_local_5 < _local_4.level)
            {
                return (null);
            }
            _local_4.fameAdded = Math.floor((((_local_4.added * _arg_3) / 100) + _local_4.numAdded));
            return (_local_4);
        }

        private function getWellEquippedBonus(_arg_1:int, _arg_2:int):FameBonus
        {
            var _local_3:FameBonus = FameBonusConfig.getBonus(FameBonusID.WELL_EQUIPPED);
            _local_3.fameAdded = Math.floor(((_arg_1 * _arg_2) / 100));
            return (_local_3);
        }

        public function getCurrentTotalFame(_arg_1:int):TotalFame
        {
            var _local_2:TotalFame = new TotalFame(this.currentFame(_arg_1));
            var _local_3:int = this.getCharacterLevel(_arg_1);
            var _local_4:int = this.getCharacterType(_arg_1);
            if (this.player.getTotalFame() == 0)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.ANCESTOR, _local_2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.POTIONS_DRUNK) == 0)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.THIRSTY, _local_2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.SHOTS_THAT_DAMAGE) == 0)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.PACIFIST, _local_2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.SPECIAL_ABILITY_USES) == 0)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.MUNDANE, _local_2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.TELEPORTS) == 0)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.BOOTS_ON_THE_GROUND, _local_2.currentFame));
            }
            if (((((((((((this.metrics.getCharacterStat(_arg_1, MetricsID.PIRATE_CAVES_COMPLETED) > 0) && (this.metrics.getCharacterStat(_arg_1, MetricsID.UNDEAD_LAIRS_COMPLETED) > 0)) && (this.metrics.getCharacterStat(_arg_1, MetricsID.ABYSS_OF_DEMONS_COMPLETED) > 0)) && (this.metrics.getCharacterStat(_arg_1, MetricsID.SNAKE_PITS_COMPLETED) > 0)) && (this.metrics.getCharacterStat(_arg_1, MetricsID.SPIDER_DENS_COMPLETED) > 0)) && (this.metrics.getCharacterStat(_arg_1, MetricsID.SPRITE_WORLDS_COMPLETED) > 0)) && (this.metrics.getCharacterStat(_arg_1, MetricsID.TOMBS_COMPLETED) > 0)) && (this.metrics.getCharacterStat(_arg_1, MetricsID.TRENCHES_COMPLETED) > 0)) && (this.metrics.getCharacterStat(_arg_1, MetricsID.JUNGLES_COMPLETED) > 0)) && (this.metrics.getCharacterStat(_arg_1, MetricsID.MANORS_COMPLETED) > 0)))
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.TUNNEL_RAT, _local_2.currentFame));
            }
            var _local_5:int = this.metrics.getCharacterStat(_arg_1, MetricsID.MONSTER_KILLS);
            var _local_6:int = this.metrics.getCharacterStat(_arg_1, MetricsID.GOD_KILLS);
            if ((_local_5 + _local_6) > 0)
            {
                if ((_local_6 / (_local_5 + _local_6)) > 0.1)
                {
                    _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.ENEMY_OF_THE_GODS, _local_2.currentFame));
                }
                if ((_local_6 / (_local_5 + _local_6)) > 0.5)
                {
                    _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.SLAYER_OF_THE_GODS, _local_2.currentFame));
                }
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.ORYX_KILLS) > 0)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.ORYX_SLAYER, _local_2.currentFame));
            }
            var _local_7:int = this.metrics.getCharacterStat(_arg_1, MetricsID.SHOTS);
            var _local_8:int = this.metrics.getCharacterStat(_arg_1, MetricsID.SHOTS_THAT_DAMAGE);
            if (((_local_8 > 0) && (_local_7 > 0)))
            {
                if ((_local_8 / _local_7) > 0.25)
                {
                    _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.ACCURATE, _local_2.currentFame));
                }
                if ((_local_8 / _local_7) > 0.5)
                {
                    _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.SHARPSHOOTER, _local_2.currentFame));
                }
                if ((_local_8 / _local_7) > 0.75)
                {
                    _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.SNIPER, _local_2.currentFame));
                }
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.TILES_UNCOVERED) > 1000000)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.EXPLORER, _local_2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.TILES_UNCOVERED) > 0x3D0900)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.CARTOGRAPHER, _local_2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.CUBE_KILLS) == 0)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.FRIEND_OF_THE_CUBES, _local_2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.LEVEL_UP_ASSISTS) > 100)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.TEAM_PLAYER, _local_2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.LEVEL_UP_ASSISTS) > 1000)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.LEADER_OF_MEN, _local_2.currentFame));
            }
            if (this.metrics.getCharacterStat(_arg_1, MetricsID.QUESTS_COMPLETED) > 1000)
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.DOER_OF_DEEDS, _local_2.currentFame));
            }
            _local_2.addBonus(this.getWellEquippedBonus(this.getCharacterFameBonus(_arg_1), _local_2.currentFame));
            if (_local_2.currentFame > this.player.getBestCharFame())
            {
                _local_2.addBonus(this.getFameBonus(_arg_1, FameBonusID.FIRST_BORN, _local_2.currentFame));
            }
            return (_local_2);
        }

        private function hasMapPlayer():Boolean
        {
            return (((this.hudModel.gameSprite) && (this.hudModel.gameSprite.map)) && (this.hudModel.gameSprite.map.player_));
        }

        private function getSavedCharacter(_arg_1:int):SavedCharacter
        {
            return (this.player.getCharacterById(_arg_1));
        }

        private function getCharacterExp(_arg_1:int):int
        {
            if (this.hasMapPlayer())
            {
                return (this.hudModel.gameSprite.map.player_.exp_);
            }
            return (this.getSavedCharacter(_arg_1).xp());
        }

        private function getCharacterLevel(_arg_1:int):int
        {
            if (this.hasMapPlayer())
            {
                return (this.hudModel.gameSprite.map.player_.level_);
            }
            return (this.getSavedCharacter(_arg_1).level());
        }

        private function getCharacterType(_arg_1:int):int
        {
            if (this.hasMapPlayer())
            {
                return (this.hudModel.gameSprite.map.player_.objectType_);
            }
            return (this.getSavedCharacter(_arg_1).objectType());
        }

        private function getCharacterFameBonus(_arg_1:int):int
        {
            if (this.hasMapPlayer())
            {
                return (this.hudModel.gameSprite.map.player_.getFameBonus());
            }
            return (this.getSavedCharacter(_arg_1).fameBonus());
        }

        public function currentFame(_arg_1:int):int
        {
            var _local_2:int = this.metrics.getCharacterStat(_arg_1, MetricsID.MINUTES_ACTIVE);
            var _local_3:int = this.getCharacterExp(_arg_1);
            var _local_4:int = this.getCharacterLevel(_arg_1);
            if (this.hasMapPlayer())
            {
                _local_3 = (_local_3 + (((_local_4 - 1) * (_local_4 - 1)) * 50));
            }
            return (this.calculateBaseFame(_local_3, _local_2));
        }

        public function calculateBaseFame(_arg_1:int, _arg_2:int):int
        {
            var _local_3:Number = 0;
            _local_3 = (_local_3 + (Math.max(0, Math.min(20000, _arg_1)) * 0.001));
            _local_3 = (_local_3 + (Math.max(0, (Math.min(45200, _arg_1) - 20000)) * 0.002));
            _local_3 = (_local_3 + (Math.max(0, (Math.min(80000, _arg_1) - 45200)) * 0.003));
            _local_3 = (_local_3 + (Math.max(0, (Math.min(101200, _arg_1) - 80000)) * 0.002));
            _local_3 = (_local_3 + (Math.max(0, (_arg_1 - 101200)) * 0.0005));
            _local_3 = (_local_3 + Math.min(Math.floor((_arg_2 / 6)), 30));
            return (Math.floor(_local_3));
        }


    }
}//package io.decagames.rotmg.fame.data

