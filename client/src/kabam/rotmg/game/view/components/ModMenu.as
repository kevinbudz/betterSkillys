package kabam.rotmg.game.view.components {
import com.company.assembleegameclient.game.GameSprite;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;
import flash.ui.Keyboard;

public class ModMenu extends Sprite
{
    public static const displayNames:Array = ["God", "Hide", "Kick", "Ban", "Give", "Gift", "Damaging", "Berserk", "Spawn"];
    public static const autoRun:Array = [true, true, false, false, false, false, true, true, false];
    public static const commands:Array = ["/eff invincible", "/hide", "/kick", "/ban", "/give", "/gift", "/eff damaging", "/eff berserk", "/spawn"];

    private var gs:GameSprite;

    private var textWindow:Vector.<SimpleText>;
    private var textContainers:Vector.<Sprite>;

    public function ModMenu(gs:GameSprite)
    {
        this.gs = gs;
        this.textWindow = new Vector.<SimpleText>();
        this.textContainers = new Vector.<Sprite>();
        this.makeText();
    }

    public function makeText():void
    {
        for (var i:int = 0; i < displayNames.length; i++)
        {
            this.textWindow[i] = new SimpleText(14, 0xffffff, false, 800, 0);
            this.textWindow[i].setBold(true);
            this.textWindow[i].autoSize = TextFieldAutoSize.LEFT;
            this.textWindow[i].setText("• " + displayNames[i]);

            this.textContainers[i] = new Sprite();
            this.textContainers[i].x = 90 * int(i % 2);
            this.textContainers[i].y = 20 * int(i / 2);

            this.textWindow.push(this.textWindow[i]);
            this.textContainers.push(this.textContainers[i]);

            addChild(this.textContainers[i]);
            this.textContainers[i].addChild(this.textWindow[i]);
        }

        // adding listeners thru. the for statement doesn't work what the fuck !!!!
        this.textContainers[0].addEventListener(MouseEvent.CLICK, function(e:Event):void { setCommand(0) });
        this.textContainers[1].addEventListener(MouseEvent.CLICK, function(e:Event):void { setCommand(1) });
        this.textContainers[2].addEventListener(MouseEvent.CLICK, function(e:Event):void { setCommand(2) });
        this.textContainers[3].addEventListener(MouseEvent.CLICK, function(e:Event):void { setCommand(3) });
        this.textContainers[4].addEventListener(MouseEvent.CLICK, function(e:Event):void { setCommand(4) });
        this.textContainers[5].addEventListener(MouseEvent.CLICK, function(e:Event):void { setCommand(5) });
        this.textContainers[6].addEventListener(MouseEvent.CLICK, function(e:Event):void { setCommand(6) });
        this.textContainers[7].addEventListener(MouseEvent.CLICK, function(e:Event):void { setCommand(7) });
        this.textContainers[8].addEventListener(MouseEvent.CLICK, function(e:Event):void { setCommand(8) });
    }

    public function setCommand(index:int):void
    {
        if (autoRun[index] == true)
            this.gs.gsc_.playerText(commands[index]);
        else
            this.gs.textBox_.selectInput(commands[index]);
    }
}
}
