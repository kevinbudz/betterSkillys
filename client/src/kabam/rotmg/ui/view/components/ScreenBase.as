package kabam.rotmg.ui.view.components
{
   import com.company.assembleegameclient.ui.SoundIcon;
import com.worlize.gif.GIFPlayer;

import flash.display.Sprite;
import flash.events.Event;
import flash.media.Sound;

import kabam.rotmg.ui.view.TitleView_BackgroundLayer;

import kabam.rotmg.ui.view.TitleView_TitleScreenBackground;

import mx.core.BitmapAsset;

public class ScreenBase extends Sprite
   {
      private static var sprite:Sprite;
      private static var gif:GIFPlayer;
      public function ScreenBase()
      {
         super();
         sprite = new Sprite();
         gif = new GIFPlayer();
         gif.loadBytes(new TitleView_BackgroundLayer());
         sprite.addChild(gif);
         addChild(sprite);
         //addChild(this.darkenFactory.create());
         addChild(new SoundIcon());
      }

      public static function reSize(e:Event):void
      {
         sprite.scaleX = WebMain.STAGE.stageWidth / 800;
         sprite.scaleY = WebMain.STAGE.stageHeight / 600;
      }
   }
}
