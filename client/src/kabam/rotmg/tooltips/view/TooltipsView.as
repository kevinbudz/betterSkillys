package kabam.rotmg.tooltips.view
{
   import com.company.assembleegameclient.ui.tooltip.ToolTip;
   import flash.display.Sprite;
   
   public class TooltipsView extends Sprite
   {
       
      
      private var toolTip:ToolTip;
      
      public function TooltipsView()
      {
         super();
      }
      
      public function show(toolTip:ToolTip) : void
      {
         this.hide();
         this.toolTip = toolTip;
         if(toolTip)
         {
            addChild(toolTip);
         }
      }
      
      public function hide() : void
      {
         if(this.toolTip && this.toolTip.parent)
         {
            this.toolTip.parent.removeChild(this.toolTip);
         }
         this.toolTip = null;
      }
   }
}
