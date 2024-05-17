package kabam.rotmg.ui.view
{
   import com.company.assembleegameclient.screens.ServersScreen;

import flash.events.Event;

import kabam.lib.tasks.DispatchSignalTask;

import kabam.lib.tasks.TaskMonitor;
import kabam.lib.tasks.TaskSequence;
import kabam.rotmg.core.signals.SetScreenSignal;
   import kabam.rotmg.servers.api.ServerModel;
import kabam.rotmg.servers.services.GetServerListTask;

import robotlegs.bender.bundles.mvcs.Mediator;

   public class ServersMediator extends Mediator
   {


      [Inject]
      public var view:ServersScreen;

      [Inject]
      public var servers:ServerModel;

      [Inject]
      public var setScreen:SetScreenSignal;

      [Inject]
      public var monitor:TaskMonitor;

      public function ServersMediator()
      {
         super();
      }

      override public function initialize() : void
      {
         this.view.gotoTitle.add(this.onGotoTitle);
         this.view.initialize(this.servers.getServers());
      }

      override public function destroy() : void
      {
         if (WebMain.STAGE)
            WebMain.STAGE.addEventListener(Event.RESIZE, this.view.positionAssets);
         this.view.gotoTitle.remove(this.onGotoTitle);
      }

      private function onGotoTitle() : void
      {
         this.setScreen.dispatch(new TitleView());
      }
   }
}
