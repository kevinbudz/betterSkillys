package com.company.assembleegameclient.editor
{
   public class CommandList
   {
       
      
      private var list_:Vector.<Command>;
      
      public function CommandList()
      {
         this.list_ = new Vector.<Command>();
         super();
      }
      
      public function empty() : Boolean
      {
         return this.list_.length == 0;
      }
      
      public function addCommand(command:Command) : void
      {
         this.list_.push(command);
      }
      
      public function execute() : void
      {
         var command:Command = null;
         for each(command in this.list_)
         {
            command.execute();
         }
      }
      
      public function unexecute() : void
      {
         var command:Command = null;
         for each(command in this.list_)
         {
            command.unexecute();
         }
      }
   }
}
