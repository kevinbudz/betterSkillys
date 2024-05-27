package kabam.lib.net.impl {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.utils.ByteArray;

import kabam.lib.net.api.MessageProvider;

import org.osflash.signals.Signal;

public class SocketServer {
    public static const MESSAGE_LENGTH_SIZE_IN_BYTES:int = 4;

    public const connected:Signal = new Signal();
    public const closed:Signal = new Signal();
    public const error:Signal = new Signal(String);

    private const unsentPlaceholder:Message = new Message(0);
    private const data:ByteArray = new ByteArray();

    private static function logError(message:Message = null, error:Error = null):void
    {
        trace("Socket-Server Protocol Error!" + (!message ? " Unknown message." : ""));

        if (message)
            trace("\t- Message " + message.id + ": " + message.toString());

        if (error != null) {
            trace("Error:");
            trace("\t- ID: " + error.errorID);
            trace("\t- Name: " + error.name);
            trace("\t- Message: " + error.message);
            trace("\t- StackTrace: ");
            trace(error.getStackTrace());
        }
    }

    private static function parseString(error:String, arguments:Array):String {
        var count:int = arguments.length;

        for (var i:int = 0; i < count; i++)
            error = error.replace("{" + i + "}", arguments[i]);

        return error;
    }

    public function SocketServer() {
        head = unsentPlaceholder;
        tail = unsentPlaceholder;
    }

    [Inject]
    public var messages:MessageProvider;
    [Inject]
    public var socket:Socket;
    private var server:String;
    private var port:int;
    private var head:Message;
    private var tail:Message;
    private var messageLen:int = -1;

    public function connect(address:String, port:int):void {
        server = address;
        port = port;

        addListeners();

        messageLen = -1;
        socket.connect(address, port);
    }

    public function disconnect():void {
        if (socket.connected)
            socket.close();

        removeListeners();

        closed.dispatch();
    }

    public function sendMessage(message:Message):void {
        tail.next = message;
        tail = message;
        socket.connected && sendPendingMessages();
    }

    private function addListeners():void {
        socket.addEventListener(Event.CONNECT, onConnect);
        socket.addEventListener(Event.CLOSE, onClose);
        socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
        socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
    }

    private function removeListeners():void {
        socket.removeEventListener(Event.CONNECT, onConnect);
        socket.removeEventListener(Event.CLOSE, onClose);
        socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
        socket.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
        socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
    }

    private function sendPendingMessages():void {

        var first:Message = head.next;
        for(var message:Message = first; message != null; message = message.next)
        {
            data.clear();
            message.writeToOutput(data);
            data.position = 0;

            socket.writeInt(data.bytesAvailable + 5);
            socket.writeByte(message.id);
            socket.writeBytes(data);

            message.consume();
        }

        socket.flush();

        unsentPlaceholder.next = null;
        unsentPlaceholder.prev = null;
        head = tail = unsentPlaceholder;
    }

    private function onConnect(event:Event):void {
        sendPendingMessages();
        connected.dispatch();
    }

    private function onClose(event:Event):void {
        closed.dispatch();
    }

    private function onIOError(event:IOErrorEvent):void {
        var errMsg:String;

        if (event.errorID === 2031)
            errMsg = "The server is offline right now, retrying to connect...";
        else
            errMsg = parseString("Socket-Server IO Error: {0}", [event.text]);

        trace(errMsg);

        error.dispatch(errMsg);
        closed.dispatch();
    }

    private function onSecurityError(event:SecurityErrorEvent):void {
        var errMsg:String = parseString("Socket-Server Security: {0}. Please open port {1} in your firewall and/or router settings and try again", [event.text, Parameters.TESTING_SERVER ? Parameters.TESTING_PORT : Parameters.PORT]);
        trace(errMsg);

        error.dispatch(errMsg);
        closed.dispatch();
    }

    private function onSocketData(_:ProgressEvent = null):void
    {

        while (true) {
            if (socket === null || !socket.connected)
                break;

            if (messageLen === -1)
            {
                if (socket.bytesAvailable < MESSAGE_LENGTH_SIZE_IN_BYTES)
                    break;

                try 
                {
                    messageLen = socket.readInt();
                } 
                catch (e:Error)
                {
                    var errorMessage:String = parseString("Socket-Server Data Error: {0}\n{1}", [e.name, e.message]);

                    trace(errorMessage);

                    error.dispatch(errorMessage);
                    messageLen = -1;
                    break;
                }
            }

            if (socket.bytesAvailable < messageLen - MESSAGE_LENGTH_SIZE_IN_BYTES)
                break;

            var messageId:uint = socket.readUnsignedByte();
            var message:Message = messages.require(messageId);
            var data:ByteArray = new ByteArray();
            if (messageLen - 5 > 0)
                socket.readBytes(data, 0, messageLen - 5);

            messageLen = -1;

            if (message == null)
            {
                logError();
                break;
            }

            try
            {
                message.parseFromInput(data);
            }
            catch (e:Error)
            {
                logError(message, e);
                break;
            }

            message.consume();
        }
    }
}
}
