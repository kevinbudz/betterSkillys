package com.company.assembleegameclient.mapeditor
{
   import com.company.assembleegameclient.editor.CommandEvent;
   import com.company.assembleegameclient.editor.CommandMenu;
   import com.company.assembleegameclient.editor.CommandMenuItem;
   import com.company.util.KeyCodes;
   
   public class MECommandMenu extends CommandMenu
   {
      
      public static const NONE_COMMAND:int = 0;
      
      public static const DRAW_COMMAND:int = 1;
      
      public static const ERASE_COMMAND:int = 2;
      
      public static const SAMPLE_COMMAND:int = 3;
      
      public static const EDIT_COMMAND:int = 4;
       
      
      public function MECommandMenu()
      {
         super();
         addCommandMenuItem("(D)raw",KeyCodes.D,this.select,DRAW_COMMAND);
         addCommandMenuItem("(E)rase",KeyCodes.E,this.select,ERASE_COMMAND);
         addCommandMenuItem("S(A)mple",KeyCodes.A,this.select,SAMPLE_COMMAND);
         addCommandMenuItem("Ed(I)t",KeyCodes.I,this.select,EDIT_COMMAND);
         addCommandMenuItem("(U)ndo",KeyCodes.U,this.onUndo,NONE_COMMAND);
         addCommandMenuItem("(R)edo",KeyCodes.R,this.onRedo,NONE_COMMAND);
         addCommandMenuItem("(C)lear",KeyCodes.C,this.onClear,NONE_COMMAND);
         addBreak();
         addCommandMenuItem("(L)oad",KeyCodes.L,this.onLoad,NONE_COMMAND);
         addCommandMenuItem("(S)ave",KeyCodes.S,this.onSave,NONE_COMMAND);
         addCommandMenuItem("(T)est",KeyCodes.T,this.onTest,NONE_COMMAND);
      }
      
      private function select(item:CommandMenuItem) : void
      {
         setSelected(item);
      }
      
      private function onUndo(item:CommandMenuItem) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.UNDO_COMMAND_EVENT));
      }
      
      private function onRedo(item:CommandMenuItem) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.REDO_COMMAND_EVENT));
      }
      
      private function onClear(item:CommandMenuItem) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.CLEAR_COMMAND_EVENT));
      }
      
      private function onLoad(item:CommandMenuItem) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.LOAD_COMMAND_EVENT));
      }
      
      private function onSave(item:CommandMenuItem) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.SAVE_COMMAND_EVENT));
      }
      
      private function onTest(item:CommandMenuItem) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.TEST_COMMAND_EVENT));
      }
   }
}
