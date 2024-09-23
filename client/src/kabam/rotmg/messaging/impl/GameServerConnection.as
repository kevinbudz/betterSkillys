package kabam.rotmg.messaging.impl
{
import by.blooddy.crypto.MD5;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.game.events.GuildResultEvent;
import com.company.assembleegameclient.game.events.NameResultEvent;
import com.company.assembleegameclient.game.events.ReconnectEvent;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.map.mapoverlay.CharacterStatusText;
import com.company.assembleegameclient.objects.Container;
import com.company.assembleegameclient.objects.FlashDescription;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.Merchant;
import com.company.assembleegameclient.objects.NameChanger;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.Portal;
import com.company.assembleegameclient.objects.Projectile;
import com.company.assembleegameclient.objects.SellableObject;
import com.company.assembleegameclient.objects.particles.AOEEffect;
import com.company.assembleegameclient.objects.particles.BurstEffect;
import com.company.assembleegameclient.objects.particles.CollapseEffect;
import com.company.assembleegameclient.objects.particles.ConeBlastEffect;
import com.company.assembleegameclient.objects.particles.FlowEffect;
import com.company.assembleegameclient.objects.particles.HealEffect;
import com.company.assembleegameclient.objects.particles.InspireEffect;
import com.company.assembleegameclient.objects.particles.LightningEffect;
import com.company.assembleegameclient.objects.particles.LineEffect;
import com.company.assembleegameclient.objects.particles.NovaEffect;
import com.company.assembleegameclient.objects.particles.ParticleEffect;
import com.company.assembleegameclient.objects.particles.PoisonEffect;
import com.company.assembleegameclient.objects.particles.RingEffect;
import com.company.assembleegameclient.objects.particles.SpritesProjectEffect;
import com.company.assembleegameclient.objects.particles.StreamEffect;
import com.company.assembleegameclient.objects.particles.TeleportEffect;
import com.company.assembleegameclient.objects.particles.ThrowEffect;
import com.company.assembleegameclient.objects.thrown.ThrowProjectileEffect;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.sound.Music;
import com.company.assembleegameclient.sound.SoundEffectLibrary;
import com.company.assembleegameclient.ui.PicView;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.assembleegameclient.ui.panels.GuildInvitePanel;
import com.company.assembleegameclient.ui.panels.PartyInvitePanel;
import com.company.assembleegameclient.ui.panels.TradeRequestPanel;
import com.company.assembleegameclient.util.ConditionEffect;
import com.company.assembleegameclient.util.FreeList;
import com.company.assembleegameclient.util.TimeUtil;
import com.company.util.MoreStringUtil;
import com.company.util.Random;
import com.hurlant.crypto.Crypto;
import com.hurlant.crypto.rsa.RSAKey;
import com.hurlant.crypto.symmetric.ICipher;
import com.hurlant.util.Base64;
import com.hurlant.util.der.PEM;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.net.FileReference;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.getTimer;

import io.decagames.rotmg.ui.popups.signals.ShowPopupSignal;

import kabam.lib.json.JsonParser;

import kabam.lib.net.api.MessageMap;
import kabam.lib.net.api.MessageProvider;
import kabam.lib.net.impl.Message;
import kabam.lib.net.impl.SocketServer;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.arena.control.ImminentArenaWaveSignal;
import kabam.rotmg.arena.model.CurrentArenaRunModel;
import kabam.rotmg.classes.model.CharacterClass;
import kabam.rotmg.classes.model.ClassesModel;
import kabam.rotmg.constants.GeneralConstants;
import kabam.rotmg.constants.ItemConstants;
import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.death.control.HandleDeathSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.game.focus.control.SetGameFocusSignal;
import kabam.rotmg.game.model.AddSpeechBalloonVO;
import kabam.rotmg.game.model.AddTextLineVO;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.model.PotionInventoryModel;
import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.game.view.components.QueuedStatusText;
import kabam.rotmg.maploading.signals.HideMapLoadingSignal;
import kabam.rotmg.market.signals.MemMarketAddSignal;
import kabam.rotmg.market.signals.MemMarketBuySignal;
import kabam.rotmg.market.signals.MemMarketMyOffersSignal;
import kabam.rotmg.market.signals.MemMarketRemoveSignal;
import kabam.rotmg.market.signals.MemMarketSearchSignal;
import kabam.rotmg.messaging.impl.data.GroundTileData;
import kabam.rotmg.messaging.impl.data.ObjectData;
import kabam.rotmg.messaging.impl.data.ObjectStatusData;
import kabam.rotmg.messaging.impl.data.StatData;
import kabam.rotmg.messaging.impl.incoming.AccountList;
import kabam.rotmg.messaging.impl.incoming.AllyShoot;
import kabam.rotmg.messaging.impl.incoming.Aoe;
import kabam.rotmg.messaging.impl.incoming.BuyResult;
import kabam.rotmg.messaging.impl.incoming.ClientStat;
import kabam.rotmg.messaging.impl.incoming.CreateSuccess;
import kabam.rotmg.messaging.impl.incoming.Damage;
import kabam.rotmg.messaging.impl.incoming.Death;
import kabam.rotmg.messaging.impl.incoming.EnemyShoot;
import kabam.rotmg.messaging.impl.incoming.Failure;
import kabam.rotmg.messaging.impl.incoming.File;
import kabam.rotmg.messaging.impl.incoming.GlobalNotification;
import kabam.rotmg.messaging.impl.incoming.Goto;
import kabam.rotmg.messaging.impl.incoming.GuildResult;
import kabam.rotmg.messaging.impl.incoming.ImminentArenaWave;
import kabam.rotmg.messaging.impl.incoming.InvResult;
import kabam.rotmg.messaging.impl.incoming.InvitedToGuild;
import kabam.rotmg.messaging.impl.incoming.MapInfo;
import kabam.rotmg.messaging.impl.incoming.NameResult;
import kabam.rotmg.messaging.impl.incoming.NewTick;
import kabam.rotmg.messaging.impl.incoming.Notification;
import kabam.rotmg.messaging.impl.incoming.Pic;
import kabam.rotmg.messaging.impl.incoming.Ping;
import kabam.rotmg.messaging.impl.incoming.PlaySound;
import kabam.rotmg.messaging.impl.incoming.QuestObjId;
import kabam.rotmg.messaging.impl.incoming.Reconnect;
import kabam.rotmg.messaging.impl.incoming.ServerPlayerShoot;
import kabam.rotmg.messaging.impl.incoming.ShowEffect;
import kabam.rotmg.messaging.impl.incoming.SwitchMusic;
import kabam.rotmg.messaging.impl.incoming.Text;
import kabam.rotmg.messaging.impl.incoming.TradeAccepted;
import kabam.rotmg.messaging.impl.incoming.TradeChanged;
import kabam.rotmg.messaging.impl.incoming.TradeDone;
import kabam.rotmg.messaging.impl.incoming.TradeRequested;
import kabam.rotmg.messaging.impl.incoming.TradeStart;
import kabam.rotmg.messaging.impl.incoming.Update;
import kabam.rotmg.messaging.impl.incoming.bounty.BountyMemberListSend;
import kabam.rotmg.messaging.impl.incoming.market.MarketAddResult;
import kabam.rotmg.messaging.impl.incoming.market.MarketBuyResult;
import kabam.rotmg.messaging.impl.incoming.market.MarketMyOffersResult;
import kabam.rotmg.messaging.impl.incoming.market.MarketRemoveResult;
import kabam.rotmg.messaging.impl.incoming.market.MarketSearchResult;
import kabam.rotmg.messaging.impl.incoming.party.InvitedToParty;
import kabam.rotmg.messaging.impl.outgoing.AcceptTrade;
import kabam.rotmg.messaging.impl.outgoing.AoeAck;
import kabam.rotmg.messaging.impl.outgoing.Buy;
import kabam.rotmg.messaging.impl.outgoing.CancelTrade;
import kabam.rotmg.messaging.impl.outgoing.ChangeGuildRank;
import kabam.rotmg.messaging.impl.outgoing.ChangeTrade;
import kabam.rotmg.messaging.impl.outgoing.ChooseName;
import kabam.rotmg.messaging.impl.outgoing.Create;
import kabam.rotmg.messaging.impl.outgoing.CreateGuild;
import kabam.rotmg.messaging.impl.outgoing.EditAccountList;
import kabam.rotmg.messaging.impl.outgoing.EnemyHit;
import kabam.rotmg.messaging.impl.outgoing.Escape;
import kabam.rotmg.messaging.impl.outgoing.GotoAck;
import kabam.rotmg.messaging.impl.outgoing.GroundDamage;
import kabam.rotmg.messaging.impl.outgoing.GuildInvite;
import kabam.rotmg.messaging.impl.outgoing.GuildRemove;
import kabam.rotmg.messaging.impl.outgoing.Hello;
import kabam.rotmg.messaging.impl.outgoing.InvDrop;
import kabam.rotmg.messaging.impl.outgoing.InvSwap;
import kabam.rotmg.messaging.impl.outgoing.JoinGuild;
import kabam.rotmg.messaging.impl.outgoing.Load;
import kabam.rotmg.messaging.impl.outgoing.Move;
import kabam.rotmg.messaging.impl.outgoing.OtherHit;
import kabam.rotmg.messaging.impl.outgoing.PlayerHit;
import kabam.rotmg.messaging.impl.outgoing.PlayerShoot;
import kabam.rotmg.messaging.impl.outgoing.PlayerText;
import kabam.rotmg.messaging.impl.outgoing.Pong;
import kabam.rotmg.messaging.impl.outgoing.PotionStorageInteraction;
import kabam.rotmg.messaging.impl.outgoing.RequestTrade;
import kabam.rotmg.messaging.impl.outgoing.BreakdownSlot;
import kabam.rotmg.messaging.impl.outgoing.ShootAck;
import kabam.rotmg.messaging.impl.outgoing.Reskin;
import kabam.rotmg.messaging.impl.outgoing.SquareHit;
import kabam.rotmg.messaging.impl.outgoing.Teleport;
import kabam.rotmg.messaging.impl.outgoing.UpgradeStat;
import kabam.rotmg.messaging.impl.outgoing.UseItem;
import kabam.rotmg.messaging.impl.outgoing.UsePortal;
import kabam.rotmg.messaging.impl.outgoing.UsePotion;
import kabam.rotmg.messaging.impl.outgoing.bounty.BountyMemberListRequest;
import kabam.rotmg.messaging.impl.outgoing.bounty.BountyRequest;
import kabam.rotmg.messaging.impl.outgoing.market.MarketAdd;
import kabam.rotmg.messaging.impl.outgoing.market.MarketBuy;
import kabam.rotmg.messaging.impl.outgoing.market.MarketMyOffers;
import kabam.rotmg.messaging.impl.outgoing.market.MarketRemove;
import kabam.rotmg.messaging.impl.outgoing.market.MarketSearch;
import kabam.rotmg.messaging.impl.outgoing.party.JoinParty;
import kabam.rotmg.messaging.impl.outgoing.party.PartyInvite;
import kabam.rotmg.minimap.control.UpdateGameObjectTileSignal;
import kabam.rotmg.minimap.control.UpdateGroundTileSignal;
import kabam.rotmg.minimap.model.UpdateGroundTileVO;
import kabam.rotmg.servers.api.Server;
import kabam.rotmg.ui.model.Key;
import kabam.rotmg.ui.model.UpdateGameObjectTileVO;
import kabam.rotmg.ui.signals.LegendaryPopUpSignal;
import kabam.rotmg.ui.signals.MythicalPopUpSignal;
import kabam.rotmg.ui.signals.ShowKeySignal;
import kabam.rotmg.ui.signals.ShowKeyUISignal;
import kabam.rotmg.ui.signals.UpdateBackpackTabSignal;
import kabam.rotmg.ui.view.FlexibleDialog;

import org.swiftsuspenders.Injector;

import robotlegs.bender.framework.api.ILogger;

import kabam.rotmg.game.model.PotionInventoryModel;

public class GameServerConnection
   {

      public static const FAILURE:int = 0;
      public static const CREATE_SUCCESS:int = 1;
      public static const CREATE:int = 2;
      public static const PLAYERSHOOT:int = 3;
      public static const MOVE:int = 4;
      public static const PLAYERTEXT:int = 5;
      public static const TEXT:int = 6;
      public static const SERVERPLAYERSHOOT:int = 7;
      public static const DAMAGE:int = 8;
      public static const UPDATE:int = 9;
      public static const UPDATEACK:int = 10;
      public static const NOTIFICATION:int = 11;
      public static const NEWTICK:int = 12;
      public static const INVSWAP:int = 13;
      public static const USEITEM:int = 14;
      public static const SHOWEFFECT:int = 15;
      public static const HELLO:int = 16;
      public static const GOTO:int = 17;
      public static const INVDROP:int = 18;
      public static const INVRESULT:int = 19;
      public static const RECONNECT:int = 20;
      public static const PING:int = 21;
      public static const PONG:int = 22;
      public static const MAPINFO:int = 23;
      public static const LOAD:int = 24;
      public static const PIC:int = 25;
      public static const TELEPORT:int = 27;
      public static const USEPORTAL:int = 28;
      public static const DEATH:int = 29;
      public static const BUY:int = 30;
      public static const BUYRESULT:int = 31;
      public static const AOE:int = 32;
      public static const GROUNDDAMAGE:int = 33;
      public static const PLAYERHIT:int = 34;
      public static const ENEMYHIT:int = 35;
      public static const AOEACK:int = 36;
      public static const SHOOTACK:int = 37;
      public static const OTHERHIT:int = 38;
      public static const SQUAREHIT:int = 39;
      public static const GOTOACK:int = 40;
      public static const EDITACCOUNTLIST:int = 41;
      public static const ACCOUNTLIST:int = 42;
      public static const QUESTOBJID:int = 43;
      public static const CHOOSENAME:int = 44;
      public static const NAMERESULT:int = 45;
      public static const CREATEGUILD:int = 46;
      public static const GUILDRESULT:int = 47;
      public static const GUILDREMOVE:int = 48;
      public static const GUILDINVITE:int = 49;
      public static const ALLYSHOOT:int = 50;
      public static const ENEMYSHOOT:int = 51;
      public static const REQUESTTRADE:int = 52;
      public static const TRADEREQUESTED:int = 53;
      public static const TRADESTART:int = 54;
      public static const CHANGETRADE:int = 55;
      public static const TRADECHANGED:int = 56;
      public static const ACCEPTTRADE:int = 57;
      public static const CANCELTRADE:int = 58;
      public static const TRADEDONE:int = 59;
      public static const TRADEACCEPTED:int = 60;
      public static const CLIENTSTAT:int = 61;
      public static const ESCAPE:int = 63;
      public static const FILE:int = 64;
      public static const INVITEDTOGUILD:int = 65;
      public static const JOINGUILD:int = 66;
      public static const CHANGEGUILDRANK:int = 67;
      public static const PLAYSOUND:int = 68;
      public static const GLOBAL_NOTIFICATION:int = 69;
      public static const RESKIN:int = 70;
      public static const PARTY_INVITE:int = 71;
      public static const INVITED_TO_PARTY:int = 72;
      public static const JOIN_PARTY:int = 73;
      public static const USE_STORAGE:int = 74;
      public static const SWITCH_MUSIC:int = 75;
      public static const MARKET_SEARCH:int = 76;
      public static const MARKET_SEARCH_RESULT:int = 77;
      public static const MARKET_BUY:int = 78;
      public static const MARKET_BUY_RESULT:int = 79;
      public static const MARKET_ADD:int = 80;
      public static const MARKET_ADD_RESULT:int = 81;
      public static const MARKET_REMOVE:int = 82;
      public static const MARKET_REMOVE_RESULT:int = 83;
      public static const MARKET_MY_OFFERS:int = 84;
      public static const MARKET_MY_OFFERS_RESULT:int = 85;
      public static const BREAKDOWN_SLOT:int = 86;
      public static const IMMINENT_ARENA_WAVE:int = 87;

      private static const TO_MILLISECONDS:int = 1000;

      public static var instance:GameServerConnection;

      private static const NORMAL_SPEECH_COLORS:Vector.<uint> = new <uint>[14802908,16777215,5526612];
      private static const ENEMY_SPEECH_COLORS:Vector.<uint> = new <uint>[5644060,16549442,13484223];
      private static const TELL_SPEECH_COLORS:Vector.<uint> = new <uint>[2493110,61695,13880567];
      private static const GUILD_SPEECH_COLORS:Vector.<uint> = new <uint>[4098560,10944349,13891532]; //first = background, second: outline, third: word color
      private static const PARTY_SPEECH_COLORS:Vector.<uint> = new <uint>[0x78a0ff,0x5a7dd1,0xd9e4ff];// "#FFA2A2"; "#FFC0C0"; "#FFEEEE";

      public var gs_:GameSprite;
      public var server_:Server;
      public var gameId_:int;
      public var createCharacter_:Boolean;
      public var charId_:int;
      public var keyTime_:int;
      public var key_:ByteArray;
      public var mapJSON_:String;
      public var lastTickId_:int = -1;
      public var jitterWatcher_:JitterWatcher = null;
      public var serverConnection:SocketServer;
      private var messages:MessageProvider;
      private var playerId_:int = -1;
      private var player:Player;
      private var retryConnection_:Boolean = true;
      public var outstandingBuy_:OutstandingBuy = null;
      private var rand_:Random = null;
      private var death:Death;
      private var retryTimer_:Timer;
      private var delayBeforeReconect:int = 1;
      private var addTextLine:AddTextLineSignal;
      private var addSpeechBalloon:AddSpeechBalloonSignal;
      private var updateGroundTileSignal:UpdateGroundTileSignal;
      private var updateGameObjectTileSignal:UpdateGameObjectTileSignal;
      private var logger:ILogger;
      private var handleDeath:HandleDeathSignal;
      private var setGameFocus:SetGameFocusSignal;
      private var updateBackpackTab:UpdateBackpackTabSignal;
      private var classesModel:ClassesModel;
      private var playerModel:PlayerModel;
      private var injector:Injector;
      private var model:GameModel;
      private var showPopupSignal:ShowPopupSignal;

      public function GameServerConnection(gs:GameSprite, server:Server, gameId:int, createCharacter:Boolean, charId:int, keyTime:int, key:ByteArray, mapJSON:String)
      {
         this.injector = StaticInjectorContext.getInjector();
         this.addTextLine = this.injector.getInstance(AddTextLineSignal);
         this.addSpeechBalloon = this.injector.getInstance(AddSpeechBalloonSignal);
         this.updateGroundTileSignal = this.injector.getInstance(UpdateGroundTileSignal);
         this.updateGameObjectTileSignal = this.injector.getInstance(UpdateGameObjectTileSignal);
         this.updateBackpackTab = StaticInjectorContext.getInjector().getInstance(UpdateBackpackTabSignal);
         this.logger = this.injector.getInstance(ILogger);
         this.showPopupSignal = this.injector.getInstance(ShowPopupSignal);
         this.handleDeath = this.injector.getInstance(HandleDeathSignal);
         this.setGameFocus = this.injector.getInstance(SetGameFocusSignal);
         this.classesModel = this.injector.getInstance(ClassesModel);
         this.serverConnection = this.injector.getInstance(SocketServer);
         this.messages = this.injector.getInstance(MessageProvider);
         this.model = this.injector.getInstance(GameModel);
         this.playerModel = this.injector.getInstance(PlayerModel);
         instance = this;
         this.gs_ = gs;
         this.server_ = server;
         this.gameId_ = gameId;
         this.createCharacter_ = createCharacter;
         this.charId_ = charId;
         this.keyTime_ = keyTime;
         this.key_ = key;
         this.mapJSON_ = mapJSON;
      }

      public function disconnect() : void
      {
         this.removeServerConnectionListeners();
         this.unmapMessages();
         this.serverConnection.disconnect();
      }

      private function removeServerConnectionListeners() : void
      {
         this.serverConnection.connected.remove(this.onConnected);
         this.serverConnection.closed.remove(this.onClosed);
         this.serverConnection.error.remove(this.onError);
      }

      public function connect() : void
      {
         this.addServerConnectionListeners();
         this.mapMessages();

         if(!isServerDefined()){
            this.gs_.closed.dispatch();
            return;
         }

         this.addTextLine.dispatch(new AddTextLineVO(Parameters.CLIENT_CHAT_NAME,"Connecting to " + this.server_.name));
         this.serverConnection.connect(this.server_.address,this.server_.port);
      }

      private function isServerDefined() : Boolean
      {
         var isDefined:Boolean = this.server_ != null;
         isDefined || this.logger.fatal("Unable to connect - no valid server found");
         return isDefined;
      }

      private function addServerConnectionListeners() : void
      {
         this.serverConnection.connected.add(this.onConnected);
         this.serverConnection.closed.add(this.onClosed);
         this.serverConnection.error.add(this.onError);
      }

      private function mapMessages() : void
      {
         var messages:MessageMap = this.injector.getInstance(MessageMap);
         messages.map(CREATE).toMessage(Create);
         messages.map(PLAYERSHOOT).toMessage(PlayerShoot);
         messages.map(MOVE).toMessage(Move);
         messages.map(PLAYERTEXT).toMessage(PlayerText);
         messages.map(UPDATEACK).toMessage(Message);
         messages.map(INVSWAP).toMessage(InvSwap);
         messages.map(USEITEM).toMessage(UseItem);
         messages.map(HELLO).toMessage(Hello);
         messages.map(INVDROP).toMessage(InvDrop);
         messages.map(PONG).toMessage(Pong);
         messages.map(LOAD).toMessage(Load);
         messages.map(TELEPORT).toMessage(Teleport);
         messages.map(USEPORTAL).toMessage(UsePortal);
         messages.map(BUY).toMessage(Buy);
         messages.map(PLAYERHIT).toMessage(PlayerHit);
         messages.map(ENEMYHIT).toMessage(EnemyHit);
         messages.map(OTHERHIT).toMessage(OtherHit);
         messages.map(SQUAREHIT).toMessage(SquareHit);
         messages.map(GOTOACK).toMessage(GotoAck);
         messages.map(GROUNDDAMAGE).toMessage(GroundDamage);
         messages.map(CHOOSENAME).toMessage(ChooseName);
         messages.map(CREATEGUILD).toMessage(CreateGuild);
         messages.map(GUILDREMOVE).toMessage(GuildRemove);
         messages.map(GUILDINVITE).toMessage(GuildInvite);
         messages.map(REQUESTTRADE).toMessage(RequestTrade);
         messages.map(CHANGETRADE).toMessage(ChangeTrade);
         messages.map(ACCEPTTRADE).toMessage(AcceptTrade);
         messages.map(CANCELTRADE).toMessage(CancelTrade);
         messages.map(JOINGUILD).toMessage(JoinGuild);
         messages.map(CHANGEGUILDRANK).toMessage(ChangeGuildRank);
         messages.map(EDITACCOUNTLIST).toMessage(EditAccountList);
         messages.map(ESCAPE).toMessage(Escape);
         messages.map(PARTY_INVITE).toMessage(PartyInvite);
         messages.map(INVITED_TO_PARTY).toMessage(InvitedToParty).toMethod(this.onInvitedToParty);
         messages.map(JOIN_PARTY).toMessage(JoinParty);
         messages.map(FAILURE).toMessage(Failure).toMethod(this.onFailure);
         messages.map(CREATE_SUCCESS).toMessage(CreateSuccess).toMethod(this.onCreateSuccess);
         messages.map(TEXT).toMessage(Text).toMethod(this.onText);
         messages.map(SERVERPLAYERSHOOT).toMessage(ServerPlayerShoot).toMethod(this.onServerPlayerShoot);
         messages.map(DAMAGE).toMessage(Damage).toMethod(this.onDamage);
         messages.map(UPDATE).toMessage(Update).toMethod(this.onUpdate);
         messages.map(NOTIFICATION).toMessage(Notification).toMethod(this.onNotification);
         messages.map(GLOBAL_NOTIFICATION).toMessage(GlobalNotification).toMethod(this.onGlobalNotification);
         messages.map(NEWTICK).toMessage(NewTick).toMethod(this.onNewTick);
         messages.map(SHOWEFFECT).toMessage(ShowEffect).toMethod(this.onShowEffect);
         messages.map(GOTO).toMessage(Goto).toMethod(this.onGoto);
         messages.map(INVRESULT).toMessage(InvResult).toMethod(this.onInvResult);
         messages.map(RECONNECT).toMessage(Reconnect).toMethod(this.onReconnect);
         messages.map(PING).toMessage(Ping).toMethod(this.onPing);
         messages.map(MAPINFO).toMessage(MapInfo).toMethod(this.onMapInfo);
         messages.map(PIC).toMessage(Pic).toMethod(this.onPic);
         messages.map(DEATH).toMessage(Death).toMethod(this.onDeath);
         messages.map(BUYRESULT).toMessage(BuyResult).toMethod(this.onBuyResult);
         messages.map(AOE).toMessage(Aoe).toMethod(this.onAoe);
         messages.map(ACCOUNTLIST).toMessage(AccountList).toMethod(this.onAccountList);
         messages.map(QUESTOBJID).toMessage(QuestObjId).toMethod(this.onQuestObjId);
         messages.map(NAMERESULT).toMessage(NameResult).toMethod(this.onNameResult);
         messages.map(GUILDRESULT).toMessage(GuildResult).toMethod(this.onGuildResult);
         messages.map(ALLYSHOOT).toMessage(AllyShoot).toMethod(this.onAllyShoot);
         messages.map(ENEMYSHOOT).toMessage(EnemyShoot).toMethod(this.onEnemyShoot);
         messages.map(TRADEREQUESTED).toMessage(TradeRequested).toMethod(this.onTradeRequested);
         messages.map(TRADESTART).toMessage(TradeStart).toMethod(this.onTradeStart);
         messages.map(TRADECHANGED).toMessage(TradeChanged).toMethod(this.onTradeChanged);
         messages.map(TRADEDONE).toMessage(TradeDone).toMethod(this.onTradeDone);
         messages.map(TRADEACCEPTED).toMessage(TradeAccepted).toMethod(this.onTradeAccepted);
         messages.map(CLIENTSTAT).toMessage(ClientStat).toMethod(this.onClientStat);
         messages.map(FILE).toMessage(File).toMethod(this.onFile);
         messages.map(INVITEDTOGUILD).toMessage(InvitedToGuild).toMethod(this.onInvitedToGuild);
         messages.map(SWITCH_MUSIC).toMessage(SwitchMusic).toMethod(this.onSwitchMusic);
         messages.map(PLAYSOUND).toMessage(PlaySound).toMethod(this.onPlaySound);
         messages.map(MARKET_SEARCH).toMessage(MarketSearch);
         messages.map(MARKET_SEARCH_RESULT).toMessage(MarketSearchResult).toMethod(this.onMarketSearchResult);
         messages.map(MARKET_BUY).toMessage(MarketBuy);
         messages.map(MARKET_BUY_RESULT).toMessage(MarketBuyResult).toMethod(this.onMarketBuyResult);
         messages.map(MARKET_ADD).toMessage(MarketAdd);
         messages.map(MARKET_ADD_RESULT).toMessage(MarketAddResult).toMethod(this.onMarketAddResult);
         messages.map(MARKET_REMOVE).toMessage(MarketRemove);
         messages.map(MARKET_REMOVE_RESULT).toMessage(MarketRemoveResult).toMethod(this.onMarketRemoveResult);
         messages.map(MARKET_MY_OFFERS).toMessage(MarketMyOffers);
         messages.map(MARKET_MY_OFFERS_RESULT).toMessage(MarketMyOffersResult).toMethod(this.onMarketMyOffersResult);
         messages.map(USE_STORAGE).toMessage(PotionStorageInteraction);
         messages.map(AOEACK).toMessage(AoeAck);
         messages.map(SHOOTACK).toMessage(ShootAck);
         messages.map(BREAKDOWN_SLOT).toMessage(BreakdownSlot);
         messages.map(IMMINENT_ARENA_WAVE).toMessage(ImminentArenaWave).toMethod(this.onImminentArenaWave);
      }

      private function unmapMessages() : void {
         var messages:MessageMap = this.injector.getInstance(MessageMap);
         messages.unmap(CREATE);
         messages.unmap(PLAYERSHOOT);
         messages.unmap(MOVE);
         messages.unmap(PLAYERTEXT);
         messages.unmap(UPDATEACK);
         messages.unmap(INVSWAP);
         messages.unmap(USEITEM);
         messages.unmap(HELLO);
         messages.unmap(INVDROP);
         messages.unmap(PONG);
         messages.unmap(LOAD);
         messages.unmap(TELEPORT);
         messages.unmap(USEPORTAL);
         messages.unmap(BUY);
         messages.unmap(PLAYERHIT);
         messages.unmap(ENEMYHIT);
         messages.unmap(OTHERHIT);
         messages.unmap(SQUAREHIT);
         messages.unmap(GOTOACK);
         messages.unmap(GROUNDDAMAGE);
         messages.unmap(CHOOSENAME);
         messages.unmap(CREATEGUILD);
         messages.unmap(GUILDREMOVE);
         messages.unmap(GUILDINVITE);
         messages.unmap(REQUESTTRADE);
         messages.unmap(CHANGETRADE);
         messages.unmap(ACCEPTTRADE);
         messages.unmap(CANCELTRADE);
         messages.unmap(JOINGUILD);
         messages.unmap(CHANGEGUILDRANK);
         messages.unmap(EDITACCOUNTLIST);
         messages.unmap(FAILURE);
         messages.unmap(CREATE_SUCCESS);
         messages.unmap(TEXT);
         messages.unmap(SERVERPLAYERSHOOT);
         messages.unmap(DAMAGE);
         messages.unmap(UPDATE);
         messages.unmap(NOTIFICATION);
         messages.unmap(GLOBAL_NOTIFICATION);
         messages.unmap(NEWTICK);
         messages.unmap(SHOWEFFECT);
         messages.unmap(GOTO);
         messages.unmap(INVRESULT);
         messages.unmap(RECONNECT);
         messages.unmap(PING);
         messages.unmap(MAPINFO);
         messages.unmap(PIC);
         messages.unmap(DEATH);
         messages.unmap(BUYRESULT);
         messages.unmap(AOE);
         messages.unmap(ACCOUNTLIST);
         messages.unmap(QUESTOBJID);
         messages.unmap(NAMERESULT);
         messages.unmap(GUILDRESULT);
         messages.unmap(ALLYSHOOT);
         messages.unmap(ENEMYSHOOT);
         messages.unmap(TRADEREQUESTED);
         messages.unmap(TRADESTART);
         messages.unmap(TRADECHANGED);
         messages.unmap(TRADEDONE);
         messages.unmap(TRADEACCEPTED);
         messages.unmap(CLIENTSTAT);
         messages.unmap(FILE);
         messages.unmap(INVITEDTOGUILD);
         messages.unmap(PLAYSOUND);
         messages.unmap(ESCAPE);
         messages.unmap(AOEACK);
         messages.unmap(SHOOTACK);
         messages.unmap(MARKET_SEARCH);
         messages.unmap(MARKET_SEARCH_RESULT);
         messages.unmap(MARKET_BUY);
         messages.unmap(MARKET_BUY_RESULT);
         messages.unmap(MARKET_ADD);
         messages.unmap(MARKET_ADD_RESULT);
         messages.unmap(MARKET_REMOVE);
         messages.unmap(MARKET_REMOVE_RESULT);
         messages.unmap(MARKET_MY_OFFERS);
         messages.unmap(MARKET_MY_OFFERS_RESULT);
         messages.unmap(PARTY_INVITE);
         messages.unmap(INVITED_TO_PARTY);
         messages.unmap(JOIN_PARTY);
         messages.unmap(USE_STORAGE);
         messages.unmap(SWITCH_MUSIC);
         messages.unmap(BREAKDOWN_SLOT);
         messages.unmap(IMMINENT_ARENA_WAVE);
      }

      private function onSwitchMusic(sm:SwitchMusic):void {
         Music.load(sm.music);
      }

      private function onImminentArenaWave(_arg1:ImminentArenaWave):void {
         this.gs_.arenaMenu.onWaveInfo(_arg1.currentRuntime, _arg1.wave, _arg1.currentState);
      }

      public function getNextDamage(minDamage:uint, maxDamage:uint) : uint
      {
         return this.rand_.nextIntRange(minDamage,maxDamage);
      }

      public function enableJitterWatcher() : void
      {
         if(this.jitterWatcher_ == null)
         {
            this.jitterWatcher_ = new JitterWatcher();
         }
      }

      public function disableJitterWatcher() : void
      {
         if(this.jitterWatcher_ != null)
         {
            this.jitterWatcher_ = null;
         }
      }

      private function create() : void
      {
         var charClass:CharacterClass = this.classesModel.getSelected();
         var create:Create = this.messages.require(CREATE) as Create;
         create.classType = charClass.id;
         create.skinType = charClass.skins.getSelectedSkin().id;
         this.serverConnection.sendMessage(create);
      }

      private function load() : void
      {
         var load:Load = this.messages.require(LOAD) as Load;
         load.charId_ = this.charId_;
         this.serverConnection.sendMessage(load);
      }

      public function playerShoot(time:int, proj:Projectile) : void
      {
         var playerShoot:PlayerShoot = this.messages.require(PLAYERSHOOT) as PlayerShoot;
         playerShoot.time_ = time;
         playerShoot.bulletId_ = proj.bulletId_;
         playerShoot.containerType_ = proj.containerType_;
         playerShoot.startingPos_.x_ = proj.x_;
         playerShoot.startingPos_.y_ = proj.y_;
         playerShoot.angle_ = proj.angle_;
         this.serverConnection.sendMessage(playerShoot);
      }

      public function playerHit(bulletId:int, objectId:int) : void
      {
         var playerHit:PlayerHit = this.messages.require(PLAYERHIT) as PlayerHit;
         playerHit.bulletId_ = bulletId;
         playerHit.objectId_ = objectId;
         this.serverConnection.sendMessage(playerHit);
      }

      public function enemyHit(time:int, bulletId:int, targetId:int, kill:Boolean) : void
      {
         var enemyHit:EnemyHit = this.messages.require(ENEMYHIT) as EnemyHit;
         enemyHit.time_ = time;
         enemyHit.bulletId_ = bulletId;
         enemyHit.targetId_ = targetId;
         enemyHit.kill_ = kill;
         this.serverConnection.sendMessage(enemyHit);
      }

      public function otherHit(time:int, bulletId:int, objectId:int, targetId:int) : void
      {
         var otherHit:OtherHit = this.messages.require(OTHERHIT) as OtherHit;
         otherHit.time_ = time;
         otherHit.bulletId_ = bulletId;
         otherHit.objectId_ = objectId;
         otherHit.targetId_ = targetId;
         this.serverConnection.sendMessage(otherHit);
      }

      public function squareHit(time:int, bulletId:int, objectId:int) : void
      {
         var squareHit:SquareHit = this.messages.require(SQUAREHIT) as SquareHit;
         squareHit.time_ = time;
         squareHit.bulletId_ = bulletId;
         squareHit.objectId_ = objectId;
         this.serverConnection.sendMessage(squareHit);
      }

      public function aoeAck(time:int, x:Number, y:Number) : void
      {
         var aoeAck:AoeAck = this.messages.require(AOEACK) as AoeAck;
         aoeAck.time_ = time;
         aoeAck.position_.x_ = x;
         aoeAck.position_.y_ = y;
         this.serverConnection.sendMessage(aoeAck);
      }

      public function groundDamage(time:int, x:Number, y:Number) : void
      {
         var groundDamage:GroundDamage = this.messages.require(GROUNDDAMAGE) as GroundDamage;
         groundDamage.time_ = time;
         groundDamage.position_.x_ = x;
         groundDamage.position_.y_ = y;
         this.serverConnection.sendMessage(groundDamage);
      }

      public function shootAck(time:int) : void
      {
         var shootAck:ShootAck = this.messages.require(SHOOTACK) as ShootAck;
         shootAck.time_ = time;
         this.serverConnection.sendMessage(shootAck);
      }

      public function breakdownSlot(slot:int, objectId:int) : void
      {
         var breakdownSlot:BreakdownSlot = this.messages.require(BREAKDOWN_SLOT) as BreakdownSlot;
         breakdownSlot.time_ = gs_.lastUpdate_;
         breakdownSlot.slot_ = slot;
         breakdownSlot.objectId_ = objectId;
         this.serverConnection.sendMessage(breakdownSlot);
      }

      public function playerText(textStr:String) : void
      {
         var playerTextMessage:PlayerText = this.messages.require(PLAYERTEXT) as PlayerText;
         playerTextMessage.text_ = textStr;
         this.serverConnection.sendMessage(playerTextMessage);
      }

      public function invSwap(player:Player, sourceObj:GameObject, slotId1:int, itemId:int, targetObj:GameObject, slotId2:int, objectType2:int) : Boolean
      {
         if(!this.gs_)
         {
            return false;
         }
         var invSwap:InvSwap = this.messages.require(INVSWAP) as InvSwap;
         invSwap.time_ = this.gs_.lastUpdate_;
         invSwap.position_.x_ = player.x_;
         invSwap.position_.y_ = player.y_;
         invSwap.slotObject1_.objectId_ = sourceObj.objectId_;
         invSwap.slotObject1_.slotId_ = slotId1;
         invSwap.slotObject1_.objectType_ = itemId;
         invSwap.slotObject2_.objectId_ = targetObj.objectId_;
         invSwap.slotObject2_.slotId_ = slotId2;
         invSwap.slotObject2_.objectType_ = objectType2;
         this.serverConnection.sendMessage(invSwap);

         var tempType:int = sourceObj.equipment_[slotId1];
         sourceObj.equipment_[slotId1] = targetObj.equipment_[slotId2];
         targetObj.equipment_[slotId2] = tempType;

         var tempData:Object = sourceObj.equipData_[slotId1];
         sourceObj.equipData_[slotId1] = targetObj.equipData_[slotId2];
         targetObj.equipData_[slotId2] = tempData;
         SoundEffectLibrary.play("inventory_move_item");
         return true;
      }

      public function invSwapPotion(player:Player, sourceObj:GameObject, slotId1:int, itemId:int, targetObj:GameObject, slotId2:int, objectType2:int) : Boolean
      {
         if(!this.gs_)
         {
            return false;
         }
         var invSwap:InvSwap = this.messages.require(INVSWAP) as InvSwap;
         invSwap.time_ = this.gs_.lastUpdate_;
         invSwap.position_.x_ = player.x_;
         invSwap.position_.y_ = player.y_;
         invSwap.slotObject1_.objectId_ = sourceObj.objectId_;
         invSwap.slotObject1_.slotId_ = slotId1;
         invSwap.slotObject1_.objectType_ = itemId;
         invSwap.slotObject2_.objectId_ = targetObj.objectId_;
         invSwap.slotObject2_.slotId_ = slotId2;
         invSwap.slotObject2_.objectType_ = objectType2;
         sourceObj.equipment_[slotId1] = ItemConstants.NO_ITEM;
         sourceObj.equipData_[slotId1] = null;
         if(itemId == PotionInventoryModel.HEALTH_POTION_ID)
         {
            player.healthPotionCount_++;
         }
         else if(itemId == PotionInventoryModel.MAGIC_POTION_ID)
         {
            player.magicPotionCount_++;
         }
         this.serverConnection.sendMessage(invSwap);
         SoundEffectLibrary.play("inventory_move_item");
         return true;
      }

      public function invDrop(object:GameObject, slotId:int, objectType:int) : void
      {
         var invDrop:InvDrop = this.messages.require(INVDROP) as InvDrop;
         invDrop.slotObject_.objectId_ = object.objectId_;
         invDrop.slotObject_.slotId_ = slotId;
         invDrop.slotObject_.objectType_ = objectType;
         this.serverConnection.sendMessage(invDrop);
         if(slotId != PotionInventoryModel.HEALTH_POTION_SLOT && slotId != PotionInventoryModel.MAGIC_POTION_SLOT)
         {
            object.equipment_[slotId] = ItemConstants.NO_ITEM;
         }
      }

      public function useItem(time:int, objectId:int, slotId:int, objectType:int, posX:Number, posY:Number, useType:int) : void
      {
         var useItemMess:UseItem = this.messages.require(USEITEM) as UseItem;
         useItemMess.time_ = time;
         useItemMess.slotObject_.objectId_ = objectId;
         useItemMess.slotObject_.slotId_ = slotId;
         useItemMess.slotObject_.objectType_ = objectType;
         useItemMess.itemUsePos_.x_ = posX;
         useItemMess.itemUsePos_.y_ = posY;
         useItemMess.useType_ = useType;
         this.serverConnection.sendMessage(useItemMess);
      }

      public function useItem_new(itemOwner:GameObject, slotId:int):Boolean {
         var itemId:int = itemOwner.equipment_[slotId];
         var objectXML:XML = ObjectLibrary.xmlLibrary_[itemId];
         var sellMaxed:int = Parameters.data_.sellMaxyPots;
         if (objectXML && !itemOwner.isPaused() && (objectXML.hasOwnProperty("Consumable") || objectXML.hasOwnProperty("InvUse"))) {
            this.applyUseItem(itemOwner, slotId, itemId, objectXML);
            SoundEffectLibrary.play("use_potion");
            return true;
         }
         SoundEffectLibrary.play("error");
         return false;
      }

      public function PotionInteraction(type:int, action:int):void{
         var _local_1:PotionStorageInteraction = (this.messages.require(GameServerConnection.USE_STORAGE) as PotionStorageInteraction);
         _local_1.type_ = type;
         _local_1.action_ = action;
         this.serverConnection.sendMessage(_local_1);
      }

      private function applyUseItem(owner:GameObject, slotId:int, objectType:int, itemData:XML) : void
      {
         var useItem:UseItem = this.messages.require(USEITEM) as UseItem;
         useItem.time_ = getTimer();
         useItem.slotObject_.objectId_ = owner.objectId_;
         useItem.slotObject_.slotId_ = slotId;
         useItem.slotObject_.objectType_ = objectType;
         useItem.itemUsePos_.x_ = 0;
         useItem.itemUsePos_.y_ = 0;
         this.serverConnection.sendMessage(useItem);
         if(itemData.hasOwnProperty("Consumable"))
         {
            owner.equipment_[slotId] = -1;
         }
      }

      public function move(tickId:int, player:Player) : void
      {
         var len:int = 0;
         var i:int = 0;
         var x:Number = -1;
         var y:Number = -1;
         if(player && !player.isPaused())
         {
            x = player.x_;
            y = player.y_;
         }
         var move:Move = this.messages.require(MOVE) as Move;
         move.tickId_ = tickId;
         move.time_ = this.gs_.lastUpdate_;
         move.newPosition_.x_ = x;
         move.newPosition_.y_ = y;
         var lastMove:int = this.gs_.moveRecords_.lastClearTime_;
         move.records_.length = 0;
         if(lastMove >= 0 && move.time_ - lastMove > 125)
         {
            len = Math.min(10,this.gs_.moveRecords_.records_.length);
            for(i = 0; i < len; i++)
            {
               if(this.gs_.moveRecords_.records_[i].time_ >= move.time_ - 25)
               {
                  break;
               }
               move.records_.push(this.gs_.moveRecords_.records_[i]);
            }
         }
         this.gs_.moveRecords_.clear(move.time_);
         this.serverConnection.sendMessage(move);
         player && player.onMove();
      }

      public function teleport(objectId:int) : void
      {
         var teleport:Teleport = this.messages.require(TELEPORT) as Teleport;
         teleport.objectId_ = objectId;
         this.serverConnection.sendMessage(teleport);
      }

      public function usePortal(objectId:int) : void
      {
         var usePortal:UsePortal = this.messages.require(USEPORTAL) as UsePortal;
         usePortal.objectId_ = objectId;
         this.serverConnection.sendMessage(usePortal);
      }

      public function buy(sellableObjectId:int, currencyType:int) : void
      {
         if(this.outstandingBuy_)
         {
            return;
         }
         var sObj:SellableObject = this.gs_.map.goDict_[sellableObjectId];
         if(sObj == null)
            return;

         trace("Indi: TODO I think this can be switched to a Boolean with no consequences");
         this.outstandingBuy_ = new OutstandingBuy(sObj.soldObjectInternalName(),sObj.price_,sObj.currency_);
         var buyMesssage:Buy = this.messages.require(BUY) as Buy;
         buyMesssage.objectId_ = sellableObjectId;
         this.serverConnection.sendMessage(buyMesssage);
      }

      public function gotoAck(time:int) : void
      {
         var gotoAck:GotoAck = this.messages.require(GOTOACK) as GotoAck;
         gotoAck.time_ = time;
         this.serverConnection.sendMessage(gotoAck);
      }

      public function editAccountList(accountListId:int, add:Boolean, objectId:int) : void
      {
         var eal:EditAccountList = this.messages.require(EDITACCOUNTLIST) as EditAccountList;
         eal.accountListId_ = accountListId;
         eal.add_ = add;
         eal.objectId_ = objectId;
         this.serverConnection.sendMessage(eal);
      }

      public function chooseName(name:String) : void
      {
         var chooseName:ChooseName = this.messages.require(CHOOSENAME) as ChooseName;
         chooseName.name_ = name;
         this.serverConnection.sendMessage(chooseName);
      }

      public function createGuild(name:String) : void
      {
         var createGuild:CreateGuild = this.messages.require(CREATEGUILD) as CreateGuild;
         createGuild.name_ = name;
         this.serverConnection.sendMessage(createGuild);
      }

      public function guildRemove(name:String) : void
      {
         var guildRemove:GuildRemove = this.messages.require(GUILDREMOVE) as GuildRemove;
         guildRemove.name_ = name;
         this.serverConnection.sendMessage(guildRemove);
      }

      public function guildInvite(name:String) : void
      {
         var guildInvite:GuildInvite = this.messages.require(GUILDINVITE) as GuildInvite;
         guildInvite.name_ = name;
         this.serverConnection.sendMessage(guildInvite);
      }

      public function requestTrade(name:String) : void
      {
         var requestTrade:RequestTrade = this.messages.require(REQUESTTRADE) as RequestTrade;
         requestTrade.name_ = name;
         this.serverConnection.sendMessage(requestTrade);
      }

      public function changeTrade(offer:Vector.<Boolean>) : void
      {
         var changeTrade:ChangeTrade = this.messages.require(CHANGETRADE) as ChangeTrade;
         changeTrade.offer_ = offer;
         this.serverConnection.sendMessage(changeTrade);
      }

      public function partyInvite(playerInvited:String) : void
      {
          var partyInvite:PartyInvite = this.messages.require(PARTY_INVITE) as PartyInvite;
          partyInvite.name_ = playerInvited;
          this.serverConnection.sendMessage(partyInvite);
      }

      public function acceptTrade(myOffer:Vector.<Boolean>, yourOffer:Vector.<Boolean>) : void
      {
         var acceptTrade:AcceptTrade = this.messages.require(ACCEPTTRADE) as AcceptTrade;
         acceptTrade.myOffer_ = myOffer;
         acceptTrade.yourOffer_ = yourOffer;
         this.serverConnection.sendMessage(acceptTrade);
      }

      public function cancelTrade() : void
      {
         this.serverConnection.sendMessage(this.messages.require(CANCELTRADE));
      }

      public function escape() : void
      {
         if(this.playerId_ == -1)
         {
            return;
         }
         this.serverConnection.sendMessage(this.messages.require(ESCAPE));
      }

      public function joinGuild(guildName:String) : void
      {
         var joinGuild:JoinGuild = this.messages.require(JOINGUILD) as JoinGuild;
         joinGuild.guildName_ = guildName;
         this.serverConnection.sendMessage(joinGuild);
      }

      public function changeGuildRank(name:String, rank:int) : void
      {
         var changeGuildRank:ChangeGuildRank = this.messages.require(CHANGEGUILDRANK) as ChangeGuildRank;
         changeGuildRank.name_ = name;
         changeGuildRank.guildRank_ = rank;
         this.serverConnection.sendMessage(changeGuildRank);
      }

      public static function rsaEncrypt(data:String) : String
      {
         var rsaKey:RSAKey = PEM.readRSAPublicKey(Parameters.RSA_PUBLIC_KEY);
         var byteArray:ByteArray = new ByteArray();
         byteArray.writeUTFBytes(data);
         var encryptedByteArray:ByteArray = new ByteArray();
         rsaKey.encrypt(byteArray,encryptedByteArray,byteArray.length);
         return Base64.encodeByteArray(encryptedByteArray);
      }

      private function onConnected() : void
      {
         var account:Account = StaticInjectorContext.getInjector().getInstance(Account);
         var hello:Hello = this.messages.require(HELLO) as Hello;
         hello.buildVersion_ = Parameters.GAME_VERSION;
         hello.gameId_ = this.gameId_;
         hello.guid_ = rsaEncrypt(account.getUserId());
         hello.password_ = rsaEncrypt(account.getPassword());
         hello.keyTime_ = this.keyTime_;
         hello.key_.length = 0;
         this.key_ != null && hello.key_.writeBytes(this.key_);
         hello.mapJSON_ = this.mapJSON_ == null?"":this.mapJSON_;
         this.serverConnection.sendMessage(hello);
         this.addTextLine.dispatch(new AddTextLineVO(Parameters.CLIENT_CHAT_NAME,"Connected!"));
      }

      private function onCreateSuccess(createSuccess:CreateSuccess) : void
      {
         this.playerId_ = createSuccess.objectId_;
         this.charId_ = createSuccess.charId_;
         this.gs_.initialize();
         this.createCharacter_ = false;
      }

      private function onDamage(damage:Damage) : void
      {
         if (!Parameters.data_.allyDamage)
         {
            if (damage.objectId_ != playerId_ && damage.targetId_ != playerId_) // aka nothing to do wit parent player
            {
               return;
            }
         }

         var projId:int = 0;
         var map:Map = this.gs_.map;
         var proj:Projectile = null;
         if(damage.objectId_ >= 0 && damage.bulletId_ > 0)
         {
            projId = Projectile.findObjId(damage.objectId_,damage.bulletId_);
            proj = map.boDict_[projId] as Projectile;
            if(proj != null && !proj.projProps_.multiHit_)
            {
               map.removeObj(projId);
            }
         }
         var target:GameObject = map.goDict_[damage.targetId_];
         if(target != null)
         {
            target.damage(damage.damageAmount_,damage.effects_,damage.kill_,proj, damage.pierce_);
         }

         if (damage.objectId_ != playerId_ && damage.targetId_ != playerId_) // aka nothing to do wit parent player
         {
            return;
         }

         if(damage.objectId_ == playerId_) {
            if (target != null && (target.props_.isQuest_ || target.props_.isChest_)) {
               if (isNaN(Parameters.DamageCounter[damage.targetId_])) {
                  Parameters.DamageCounter[damage.targetId_] = 0;
               }
               var targetId:* = damage.targetId_;
               var damageAdd:* = Parameters.DamageCounter[targetId] + damage.damageAmount_;
               Parameters.DamageCounter[targetId] = damageAdd;
            }
         }
      }

      private function onServerPlayerShoot(serverPlayerShoot:ServerPlayerShoot) : void
      {
         var needsAck:Boolean = serverPlayerShoot.ownerId_ == this.playerId_;
         if (!Parameters.data_.allyShots && !needsAck)
         {
            return;
         }

         var owner:GameObject = this.gs_.map.goDict_[serverPlayerShoot.ownerId_];
         if(owner == null || owner.dead_)
         {
            if(needsAck)
            {
               this.shootAck(-1);
            }
            return;
         }

         var proj:Projectile = FreeList.newObject(Projectile) as Projectile;
         proj.reset(serverPlayerShoot.containerType_,0, serverPlayerShoot.ownerId_, serverPlayerShoot.bulletId_, serverPlayerShoot.angle_,this.gs_.lastUpdate_);
         proj.setDamage(serverPlayerShoot.damage_);
         this.gs_.map.addObj(proj,serverPlayerShoot.startingPos_.x_,serverPlayerShoot.startingPos_.y_);
         if(needsAck)
         {
            this.shootAck(this.gs_.lastUpdate_);
         }
      }

      private function onAllyShoot(allyShoot:AllyShoot) : void
      {
         if (!Parameters.data_.allyShots)
         {
            return;
         }

         var owner:GameObject = this.gs_.map.goDict_[allyShoot.ownerId_];
         if(owner == null || owner.dead_)
         {
            return;
         }
         var proj:Projectile = FreeList.newObject(Projectile) as Projectile;
         proj.reset(allyShoot.containerType_,0,allyShoot.ownerId_,allyShoot.bulletId_,allyShoot.angle_,this.gs_.lastUpdate_);
         this.gs_.map.addObj(proj,owner.x_,owner.y_);
         owner.setAttack(allyShoot.containerType_,allyShoot.angle_);
      }

      private function onEnemyShoot(enemyShoot:EnemyShoot) : void
      {
         var proj:Projectile = null;
         var angle:Number = NaN;
         var owner:GameObject = this.gs_.map.goDict_[enemyShoot.ownerId_];
         if(owner == null || owner.dead_)
         {
            this.shootAck(-1);
            return;
         }
         for(var i:int = 0; i < enemyShoot.numShots_; i++)
         {
            proj = FreeList.newObject(Projectile) as Projectile;
            angle = enemyShoot.angle_ + enemyShoot.angleInc_ * i;
            proj.reset(owner.objectType_,enemyShoot.bulletType_,enemyShoot.ownerId_,enemyShoot.bulletId_ + i, angle,this.gs_.lastUpdate_);
            proj.setDamage(enemyShoot.damage_);
            this.gs_.map.addObj(proj,enemyShoot.startingPos_.x_,enemyShoot.startingPos_.y_);
            proj.addTo(this.gs_.map, enemyShoot.startingPos_.x_, enemyShoot.startingPos_.y_);
         }
         this.shootAck(this.gs_.lastUpdate_);
         owner.setAttack(owner.objectType_,enemyShoot.angle_ + enemyShoot.angleInc_ * ((enemyShoot.numShots_ - 1) / 2));
      }

      private function onTradeRequested(tradeRequested:TradeRequested) : void
      {
         if(Parameters.data_.showTradePopup)
         {
            this.gs_.hudView.interactPanel.setOverride(new TradeRequestPanel(this.gs_,tradeRequested.name_));
         }
         this.addTextLine.dispatch(new AddTextLineVO("",tradeRequested.name_ + " wants to " + "trade with you.  Type \"/trade " + tradeRequested.name_ + "\" to trade."));
      }

      private function onTradeStart(tradeStart:TradeStart) : void
      {
         this.gs_.hudView.startTrade(this.gs_,tradeStart);
      }

      private function onTradeChanged(tradeChanged:TradeChanged) : void
      {
         this.gs_.hudView.tradeChanged(tradeChanged);
      }

      private function onTradeDone(tradeDone:TradeDone) : void
      {
         this.gs_.hudView.tradeDone();
         this.addTextLine.dispatch(new AddTextLineVO("",tradeDone.description_));
      }

      private function onTradeAccepted(tradeAccepted:TradeAccepted) : void
      {
         this.gs_.hudView.tradeAccepted(tradeAccepted);
      }

      private function addObject(obj:ObjectData) : void
      {
         var map:Map = this.gs_.map;
         var go:GameObject = ObjectLibrary.getObjectFromType(obj.objectType_);
         if(go == null) {
            trace("unhandled object type: " + obj.objectType_);
            return;
         }
         var status:ObjectStatusData = obj.status_;
         go.setObjectId(status.objectId_);
         map.addObj(go,status.pos_.x_,status.pos_.y_);
         if(go is Player) {
            this.handleNewPlayer(go as Player,map);
         }
         this.processObjectStatus(status,0,-1);
         if(go.props_.static_ && go.props_.occupySquare_ && !go.props_.noMiniMap_) {
            this.updateGameObjectTileSignal.dispatch(new UpdateGameObjectTileVO(go.x_,go.y_,go));
         }
      }

      private function handleNewPlayer(player:Player, map:Map) : void
      {
         this.setPlayerSkinTemplate(player,0);
         if(player.objectId_ == this.playerId_)
         {
            this.player = player;
            this.model.player = player;
            map.player_ = player;
            this.gs_.setFocus(player);
            this.setGameFocus.dispatch(this.playerId_.toString());
         }
      }

      private function onUpdate(update:Update):void {
         var updateAck:Message = this.messages.require(UPDATEACK);
         serverConnection.sendMessage(updateAck);

         var i:int = 0;
         var tile:GroundTileData;
         while (i < update.tiles_.length) {
            tile = update.tiles_[i];
            gs_.map.setGroundTile(tile.x_, tile.y_, tile.type_);
            this.updateGroundTileSignal.dispatch(new UpdateGroundTileVO(tile.x_, tile.y_, tile.type_));
            i++;
         }
         i = 0;
         while (i < update.newObjs_.length) {
            this.addObject(update.newObjs_[i]);
            i++;
         }
         i = 0;
         while (i < update.drops_.length) {
            gs_.map.removeObj(update.drops_[i]);
            i++;
         }
      }

      private function onNotification(notification:Notification) : void
      {
         var go:GameObject = this.gs_.map.goDict_[notification.objectId_];
         if (go != null){
            if (go == this.player){
               if(notification.text_ == "Quest Complete!"){
                  this.gs_.map.quest_.completed();
               }
               this.makeNotification(notification.text_, go, notification.color_, 1000);
            }else{
               if(go.props_.isEnemy_ || !Parameters.data_.noAllyNotifications) {
                  this.makeNotification(notification.text_, go, notification.color_, 1000);
               }
            }
         }
      }

      private function makeNotification(text:String, go:GameObject, color:uint, lifetime:int):void
      {
         var queuedStatusText:QueuedStatusText = new QueuedStatusText(go, text, color, lifetime);
         this.gs_.map.mapOverlay_.addQueuedText(queuedStatusText);
      }

      private function onGlobalNotification(notification:GlobalNotification) : void
      {
         switch(notification.text)
         {
            case "yellow":
               ShowKeySignal.instance.dispatch(Key.YELLOW);
               break;
            case "red":
               ShowKeySignal.instance.dispatch(Key.RED);
               break;
            case "green":
               ShowKeySignal.instance.dispatch(Key.GREEN);
               break;
            case "purple":
               ShowKeySignal.instance.dispatch(Key.PURPLE);
               break;
            case "showKeyUI":
               ShowKeyUISignal.instance.dispatch();
               break;
         }
      }

      private function onNewTick(newTick:NewTick) : void
      {
         if(this.jitterWatcher_ != null){
            this.jitterWatcher_.record();
         }
         this.move(newTick.tickId_,this.player);
         var objectStatus:ObjectStatusData = null;
         for each(objectStatus in newTick.statuses_)
         {
            this.processObjectStatus(objectStatus,newTick.tickTime_,newTick.tickId_);
         }
         this.lastTickId_ = newTick.tickId_;
      }

      private function canShowEffect(go:GameObject) : Boolean {
         var isPlayer:Boolean = go.objectId_ == this.playerId_;
         return !isPlayer && go is Player && Parameters.data_.disableAllyParticles;
      }

      private function onShowEffect(showEffect:ShowEffect) : void
      {
         var go:GameObject = null;
         var e:ParticleEffect = null;
         var start:Point = null;
         var map:Map = this.gs_.map;

         switch(showEffect.effectType_)
         {
            case ShowEffect.HEAL_EFFECT_TYPE:
               go = map.goDict_[showEffect.targetObjectId_];
               if(go == null || !canShowEffect(go))
               {
                  break;
               }
               map.addObj(new HealEffect(go,showEffect.color_),go.x_,go.y_);
               break;
            case ShowEffect.TELEPORT_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               map.addObj(new TeleportEffect(), showEffect.pos1_.x_, showEffect.pos1_.y_);
               break;
            case ShowEffect.STREAM_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               e = new StreamEffect(showEffect.pos1_,showEffect.pos2_,showEffect.color_);
               map.addObj(e,showEffect.pos1_.x_,showEffect.pos1_.y_);
               break;
            case ShowEffect.THROW_EFFECT_TYPE:
               go = map.goDict_[showEffect.targetObjectId_];
               start = go != null?new Point(go.x_,go.y_):showEffect.pos2_.toPoint();
               e = new ThrowEffect(start,showEffect.pos1_.toPoint(),showEffect.color_, showEffect.duration_ * 1000);
               map.addObj(e,start.x,start.y);
               break;
            case ShowEffect.NOVA_EFFECT_TYPE:
               if(showEffect.pos2_.y_ == 255 && showEffect.pos2_.x_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               go = map.goDict_[showEffect.targetObjectId_];
               if(go == null || (showEffect.pos2_.y_ == 255 && showEffect.pos2_.x_ != this.playerId_) && (Parameters.data_.disableAllyParticles || Parameters.data_.disableAllParticles))
               {
                  break;
               }
               e = new NovaEffect(go,showEffect.pos1_.x_,showEffect.color_);
               map.addObj(e,go.x_,go.y_);
               break;
            case ShowEffect.POISON_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               go = map.goDict_[showEffect.targetObjectId_];
               if (go == null) {
                  break;
               }
               e = new PoisonEffect(go, showEffect.color_);
               map.addObj(e, go.x_, go.y_);
               break;
            case ShowEffect.LINE_EFFECT_TYPE:
               go = map.goDict_[showEffect.targetObjectId_];
               if (go == null) {
                  break;
               }
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               e = new LineEffect(go, showEffect.pos1_, showEffect.color_);
               map.addObj(e, showEffect.pos1_.x_, showEffect.pos1_.y_);
               break;
            case ShowEffect.BURST_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               go = map.goDict_[showEffect.targetObjectId_];
               if(go == null)
               {
                  break;
               }
               e = new BurstEffect(go,showEffect.pos1_,showEffect.pos2_,showEffect.color_);
               map.addObj(e,showEffect.pos1_.x_,showEffect.pos1_.y_);
               break;
            case ShowEffect.FLOW_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               go = map.goDict_[showEffect.targetObjectId_];
               if (go == null) {
                  break;
               }
               e = new FlowEffect(showEffect.pos1_, go, showEffect.color_);
               map.addObj(e, showEffect.pos1_.x_, showEffect.pos1_.y_);
               break;
            case ShowEffect.RING_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               go = map.goDict_[showEffect.targetObjectId_];
               if(go == null)
               {
                  break;
               }
               e = new RingEffect(go,showEffect.pos1_.x_,showEffect.color_);
               map.addObj(e,go.x_,go.y_);
               break;
            case ShowEffect.LIGHTNING_EFFECT_TYPE:
               //if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               go = map.goDict_[showEffect.targetObjectId_];
               if(go == null)
               {
                  break;
               }
               e = new LightningEffect(go,showEffect.pos1_,showEffect.color_,showEffect.pos2_.x_);
               map.addObj(e,go.x_,go.y_);
               break;
            case ShowEffect.COLLAPSE_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               go = map.goDict_[showEffect.targetObjectId_];
               if(go == null)
               {
                  break;
               }
               e = new CollapseEffect(go,showEffect.pos1_,showEffect.pos2_,showEffect.color_);
               map.addObj(e,showEffect.pos1_.x_,showEffect.pos1_.y_);
               break;
            case ShowEffect.CONEBLAST_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               go = map.goDict_[showEffect.targetObjectId_];
               if(go == null)
               {
                  break;
               }
               e = new ConeBlastEffect(go,showEffect.pos1_,showEffect.pos2_.x_,showEffect.color_);
               map.addObj(e,go.x_,go.y_);
               break;
            case ShowEffect.JITTER_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               this.gs_.camera_.startJitter();
               break;
            case ShowEffect.FLASH_EFFECT_TYPE:
               if(showEffect.targetObjectId_ != this.playerId_ && Parameters.data_.disableAllParticles) return;
               go = map.goDict_[showEffect.targetObjectId_];
               if(go == null)
               {
                  break;
               }
               go.flash_ = new FlashDescription(getTimer(),showEffect.color_,showEffect.pos1_.x_,showEffect.pos1_.y_);
               break;
            case ShowEffect.THROW_PROJECTILE_EFFECT_TYPE:
               go = map.goDict_[showEffect.targetObjectId_];
               start = (((start) != null) ? new Point(go.x_, go.y_) : showEffect.pos2_.toPoint());
               e = new ThrowProjectileEffect(showEffect.objectType, showEffect.pos2_.toPoint(), showEffect.pos1_.toPoint(), showEffect.duration_);
               map.addObj(e, start.x, start.y);
               break;
            case ShowEffect.INSPIRED_EFFECT_TYPE:
               go = map.goDict_[showEffect.targetObjectId_];
               if (go == null)
               {
                  break;
               }
               if (go && go.spritesProjectEffect)
               {
                  go.spritesProjectEffect.destroy();
               }
               map.addObj(new InspireEffect(go,16759296,5), go.x_, go.y_);
               go.flash_ = new FlashDescription(TimeUtil.getTrueTime(), showEffect.color_, showEffect.pos2_.x_, showEffect.pos2_.y_);
               go = new SpritesProjectEffect(go, showEffect.pos1_.x_);
               go.spritesProjectEffect = SpritesProjectEffect(go);
               this.gs_.map.addObj(go, go.x_, go.y_);
               break;
            /*case ShowEffect.THROW_PROJECTILE_EFFECT_TYPE:
               start = showEffect.pos1_.toPoint();
               e = new ThrowProjectileEffect(showEffect.color_,showEffect.pos2_.toPoint(),showEffect.pos1_.toPoint());
               map.addObj(e,start.x,start.y);
               break;*/
            default:
               trace("ERROR: Unknown Effect type: " + showEffect.effectType_);
         }
      }

      private function onGoto(_arg1:Goto) : void
      {
         this.gotoAck(this.gs_.lastUpdate_);
         var go:GameObject = this.gs_.map.goDict_[_arg1.objectId_];
         if(go == null)
         {
            return;
         }
         go.onGoto(_arg1.pos_.x_,_arg1.pos_.y_,this.gs_.lastUpdate_);
      }

      private function updateGameObject(go:GameObject, stats:Vector.<StatData>, isMyObject:Boolean) : void
      {
         var stat:StatData = null;
         var value:int = 0;
         var index:int = 0;
         var player:Player = go as Player;
         var merchant:Merchant = go as Merchant;
         for each(stat in stats)
         {
            value = stat.statValue_;
            switch(stat.statType_)
            {
               case StatData.MAX_HP_STAT:
                  go.maxHP_ = value;
                  continue;
               case StatData.HP_STAT:
                  go.hp_ = value;
                  go.rtHp_ = go.hp_;
                  continue;
               case StatData.SIZE_STAT:
                  go.size_ = value;
                  continue;
               case StatData.MAX_MP_STAT:
                  player.maxMP_ = value;
                  continue;
               case StatData.MP_STAT:
                  player.mp_ = value;
                  continue;
               case StatData.NEXT_LEVEL_EXP_STAT:
                  player.nextLevelExp_ = value;
                  continue;
               case StatData.EXP_STAT:
                  player.exp_ = value;
                  continue;
               case StatData.LEVEL_STAT:
                  go.level_ = value;
                  continue;
               case StatData.ATTACK_STAT:
                  player.attack_ = value;
                  continue;
               case StatData.DEFENSE_STAT:
                  go.defense_ = value;
                  continue;
               case StatData.SPEED_STAT:
                  player.speed_ = value;
                  continue;
               case StatData.DEXTERITY_STAT:
                  player.dexterity_ = value;
                  continue;
               case StatData.VITALITY_STAT:
                  player.vitality_ = value;
                  continue;
               case StatData.WISDOM_STAT:
                  player.wisdom_ = value;
                  continue;
               case StatData.CONDITION_STAT:
                  go.condition_[ConditionEffect.CE_FIRST_BATCH] = value;
                  continue;
               case StatData.INVENTORY_0_STAT:
               case StatData.INVENTORY_1_STAT:
               case StatData.INVENTORY_2_STAT:
               case StatData.INVENTORY_3_STAT:
               case StatData.INVENTORY_4_STAT:
               case StatData.INVENTORY_5_STAT:
               case StatData.INVENTORY_6_STAT:
               case StatData.INVENTORY_7_STAT:
               case StatData.INVENTORY_8_STAT:
               case StatData.INVENTORY_9_STAT:
               case StatData.INVENTORY_10_STAT:
               case StatData.INVENTORY_11_STAT:
                  go.equipment_[stat.statType_ - StatData.INVENTORY_0_STAT] = value;
                  continue;
               case StatData.NUM_STARS_STAT:
                  player.numStars_ = value;
                  continue;
               case StatData.NAME_STAT:
                  if(go.name_ != stat.strStatValue_)
                  {
                     go.name_ = stat.strStatValue_;
                     go.nameBitmapData_ = null;
                  }
                  continue;
               case StatData.TEX1_STAT:
                  go.setTex1(value);
                  continue;
               case StatData.TEX2_STAT:
                  go.setTex2(value);
                  continue;
               case StatData.MERCHANDISE_TYPE_STAT:
                  if(merchant != null) {
                     merchant.setMerchandiseType(value);
                  }
                  continue;
               case StatData.CREDITS_STAT:
                  player.setCredits(value);
                  continue;
               case StatData.MERCHANDISE_PRICE_STAT:
                       if(go is SellableObject) {
                          (go as SellableObject).setPrice(value);
                       }
                  continue;
               case StatData.ACTIVE_STAT:
                       if (go as Portal != null) {
                          (go as Portal).active_ = value != 0;
                       }
                  continue;
               case StatData.ACCOUNT_ID_STAT:
                  player.accountId_ = value;
                  continue;
               case StatData.FAME_STAT:
                  player.fame_ = value;
                  continue;
               case StatData.MERCHANDISE_CURRENCY_STAT:
                  if(go is SellableObject) {
                     (go as SellableObject).setCurrency(value);
                  }
                  continue;
               case StatData.CONNECT_STAT:
                  go.connectType_ = value;
                  continue;
               case StatData.MERCHANDISE_COUNT_STAT:
                  if(merchant != null) {
                     merchant.count_ = value;
                     merchant.untilNextMessage_ = 0;
                  }
                  continue;
               case StatData.MERCHANDISE_MINS_LEFT_STAT:
                  if(merchant != null) {
                     merchant.minsLeft_ = value;
                     merchant.untilNextMessage_ = 0;
                  }
                  continue;
               case StatData.MERCHANDISE_DISCOUNT_STAT:
                  if(merchant != null) {
                     merchant.discount_ = value;
                     merchant.untilNextMessage_ = 0;
                  }
                  continue;
               case StatData.MERCHANDISE_RANK_REQ_STAT:
                  if(go is SellableObject) {
                     (go as SellableObject).setRankReq(value);
                  }
                  continue;
               case StatData.MAX_HP_BOOST_STAT:
                  player.maxHPBoost_ = value;
                  continue;
               case StatData.MAX_MP_BOOST_STAT:
                  player.maxMPBoost_ = value;
                  continue;
               case StatData.ATTACK_BOOST_STAT:
                  player.attackBoost_ = value;
                  continue;
               case StatData.DEFENSE_BOOST_STAT:
                  player.defenseBoost_ = value;
                  continue;
               case StatData.SPEED_BOOST_STAT:
                  player.speedBoost_ = value;
                  continue;
               case StatData.VITALITY_BOOST_STAT:
                  player.vitalityBoost_ = value;
                  continue;
               case StatData.WISDOM_BOOST_STAT:
                  player.wisdomBoost_ = value;
                  continue;
               case StatData.DEXTERITY_BOOST_STAT:
                  player.dexterityBoost_ = value;
                  continue;
               case StatData.OWNER_ACCOUNT_ID_STAT:
                  (go as Container).setOwnerId(value);
                  continue;
               case StatData.RANK_REQUIRED_STAT:
                  (go as NameChanger).setRankRequired(value);
                  continue;
               case StatData.NAME_CHOSEN_STAT:
                  player.nameChosen_ = value != 0;
                  go.nameBitmapData_ = null;
                  continue;
               case StatData.CURR_FAME_STAT:
                  player.currFame_ = value;
                  continue;
               case StatData.NEXT_CLASS_QUEST_FAME_STAT:
                  player.nextClassQuestFame_ = value;
                  continue;
               case StatData.GLOW_COLOR:
                  go.setGlow(value);
                  continue;
               case StatData.SINK_LEVEL_STAT:
                  if(!isMyObject)
                  {
                     player.sinkLevel_ = value;
                  }
                  continue;
               case StatData.ALT_TEXTURE_STAT:
                  go.setAltTexture(value);
                  continue;
               case StatData.GUILD_NAME_STAT:
                  player.setGuildName(stat.strStatValue_);
                  continue;
               case StatData.GUILD_RANK_STAT:
                  player.guildRank_ = value;
                  continue;
               case StatData.BREATH_STAT:
                  player.breath_ = value;
                  continue;
               case StatData.HEALTH_POTION_STACK_STAT:
                  player.healthPotionCount_ = value;
                  continue;
               case StatData.MAGIC_POTION_STACK_STAT:
                  player.magicPotionCount_ = value;
                  continue;
               case StatData.TEXTURE_STAT:
                  player.skinId != value && this.setPlayerSkinTemplate(player,value);
                  continue;
               case StatData.LD_TIMER_STAT:
                  player.dropBoost = value * 1000;
                  continue;
               case StatData.HASBACKPACK_STAT:
                  (go as Player).hasBackpack_ = Boolean(value);
                  if(isMyObject)
                  {
                     this.updateBackpackTab.dispatch(Boolean(value));
                  }
                  continue;
               case StatData.BACKPACK_0_STAT:
               case StatData.BACKPACK_1_STAT:
               case StatData.BACKPACK_2_STAT:
               case StatData.BACKPACK_3_STAT:
               case StatData.BACKPACK_4_STAT:
               case StatData.BACKPACK_5_STAT:
               case StatData.BACKPACK_6_STAT:
               case StatData.BACKPACK_7_STAT:
                  index = stat.statType_ - StatData.BACKPACK_0_STAT + GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS;
                  (go as Player).equipment_[index] = value;
                  continue;
               case StatData.BASESTAT:
                  player.baseStat = value;
                  continue;
               case StatData.POINTS:
                  player.points = value;
                  continue;
               case StatData.GLOW_ENEMY_COLOR:
                  go.setGlowEnemy(value);
                  continue;
               case StatData.XP_BOOSTED:
                  player.xpBoost_ = value;
                  continue;
               case StatData.XP_TIMER_BOOST:
                  player.xpTimer = (value * TO_MILLISECONDS);
                  continue;
               case StatData.RANK:
                  player.rank = value;
                    continue;
               case StatData.CHAT_COLOR:
                       player.chatColor = value;
                    continue;
               case StatData.NAME_CHAT_COLOR:
                       player.nameChatColor = value;
                    continue;
               case StatData.UPGRADEENABLED:
                  player.upgraded_ = value == 1;
                    continue;
               case StatData.CONDITION_STAT_2:
                  go.condition_[ConditionEffect.CE_SECOND_BATCH] = value;
                  continue;
               case StatData.PARTYID:
                       player.partyId_ = value;
                       player.setParty();
                    continue;
               case StatData.INVDATA0:
               case StatData.INVDATA1:
               case StatData.INVDATA2:
               case StatData.INVDATA3:
               case StatData.INVDATA4:
               case StatData.INVDATA5:
               case StatData.INVDATA6:
               case StatData.INVDATA7:
               case StatData.INVDATA8:
               case StatData.INVDATA9:
               case StatData.INVDATA10:
               case StatData.INVDATA11:
                  go.equipData_[stat.statType_ - StatData.INVDATA0] = JSON.parse(stat.strStatValue_);
                    continue;
               case StatData.BACKPACKDATA0:
               case StatData.BACKPACKDATA1:
               case StatData.BACKPACKDATA2:
               case StatData.BACKPACKDATA3:
               case StatData.BACKPACKDATA4:
               case StatData.BACKPACKDATA5:
               case StatData.BACKPACKDATA6:
               case StatData.BACKPACKDATA7:
                  index = stat.statType_ - StatData.BACKPACKDATA0 + GeneralConstants.NUM_EQUIPMENT_SLOTS + GeneralConstants.NUM_INVENTORY_SLOTS;
                  (go as Player).equipData_[index] = JSON.parse(stat.strStatValue_);
                  continue;
               case StatData.SPEEDMULT:
                  player.projectileSpeedMult_ = value;
               default:
                  trace("unhandled stat: " + stat.statType_);
                  continue;
            }
         }
      }

      private function setPlayerSkinTemplate(player:Player, skinId:int) : void
      {
         var message:Reskin = this.messages.require(RESKIN) as Reskin;
         message.skinID = skinId;
         message.player = player;
         message.consume();
      }

      private function processObjectStatus(objectStatus:ObjectStatusData, tickTime:int, tickId:int) : void
      {
         var oldLevel:int = 0;
         var oldExp:int = 0;
         var oldFame:int = 0;
         var newUnlocks:Array = null;
         var type:CharacterClass = null;
         var map:Map = this.gs_.map;
         var go:GameObject = map.goDict_[objectStatus.objectId_];
         if(go == null)
         {
            //trace("missing object: " + objectStatus.objectId_);
            return;
         }
         var isMyObject:Boolean = objectStatus.objectId_ == this.playerId_;
         var noAllyNotifications:Boolean = Parameters.data_.noAllyNotifications;
         if(tickTime != 0 && !isMyObject)
         {
            go.onTickPos(objectStatus.pos_.x_,objectStatus.pos_.y_,tickTime,tickId);
         }
         var player:Player = go as Player;
         if(player != null)
         {
            oldLevel = player.level_;
            oldExp = player.exp_;
            oldFame = player.fame_;
         }
         this.updateGameObject(go,objectStatus.stats_,isMyObject);
         if(player != null && oldLevel != -1)
         {
            if(player.level_ > oldLevel)
            {
               if(isMyObject)
               {
                  newUnlocks = this.gs_.model.getNewUnlocks(player.objectType_,player.level_);
                  player.handleLevelUp(newUnlocks.length != 0);
                  type = this.classesModel.getCharacterClass(player.objectType_);
                  if(type.getMaxLevelAchieved() < player.level_)
                  {
                     type.setMaxLevelAchieved(player.level_);
                  }
               }
               else
               {
                  if (noAllyNotifications)
                  {
                     player.levelUpEffect("Level Up!");
                  }
               }
            }
            else if(player.exp_ > oldExp)
            {
               if (!noAllyNotifications && !isMyObject)
               {
                  return;
               }
               player.handleExpUp(player.exp_ - oldExp);
               player.handleFameUp(player.fame_ - oldFame)
            }
         }
      }

      private function onText(text:Text) : void
      {
         var go:GameObject = null;
         var colors:Vector.<uint> = null;
         var speechBalloonvo:AddSpeechBalloonVO = null;
         var textString:String = text.text_;
         if(text.objectId_ >= 0)
         {
            go = this.gs_.map.goDict_[text.objectId_];
            if(go != null)
            {
               colors = NORMAL_SPEECH_COLORS;
               if(go.props_.isEnemy_)
               {
                  colors = ENEMY_SPEECH_COLORS;
               }
               else if(text.recipient_ == Parameters.GUILD_CHAT_NAME)
               {
                  colors = GUILD_SPEECH_COLORS;
               }
               else if(text.recipient_ == Parameters.PARTY_CHAT_NAME)
               {
                  colors = PARTY_SPEECH_COLORS;
               }
               else if(text.recipient_ != "")
               {
                  colors = TELL_SPEECH_COLORS;
               }
               speechBalloonvo = new AddSpeechBalloonVO(go,textString,"",false,false,colors[0],1,colors[1],1,colors[2],text.bubbleTime_,false,true);
               this.addSpeechBalloon.dispatch(speechBalloonvo);
            }
         }
         this.addTextLine.dispatch(new AddTextLineVO(text.name_,textString,text.objectId_,text.numStars_,text.recipient_, text.nameColor_, text.textColor_));
      }

      private function onInvResult(invResult:InvResult) : void
      {
         if(invResult.result_ != 0)
         {
            this.handleInvFailure();
         }
      }

      private function handleInvFailure() : void
      {
         SoundEffectLibrary.play("error");
         this.gs_.hudView.interactPanel.redraw();
      }

      private function onReconnect(reconnect:Reconnect) : void
      {
         this.disconnect();
         var server:Server = new Server().setName(reconnect.name_).setAddress(reconnect.host_ != ""?reconnect.host_:this.server_.address).setPort(reconnect.host_ != ""?int(reconnect.port_):int(this.server_.port));
         var gameID:int = reconnect.gameId_;
         var createChar:Boolean = this.createCharacter_;
         var charId:int = this.charId_;
         var keyTime:int = reconnect.keyTime_;
         var key:ByteArray = reconnect.key_;
         var reconnectEvent:ReconnectEvent = new ReconnectEvent(server,gameID,createChar,charId,keyTime,key);
         this.gs_.dispatchEvent(reconnectEvent);
      }

      private function onPing(ping:Ping) : void
      {
         if(this.gs_.gameStatistics_ != null){
            this.gs_.gameStatistics_.setPing(ping.roundTripTime_);
         }
         var pong:Pong = this.messages.require(PONG) as Pong;
         pong.serial_ = ping.serial_;
         pong.time_ = getTimer();
         this.serverConnection.sendMessage(pong);
      }

      private function onMapInfo(mapInfo:MapInfo) : void
      {
         this.gs_.applyMapInfo(mapInfo);
         this.rand_ = new Random(mapInfo.fp_);
         Music.load(mapInfo.music);
         if(this.createCharacter_)
         {
            this.create();
         }
         else
         {
            this.load();
         }
      }

      private function onPic(pic:Pic) : void
      {
         this.gs_.addChild(new PicView(pic.bitmapData_));
      }

      private function onDeath(death:Death) : void
      {
         disconnect();

         this.death = death;
         var data:BitmapData = new BitmapData(this.gs_.stage.stageWidth,this.gs_.stage.stageHeight);
         data.draw(this.gs_);
         death.background = data;
         if(!this.gs_.isEditor)
         {
            this.handleDeath.dispatch(death);
         }
      }

      private function onBuyResult(buyResult:BuyResult) : void
      {
         if(buyResult.result_ == BuyResult.SUCCESS_BRID)
         {
            if(this.outstandingBuy_)
            {
            }
         }
         this.outstandingBuy_ = null;
         switch(buyResult.result_)
         {
            case BuyResult.DIALOG_BRID:
               StaticInjectorContext.getInjector().getInstance(OpenDialogSignal).dispatch(new FlexibleDialog("Purchase Error", buyResult.resultString_));
               break;
            default:
               this.addTextLine.dispatch(new AddTextLineVO(buyResult.result_ == BuyResult.SUCCESS_BRID?Parameters.SERVER_CHAT_NAME:Parameters.ERROR_CHAT_NAME,buyResult.resultString_));
         }
      }

      private function onAccountList(accountList:AccountList) : void
      {
         if(accountList.accountListId_ == 0)
         {
            this.gs_.map.party_.setStars(accountList);
         }
         if(accountList.accountListId_ == 1)
         {
            this.gs_.map.party_.setIgnores(accountList);
         }
      }

      private function onQuestObjId(questObjId:QuestObjId) : void
      {
         this.gs_.map.quest_.setObject(questObjId.objectId_);
      }

      private function onAoe(aoe:Aoe) : void
      {
         var d:int = 0;
         var effects:Vector.<uint> = null;
         if(this.player == null)
         {
            this.aoeAck(this.gs_.lastUpdate_,0,0);
            return;
         }
         var e:AOEEffect = new AOEEffect(aoe.pos_.toPoint(),aoe.radius_,aoe.color_);// 16711680 color
         this.gs_.map.addObj(e,aoe.pos_.x_,aoe.pos_.y_);
         if(this.player.isInvincible() || this.player.isPaused())
         {
            this.aoeAck(this.gs_.lastUpdate_,this.player.x_,this.player.y_);
            return;
         }
         var hit:Boolean = this.player.distTo(aoe.pos_) < aoe.radius_;
         if(hit)
         {
            d = GameObject.damageWithDefense(aoe.damage_,this.player.defense_,false,this.player.condition_);
            effects = null;
            if(aoe.effect_ != 0)
            {
               effects = new Vector.<uint>();
               effects.push(aoe.effect_);
            }
            this.player.damage(d, effects,false,null, false);
         }
         this.aoeAck(this.gs_.lastUpdate_,this.player.x_,this.player.y_);
      }

      private function onNameResult(nameResult:NameResult) : void
      {
         this.gs_.dispatchEvent(new NameResultEvent(nameResult));
      }

      private function onGuildResult(guildResult:GuildResult) : void
      {
         this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,guildResult.errorText_));
         this.gs_.dispatchEvent(new GuildResultEvent(guildResult.success_,guildResult.errorText_));
      }

      private function onClientStat(clientStat:ClientStat) : void
      {
         var account:Account = StaticInjectorContext.getInjector().getInstance(Account);
         account.reportIntStat(clientStat.name_,clientStat.value_);
      }

      private function onFile(file:File) : void
      {
         new FileReference().save(file.file_,file.filename_);
      }

      private function onInvitedToGuild(invitedToGuild:InvitedToGuild) : void
      {
         if(Parameters.data_.showGuildInvitePopup)
         {
            this.gs_.hudView.interactPanel.setOverride(new GuildInvitePanel(this.gs_,invitedToGuild.name_,invitedToGuild.guildName_));
         }
         this.addTextLine.dispatch(new AddTextLineVO("","You have been invited by " + invitedToGuild.name_ + " to join the guild " + invitedToGuild.guildName_ + ".\n  If you wish to join type \"/join " + invitedToGuild.guildName_ + "\""));
      }

      private function onPlaySound(playSound:PlaySound) : void
      {
         var obj:GameObject = this.gs_.map.goDict_[playSound.ownerId_];
         obj && obj.playSound(playSound.soundId_);
      }

      private function onClosed() : void
      {
         if(this.playerId_ != -1)
         {
            this.gs_.closed.dispatch();
         }
         else if(this.retryConnection_)
         {
            if(this.delayBeforeReconect < 12)
            {
               if (this.delayBeforeReconect == 5)
               {
                  var hideMap:HideMapLoadingSignal = StaticInjectorContext.getInjector().getInstance(HideMapLoadingSignal);
                  hideMap && hideMap.dispatch();
               }
               this.retry();
               this.delayBeforeReconect++;
               this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,"Connection failed!  Retrying..."));
            }
            else
            {
               this.gs_.closed.dispatch();
            }
         }
      }

      private function retry() : void
      {
         this.retryTimer_ = new Timer(1200,1);
         this.retryTimer_.addEventListener(TimerEvent.TIMER_COMPLETE,this.onRetryTimer);
         this.retryTimer_.start();
      }

      private function onRetryTimer(event:TimerEvent) : void
      {
         this.serverConnection.connect(this.server_.address,this.server_.port);
      }

      private function onError(error:String) : void
      {
         this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,error));
      }

      private function onFailure(event:Failure) : void
      {
         switch(event.errorId_)
         {
            case Failure.INCORRECT_VERSION:
               this.handleIncorrectVersionFailure(event);
               break;
            case Failure.FORCE_CLOSE_GAME:
               this.handleForceCloseGameFailure(event);
               break;
            case Failure.INVALID_TELEPORT_TARGET:
               this.handleInvalidTeleportTarget(event);
               break;
            default:
               this.handleDefaultFailure(event);
         }
      }

      private function handleInvalidTeleportTarget(event:Failure) : void
      {
         this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,event.errorDescription_));
         this.player.nextTeleportAt_ = 0;
      }

      private function handleForceCloseGameFailure(event:Failure) : void
      {
         this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,event.errorDescription_));
         this.retryConnection_ = false;
         this.gs_.closed.dispatch();
      }

      private function handleIncorrectVersionFailure(event:Failure) : void
      {
         var dialog:Dialog = new Dialog("Client version: " + Parameters.GAME_VERSION + "\nServer version: " + event.errorDescription_,"Client Update Needed","Ok",null);
         dialog.addEventListener(Dialog.BUTTON1_EVENT,this.onDoClientUpdate);
         this.gs_.stage.addChild(dialog);
         this.retryConnection_ = false;
      }

      private function handleDefaultFailure(event:Failure) : void
      {
         this.addTextLine.dispatch(new AddTextLineVO(Parameters.ERROR_CHAT_NAME,event.errorDescription_));
      }

      private function onDoClientUpdate(event:Event) : void
      {
         var dialog:Dialog = event.currentTarget as Dialog;
         dialog.parent.removeChild(dialog);
         this.gs_.closed.dispatch();
      }


      /* Market */
      private function onMarketSearchResult(searchResult:MarketSearchResult) : void
      {
         MemMarketSearchSignal.instance.dispatch(searchResult);
      }

      /* Market */
      private function onMarketBuyResult(buyResult:MarketBuyResult) : void
      {
         MemMarketBuySignal.instance.dispatch(buyResult);
      }

      /* Market */
      private function onMarketAddResult(addResult:MarketAddResult) : void
      {
         MemMarketAddSignal.instance.dispatch(addResult);
      }

      /* Market */
      private function onMarketRemoveResult(removeResult:MarketRemoveResult) : void
      {
         MemMarketRemoveSignal.instance.dispatch(removeResult);
      }

      /* Market */
      private function onMarketMyOffersResult(myOffersResult:MarketMyOffersResult) : void
      {
         MemMarketMyOffersSignal.instance.dispatch(myOffersResult);
      }

      /* Market */
      public function marketSearch(itemType:int) : void
      {
         var search:MarketSearch = this.messages.require(MARKET_SEARCH) as MarketSearch;
         search.itemType_ = itemType;
         this.serverConnection.sendMessage(search);
      }

      /* Market */
      public function marketRemove(id:int) : void
      {
         var remove:MarketRemove = this.messages.require(MARKET_REMOVE) as MarketRemove;
         remove.id_ = id;
         this.serverConnection.sendMessage(remove);
      }

      /* Market */
      public function marketMyOffers() : void
      {
         var myOffers:MarketMyOffers = this.messages.require(MARKET_MY_OFFERS) as MarketMyOffers;
         this.serverConnection.sendMessage(myOffers);
      }

      /* Market */
      public function marketBuy(id:int) : void
      {
         var buy:MarketBuy = this.messages.require(MARKET_BUY) as MarketBuy;
         buy.id_ = id;
         this.serverConnection.sendMessage(buy);
      }

      /* Market */
      public function marketAdd(items:Vector.<int>, price:int, currency:int, hours:int) : void
      {
         var add:MarketAdd = this.messages.require(MARKET_ADD)  as MarketAdd;
         add.slots_= items;
         add.price_ = price;
         add.currency_ = currency;
         add.hours_ = hours;
         this.serverConnection.sendMessage(add);
      }

       private function onInvitedToParty(invitedToParty:InvitedToParty) : void
       {
           this.gs_.hudView.interactPanel.setOverride(new PartyInvitePanel(this.gs_, invitedToParty.name_, invitedToParty.partyId_));
           this.addTextLine.dispatch(new AddTextLineVO("","You have been invited by " + invitedToParty.name_ + " to join to his Party!\n If you wish to join type /paccept " + invitedToParty.partyId_));
       }

       public function joinParty(partyLeader:String, partyId:int) : void
       {
           var joinParty:JoinParty = this.messages.require(JOIN_PARTY) as JoinParty;
           joinParty.leader_ = partyLeader;
           joinParty.partyId = partyId;
           this.serverConnection.sendMessage(joinParty);
       }

   }
}
