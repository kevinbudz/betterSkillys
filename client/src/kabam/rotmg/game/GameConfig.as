package kabam.rotmg.game
{
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.map.Map;
import com.company.assembleegameclient.map.MapMediator;
import com.company.assembleegameclient.map.QueueStatusTextSignal;
import com.company.assembleegameclient.map.mapoverlay.MapOverlay;
import com.company.assembleegameclient.ui.GameObjectStatusPanel;
import com.company.assembleegameclient.ui.TextBox;
import com.company.assembleegameclient.ui.panels.InteractPanel;
import com.company.assembleegameclient.ui.panels.PortalPanel;
import com.company.assembleegameclient.ui.panels.itemgrids.InventoryGrid;
import com.company.assembleegameclient.ui.panels.itemgrids.ItemGrid;
import com.company.assembleegameclient.ui.panels.mediators.InteractPanelMediator;
import com.company.assembleegameclient.ui.panels.mediators.InventoryGridMediator;
import com.company.assembleegameclient.ui.panels.mediators.ItemGridMediator;
import kabam.rotmg.application.api.ApplicationSetup;
import kabam.rotmg.chat.ParseChatMessageCommand;
import kabam.rotmg.chat.ParseChatMessageSignal;
import kabam.rotmg.core.signals.AppInitDataReceivedSignal;
import kabam.rotmg.game.commands.ParsePotionDataCommand;
import kabam.rotmg.game.commands.PlayGameCommand;
import kabam.rotmg.game.commands.TransitionFromGameToMenuCommand;
import kabam.rotmg.game.commands.UseBuyPotionCommand;
import kabam.rotmg.game.focus.GameFocusConfig;
import kabam.rotmg.game.model.ChatFilter;
import kabam.rotmg.game.model.GameModel;
import kabam.rotmg.game.signals.AddSpeechBalloonSignal;
import kabam.rotmg.game.signals.AddTextLineSignal;
import kabam.rotmg.game.signals.DisconnectGameSignal;
import kabam.rotmg.game.signals.ExitGameSignal;
import kabam.rotmg.game.signals.GameClosedSignal;
import kabam.rotmg.game.signals.PlayGameSignal;
import kabam.rotmg.game.signals.SetTextBoxVisibilitySignal;
import kabam.rotmg.game.signals.SetWorldInteractionSignal;
import kabam.rotmg.game.signals.UseBuyPotionSignal;
import kabam.rotmg.game.view.CreditDisplay;
import kabam.rotmg.game.view.CreditDisplayMediator;
import kabam.rotmg.game.view.GameSpriteMediator;
import kabam.rotmg.game.view.MapOverlayMediator;
import kabam.rotmg.game.view.MoneyChangerPanel;
import kabam.rotmg.game.view.MoneyChangerPanelMediator;
import kabam.rotmg.game.view.PortalPanelMediator;
import kabam.rotmg.game.view.SellableObjectPanel;
import kabam.rotmg.game.view.SellableObjectPanelMediator;
import kabam.rotmg.game.view.TextBoxMediator;
import kabam.rotmg.game.view.components.StatMediator;
import kabam.rotmg.game.view.components.StatView;
import kabam.rotmg.game.view.components.StatsMediator;
import kabam.rotmg.game.view.components.StatsView;
import kabam.rotmg.game.view.components.TabStripMediator;
import kabam.rotmg.game.view.components.TabStripView;
import kabam.rotmg.storage.PotionStorageModal;
import kabam.rotmg.storage.PotionStorageModalMediator;
import kabam.rotmg.ui.model.TabStripModel;
import kabam.rotmg.ui.view.GameObjectStatusPanelMediator;

import org.swiftsuspenders.Injector;

import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IContext;

public class GameConfig implements IConfig
   {
       
      
      [Inject]
      public var context:IContext;
      
      [Inject]
      public var injector:Injector;
      
      [Inject]
      public var mediatorMap:IMediatorMap;
      
      [Inject]
      public var commandMap:ISignalCommandMap;
      
      [Inject]
      public var setup:ApplicationSetup;
      
      public function GameConfig()
      {
         super();
      }
      
      public function configure() : void
      {
         this.context.configure(GameFocusConfig);
         this.injector.map(GameModel).asSingleton();
         this.generalGameConfiguration();
      }
      
      private function generalGameConfiguration() : void
      {
         this.injector.map(SetWorldInteractionSignal).asSingleton();
         this.injector.map(AddTextLineSignal).asSingleton();
         this.injector.map(SetTextBoxVisibilitySignal).asSingleton();
         this.injector.map(AddSpeechBalloonSignal).asSingleton();
         this.injector.map(ChatFilter).asSingleton();
         this.injector.map(DisconnectGameSignal).asSingleton();
         this.injector.map(TabStripModel).asSingleton();
         this.injector.map(ExitGameSignal).asSingleton();
         this.injector.map(QueueStatusTextSignal).asSingleton();
         this.makeStatusDisplayMappings();
         this.mediatorMap.map(PortalPanel).toMediator(PortalPanelMediator);
         this.mediatorMap.map(GameObjectStatusPanel).toMediator(GameObjectStatusPanelMediator);
         this.mediatorMap.map(InteractPanel).toMediator(InteractPanelMediator);
         this.mediatorMap.map(ItemGrid).toMediator(ItemGridMediator);
         this.mediatorMap.map(InventoryGrid).toMediator(InventoryGridMediator);
         this.mediatorMap.map(TextBox).toMediator(TextBoxMediator);
         this.mediatorMap.map(MapOverlay).toMediator(MapOverlayMediator);
         this.mediatorMap.map(Map).toMediator(MapMediator);
         this.mediatorMap.map(StatView).toMediator(StatMediator);
         this.mediatorMap.map(StatsView).toMediator(StatsMediator);
         this.mediatorMap.map(TabStripView).toMediator(TabStripMediator);
         this.commandMap.map(AppInitDataReceivedSignal).toCommand(ParsePotionDataCommand);
         this.commandMap.map(UseBuyPotionSignal).toCommand(UseBuyPotionCommand);
         this.commandMap.map(GameClosedSignal).toCommand(TransitionFromGameToMenuCommand);
         this.commandMap.map(PlayGameSignal).toCommand(PlayGameCommand);
         this.commandMap.map(ParseChatMessageSignal).toCommand(ParseChatMessageCommand);
      }

      private function makeStatusDisplayMappings() : void
      {
         this.mediatorMap.map(GameSprite).toMediator(GameSpriteMediator);
         this.mediatorMap.map(CreditDisplay).toMediator(CreditDisplayMediator);
         this.mediatorMap.map(MoneyChangerPanel).toMediator(MoneyChangerPanelMediator);
         this.mediatorMap.map(SellableObjectPanel).toMediator(SellableObjectPanelMediator);
      }
   }
}
