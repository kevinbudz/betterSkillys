package kabam.rotmg.maploading.view
{
   import com.company.assembleegameclient.screens.UnpackEmbed;
   import com.company.ui.SimpleText;
   import com.gskinner.motion.GTween;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import kabam.rotmg.assets.model.Animation;
   
   public class MapLoadingView extends Sprite
   {
      public static const MINIMUM_DISPLAY_TIME:Number = 1000;
      public static const MAX_DIFFICULTY:int = 5;
      public static const FADE_OUT_TIME:Number = 0.4;
      
      public var MapLoadingSymbol:Class;
      private var screen:DisplayObjectContainer;
      private var mapNameField:SimpleText;
      private var indicators:Vector.<DisplayObject>;
      private var diffRow:MovieClip;
      private var charContainer:MovieClip;
      private var mapHasLoaded:Boolean;
      private var asset:UnpackEmbed;
      private var dataIsSet:Boolean;
      private var background:MovieClip;
      private var mapName:String;
      private var difficulty:int;
      private var animation:Animation;
      private const minimumDisplayTimer:Timer = new Timer(MINIMUM_DISPLAY_TIME,1);
      private var minimumTimeElapsed:Boolean;
      
      public function MapLoadingView()
      {
         this.MapLoadingSymbol = MapLoadingView_MapLoadingSymbol;
         super();
         this.asset = new UnpackEmbed(this.MapLoadingSymbol);
         this.asset.ready.addOnce(this.onLoadScreen);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onLoadScreen(asset:UnpackEmbed) : void
      {
         var mapNameContainer:MovieClip = null;
         this.screen = asset.content as MovieClip;
         this.background = this.screen.getChildByName("background") as MovieClip;
         mapNameContainer = this.screen.getChildByName("mapNameContainer") as MovieClip;
         this.mapNameField = new SimpleText(30,16777215,false,0,0);
         this.mapNameField.setBold(true);
         this.mapNameField.autoSize = TextFieldAutoSize.CENTER;
         this.mapNameField.updateMetrics();
         this.mapNameField.x = mapNameContainer.x;
         this.mapNameField.y = mapNameContainer.y;
         this.screen.addChild(this.mapNameField);
         this.charContainer = this.screen.getChildByName("charContainer") as MovieClip;
         this.diffRow = this.screen.getChildByName("difficulty_indicators") as MovieClip;
         this.indicators = new Vector.<DisplayObject>(MAX_DIFFICULTY);
         for(var i:int = 1; i <= MAX_DIFFICULTY; i++)
         {
            this.indicators[i - 1] = this.diffRow.getChildByName("indicator_" + i);
         }
         addChild(this.screen);
         this.setValues();
      }
      
      public function display(mapName:String, difficulty:int, animation:Animation) : void
      {
         this.mapName = Boolean(mapName)?mapName:"";
         this.difficulty = difficulty;
         this.animation = animation;
         this.dataIsSet = true;
         this.startMinimumDisplayTimer();
         this.setValues();
      }
      
      private function startMinimumDisplayTimer() : void
      {
         this.minimumDisplayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onMinimumTimeElapsed);
         this.minimumDisplayTimer.start();
      }
      
      private function onMinimumTimeElapsed(event:TimerEvent) : void
      {
         if(this.mapHasLoaded)
         {
            this.beginFadeOut();
         }
         else
         {
            this.minimumTimeElapsed = true;
         }
      }
      
      private function setValues() : void
      {
         var i:int = 0;
         if(this.screen && this.dataIsSet)
         {
            this.mapNameField.text = this.mapName;
            if(this.difficulty <= 0)
            {
               this.screen.getChildByName("bgGroup").visible = false;
               this.diffRow.visible = false;
            }
            else
            {
               this.screen.getChildByName("bgGroup").visible = true;
               this.diffRow.visible = true;
               i = 0;
               while(i < MAX_DIFFICULTY)
               {
                  this.indicators[i].visible = i < this.difficulty;
                  i++;
               }
            }
            if(this.animation)
            {
               this.animation.start();
               addChild(this.animation);
               this.animation.x = this.charContainer.x - this.animation.width * 0.5 + 5;
               this.animation.y = this.charContainer.y - this.animation.height * 0.5;
            }
         }
      }
      
      public function disable() : void
      {
         if(this.minimumTimeElapsed)
         {
            this.beginFadeOut();
         }
         else
         {
            this.mapHasLoaded = true;
         }
      }
      
      private function beginFadeOut() : void
      {
         var tween:GTween = new GTween(this,FADE_OUT_TIME,{"alpha":0});
         tween.onComplete = this.onFadeOutComplete;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      private function onFadeOutComplete(gTween:GTween) : void
      {
         parent && parent.removeChild(this);
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         this.animation && this.animation.dispose();
         this.animation = null;
      }
   }
}
