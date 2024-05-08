package com.company.assembleegameclient.ui.panels
{
   import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextBox;
import com.company.assembleegameclient.ui.guild.GuildChronicleScreen;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
   
   public class GuildChroniclePanel extends ButtonPanel
   {
       
      
      public function GuildChroniclePanel(gs:GameSprite)
      {
         super(gs,"Guild Chronicle","View");
      }
      
      override protected function onButtonClick(event:MouseEvent) : void
      {
         gs_.mui_.clearInput();
         this.openDialog.dispatch(new GuildChronicleScreen(gs_));
      }

      override protected function onKeyDown(event:KeyboardEvent) : void
      {
         if(event.keyCode == Parameters.data_.interact && !TextBox.isInputtingText){
            gs_.mui_.clearInput();
            this.openDialog.dispatch(new GuildChronicleScreen(gs_));
         }
      }
   }
}
