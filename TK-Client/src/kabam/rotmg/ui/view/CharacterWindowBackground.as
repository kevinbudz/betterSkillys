package kabam.rotmg.ui.view
{
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Bitmap;
import flash.display.Sprite;

public class CharacterWindowBackground extends Sprite
   {
       
      
      public function CharacterWindowBackground()
      {
         var bg:Sprite = new Sprite();
         bg.graphics.beginFill(0x3F3F3F);
         bg.graphics.drawRect(0,0,200,2500);
         addChild(bg);
      }
   }
}
