package kabam.rotmg.ui.view.components
{
   import com.company.assembleegameclient.ui.SoundIcon;
   import flash.display.Sprite;
import flash.media.Sound;

import kabam.rotmg.ui.view.TitleView_TitleScreenBackground;

public class ScreenBase extends Sprite
   {
      private var darkenFactory:DarkenFactory;
      
      public function ScreenBase()
      {
         this.darkenFactory = new DarkenFactory();
         super();
         addChild(new TitleView_TitleScreenBackground());
         addChild(this.darkenFactory.create());
         addChild(new SoundIcon());
      }
   }
}
