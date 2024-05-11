package com.company.assembleegameclient.parameters {
import com.company.util.KeyCodes;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.net.SharedObject;
import flash.utils.Dictionary;

public class Parameters {
    public static const BUILD_VERSION:String = "3";
    public static const MINOR_VERSION:String = "0";
    public static const PATCH_VERSION:String = "0";
    public static const FULL_BUILD_VERSION:String = BUILD_VERSION + "." + MINOR_VERSION + "." + PATCH_VERSION;
    public static const PORT:int = 2050;
    public static const LOCAL_HOST:Boolean = true;
    public static const TESTING_SERVER:Boolean = false;
    public static const FELLOW_GUILD_COLOR:uint = 10944349;
    public static const PARTY_MEMBER_COLOR:uint = 0xffc0cb;
    public static const NAME_CHOSEN_COLOR:uint = 16572160;
    public static const PLAYER_ROTATE_SPEED:Number = 0.003;
    public static const BREATH_THRESH:int = 20;
    public static const SERVER_CHAT_NAME:String = "";
    public static const CLIENT_CHAT_NAME:String = "*Client*";
    public static const ERROR_CHAT_NAME:String = "*Error*";
    public static const HELP_CHAT_NAME:String = "*Help*";
    public static const GUILD_CHAT_NAME:String = "*Guild*";
    public static const PARTY_CHAT_NAME:String = "*Party*";
    public static const NAME_CHANGE_PRICE:int = 100;
    public static const GUILD_CREATION_PRICE:int = 1000;
    public static const NEXUS_GAMEID:int = -2;
    public static const MAPTEST_GAMEID:int = -6;
    public static const MAX_SINK_LEVEL:Number = 18;
    public static const TERMS_OF_USE_URL:String = "https://www.kabam.com/corporate/terms-of-service";
    public static const PRIVACY_POLICY_URL:String = "https://www.kabam.com/corporate/privacy-policy";
    public static const RSA_PUBLIC_KEY:String =
            "-----BEGIN PUBLIC KEY-----\n" +
            "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDTa2VXtjKzQ8HO2hCRuXZPhezl\n" +
            "0HcWdO0QxUhz1b+N5xJIXjvPGYpawLnJHgVgjcTI4dqDW9sthI3hEActKdKV6Zm/\n" +
            "dpPMuCvgEXq1ajOcr8WEX+pDji5kr9ELH0iZjjlvgfzUiOBI6q4ba3SRYiAJFgOo\n" +
            "e1TCC1sDk+rDZEPcMwIDAQAB\n" +
            "-----END PUBLIC KEY-----";
    public static var root:DisplayObject;
    public static var DamageCounter:Array = [];
    public static var data_:Object = null;
    public static var GPURenderError:Boolean = false;
    public static var GPURenderFrame:Boolean = false;
    private static var savedOptions_:SharedObject = null;
    private static var keyNames_:Dictionary = new Dictionary();
    public static const skinTypes16:Vector.<int> = new <int>[1027, 0x0404, 1029, 1030, 10973, 19494, 19531, 6346, 30056, 5505, 7766, 7769, 0x45df, 0x21a6, 0x1b64, 0x0402, 0x4f58, 0x745a, 0x2756, 0x24bf, 0x7a00, 0x21df, 0x24bd, 0x0401, 0x745C, 0xbdc, 0x4b4b, 0x4c04, 0x08fb, 0x1849, 0x745B, 0x4b48, 0x08fd, 0xbc1, 0x4b9d, 0x5b41, 0x4b50];
    public static const itemTypes16:Vector.<int> = new <int>[5473, 5474, 5475, 5476, 10939, 19494, 19531, 6347, 5506];

    public static function load():void {
        try {
            savedOptions_ = SharedObject.getLocal("OSGameClientOptions", "/");
            data_ = savedOptions_.data;
        }
        catch (error:Error) {
            trace("WARNING: unable to save settings");
            data_ = new Object();
        }
        setDefaults();
        save();
    }

    public static function save():void {
        try {
            if (savedOptions_ != null) {
                savedOptions_.flush();
            }
        }
        catch (error:Error) {
        }
    }

    public static function setKey(keyName:String, key:uint):void {
        var otherKeyName:* = null;
        for (otherKeyName in keyNames_) {
            if (data_[otherKeyName] == key) {
                data_[otherKeyName] = KeyCodes.UNSET;
            }
        }
        data_[keyName] = key;
    }

    public static function isGpuRender():Boolean {
        return !GPURenderError && data_.GPURender;
    }

    public static function clearGpuRender():void {
        GPURenderError = true;
    }

    public static function setDefaults():void {
        setDefaultKey("partyJoinWorld", KeyCodes.UNSET);
        setDefaultKey("partyInviteWorld", KeyCodes.UNSET);
        setDefaultKey("partyChat", KeyCodes.P);
        setDefaultKey("uiQualityToggle", KeyCodes.UNSET);
        setDefaultKey("GPURenderToggle", KeyCodes.UNSET);
        setDefaultKey("reconGuildHall", KeyCodes.UNSET);
        setDefaultKey("reconVault", KeyCodes.UNSET);
        setDefaultKey("reconRealm", KeyCodes.UNSET);
        setDefaultKey("moveLeft", KeyCodes.A);
        setDefaultKey("moveRight", KeyCodes.D);
        setDefaultKey("moveUp", KeyCodes.W);
        setDefaultKey("moveDown", KeyCodes.S);
        setDefaultKey("rotateLeft", KeyCodes.Q);
        setDefaultKey("rotateRight", KeyCodes.E);
        setDefaultKey("useSpecial", KeyCodes.SPACE);
        setDefaultKey("interact", KeyCodes.NUMBER_0);
        setDefaultKey("useInvSlot1", KeyCodes.NUMBER_1);
        setDefaultKey("useInvSlot2", KeyCodes.NUMBER_2);
        setDefaultKey("useInvSlot3", KeyCodes.NUMBER_3);
        setDefaultKey("useInvSlot4", KeyCodes.NUMBER_4);
        setDefaultKey("useInvSlot5", KeyCodes.NUMBER_5);
        setDefaultKey("useInvSlot6", KeyCodes.NUMBER_6);
        setDefaultKey("useInvSlot7", KeyCodes.NUMBER_7);
        setDefaultKey("useInvSlot8", KeyCodes.NUMBER_8);
        setDefaultKey("escapeToNexus", KeyCodes.R);
        setDefaultKey("escapeToNexus2", KeyCodes.F5);
        setDefaultKey("autofireToggle", KeyCodes.I);
        setDefaultKey("scrollChatUp", KeyCodes.PAGE_UP);
        setDefaultKey("scrollChatDown", KeyCodes.PAGE_DOWN);
        setDefaultKey("miniMapZoomOut", KeyCodes.MINUS);
        setDefaultKey("miniMapZoomIn", KeyCodes.EQUAL);
        setDefaultKey("resetToDefaultCameraAngle", KeyCodes.UNSET);
        setDefaultKey("togglePerformanceStats", KeyCodes.L);
        setDefaultKey("options", KeyCodes.O);
        setDefaultKey("toggleCentering", KeyCodes.X);
        setDefaultKey("chat", KeyCodes.ENTER);
        setDefaultKey("chatCommand", KeyCodes.SLASH);
        setDefaultKey("tell", KeyCodes.TAB);
        setDefaultKey("guildChat", KeyCodes.G);
        setDefaultKey("testOne", KeyCodes.J);
        setDefaultKey("testTwo", KeyCodes.K);
        setDefaultKey("useHealthPotion", KeyCodes.F);
        setDefaultKey("useMagicPotion", KeyCodes.V);
        setDefaultKey("switchTabs", KeyCodes.B);
        setDefaultKey("refresh_button_servers", KeyCodes.F5);
        setDefault("showStatistics", false);
        setDefault("disableAllParticles", false);
        setDefault("uiQuality", false);
        setDefault("FS", true);
        setDefault("disableAllyParticles", true);
        setDefault("hideList", 0);
        setDefault("cursorSelect", "4");
        setDefault("HPBarcolors", true);
        setDefault("showTierTag", true);
        setDefault("reduceParticles", 2);
        setDefault("itemDataOutlines", 0);
        setDefault("toggleBarText", 1);
        setDefault("sellMaxyPots", 2);
        setDefault("smartProjectiles", false);
        setDefault("projOutline", true);
        setDefault("dynamicHPcolor", true);
        setDefault("playerObjectType", 782);
        //setDefault("playMusic", true);
        setDefault("musicVolume", 0.5);
        setDefault("playSFX", true);
        setDefault("playPewPew", true);
        setDefault("centerOnPlayer", true);
        setDefault("preferredServer", null);
        setDefault("cameraAngle", 7 * Math.PI / 4);
        setDefault("defaultCameraAngle", 7 * Math.PI / 4);
        setDefault("showQuestPortraits", true);
        setDefault("allowRotation", true);
        setDefault("charIdUseMap", {});
        setDefault("drawShadows", true);
        setDefault("textBubbles", true);
        setDefault("showTradePopup", true);
        setDefault("paymentMethod", null);
        setDefault("showGuildInvitePopup", true);
        setDefault("contextualClick", true);
        setDefault("inventorySwap", true);
        setDefault("GPURender", true);
        setDefault("eyeCandyParticles", true);
        setDefault("hpBars", true);
        setDefault("allyShots", true);
        setDefault("allyDamage", true);
        setDefault("noAllyNotifications", false);
        setDefault("fps", 60);
    }

    private static function setDefaultKey(keyName:String, key:uint):void {
        if (!data_.hasOwnProperty(keyName)) {
            data_[keyName] = key;
        }
        keyNames_[keyName] = true;
    }
    public static function parse(str:String):int {
        if (str == null)
            str = "0";
        for (var i:int = 0; i < str.length; i++) {
            var c:String = str.charAt(i);
            if (c != "0") break;
        }

        return int(str.substr(i));
    }
    private static function setDefault(keyName:String, value:*):void {
        if (!data_.hasOwnProperty(keyName)) {
            data_[keyName] = value;
        }
    }

    public function Parameters() {
        super();
    }

    public static function clearGpuRenderEvent(event:Event):void {
        clearGpuRender();
    }
}
}
