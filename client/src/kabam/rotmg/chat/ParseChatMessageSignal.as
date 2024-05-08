package kabam.rotmg.chat {
import org.osflash.signals.Signal;

public class ParseChatMessageSignal extends Signal {

    public function ParseChatMessageSignal() {
        super(String);
    }

}
}
