package com.company.assembleegameclient.account.ui.components
{
   public class SelectionGroup
   {
       
      
      private var selectables:Vector.<Selectable>;
      
      private var selected:Selectable;
      
      public function SelectionGroup(elements:Vector.<Selectable>)
      {
         super();
         this.selectables = elements;
      }
      
      public function setSelected(value:String) : void
      {
         var selected:Selectable = null;
         for each(selected in this.selectables)
         {
            if(selected.getValue() == value)
            {
               this.replaceSelected(selected);
               return;
            }
         }
      }
      
      public function getSelected() : Selectable
      {
         return this.selected;
      }
      
      private function replaceSelected(selectable:Selectable) : void
      {
         if(this.selected != null)
         {
            this.selected.setSelected(false);
         }
         this.selected = selectable;
         this.selected.setSelected(true);
      }
   }
}
