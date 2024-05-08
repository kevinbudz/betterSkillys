package kabam.rotmg.servers.services {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.dialogs.Dialog;
import com.company.util.MoreObjectUtil;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import kabam.lib.tasks.BaseTask;
import kabam.rotmg.account.core.Account;
import kabam.rotmg.account.core.signals.CharListDataSignal;
import kabam.rotmg.account.web.WebAccount;
import kabam.rotmg.appengine.api.AppEngineClient;
import kabam.rotmg.core.model.PlayerModel;
import kabam.rotmg.core.signals.SetLoadingMessageSignal;
import kabam.rotmg.dialogs.control.CloseDialogsSignal;
import kabam.rotmg.dialogs.control.OpenDialogSignal;
import kabam.rotmg.servers.signals.RefreshServerSignal;
import kabam.rotmg.ui.noservers.NoServersDialogFactory;

import robotlegs.bender.framework.api.ILogger;

public class GetServerListTask extends BaseTask
{
    [Inject]
    public var client:AppEngineClient;

    [Inject]
    public var refreshServerSignal:RefreshServerSignal;

    [Inject]
    public var closeDialogs:CloseDialogsSignal;

    [Inject]
    public var openDialog:OpenDialogSignal;

    [Inject]
    public var noServersDialogFactory:NoServersDialogFactory;

    [Inject]
    public var logger:ILogger;

    private var requestData:Object;

    public function GetServerListTask()
    {
        super();
    }

    override protected function startTask() : void
    {
        this.logger.info("GetServerList start");
        this.requestData = {};
        this.sendRequest();
    }

    private function sendRequest() : void
    {
        this.client.setSendEncrypted(true);
        this.client.complete.addOnce(this.onComplete);
        this.client.sendRequest("/app/serverList", this.requestData);
    }

    private function onComplete(isOK:Boolean, data:*) : void
    {
        if(isOK)
        {
            this.onListComplete(data);
        }
        else
        {
            this.onTextError(data);
        }
        completeTask(true);
    }

    private function onListComplete(data:String) : void
    {
        this.refreshServerSignal.dispatch(XML(data));
        completeTask(true);
    }

    private function showNoServersDialog():void
    {
        var dialog:Dialog = this.noServersDialogFactory.makeDialog();
        dialog.addEventListener(Dialog.BUTTON1_EVENT, this.closeDialog);
        this.openDialog.dispatch(dialog);
    }

    private function closeDialog(_arg1:Event):void
    {
        this.closeDialogs.dispatch();
    }

    private function onTextError(error:String) : void
    {
        this.showNoServersDialog();
    }
}
}
