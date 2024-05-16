package kabam.rotmg.ui.view.components
{
   import com.company.assembleegameclient.ui.SoundIcon;
   import flash.display.Sprite;
import flash.events.Event;
import flash.media.Sound;

import kabam.rotmg.ui.view.TitleView_TitleScreenBackground;

import mx.core.BitmapAsset;

public class ScreenBase extends Sprite
   {
      private static var graphic:BitmapAsset;
      public function ScreenBase()
      {
         super();
         graphic = new TitleView_TitleScreenBackground();
         graphic.scaleX = WebMain.STAGE.stageWidth / 800;
         graphic.scaleY = WebMain.STAGE.stageHeight / 600;
         addChild(graphic);
         //addChild(this.darkenFactory.create());
         addChild(new SoundIcon());
      }

      public static function reSize(e:Event):void
      {
         graphic.scaleX = WebMain.STAGE.stageWidth / 800;
         graphic.scaleY = WebMain.STAGE.stageHeight / 600;
      }
   }
}
