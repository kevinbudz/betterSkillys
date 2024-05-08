package kabam.rotmg.legends.view
{
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import kabam.rotmg.legends.model.Timespan;
   import org.osflash.signals.Signal;
   
   public class LegendsTab extends Sprite
   {
      
      private static const OVER_COLOR:int = 16567065;
      
      private static const DOWN_COLOR:int = 16777215;
      
      private static const OUT_COLOR:int = 11711154;
       
      
      public const selected:Signal = new Signal(LegendsTab);
      
      private var timespan:Timespan;
      
      private var label:SimpleText;
      
      private var isOver:Boolean;
      
      private var isDown:Boolean;
      
      private var isSelected:Boolean;
      
      public function LegendsTab(timespan:Timespan)
      {
         super();
         this.timespan = timespan;
         this.makeLabel(timespan);
         this.addMouseListeners();
         this.redraw();
      }
      
      public function getTimespan() : Timespan
      {
         return this.timespan;
      }
      
      private function makeLabel(timespan:Timespan) : void
      {
         this.label = new SimpleText(20,16777215,false,0,0);
         this.label.setBold(true);
         this.label.text = timespan.getName();
         this.label.updateMetrics();
         this.label.x = 2;
         addChild(this.label);
      }
      
      private function addMouseListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      private function onClick(event:MouseEvent) : void
      {
         this.selected.dispatch(this);
      }
      
      private function redraw() : void
      {
         if(this.isOver)
         {
            this.label.setColor(OVER_COLOR);
         }
         else if(this.isSelected || this.isDown)
         {
            this.label.setColor(DOWN_COLOR);
         }
         else
         {
            this.label.setColor(OUT_COLOR);
         }
      }
      
      public function setIsSelected(isSelected:Boolean) : void
      {
         this.isSelected = isSelected;
         this.redraw();
      }
      
      private function onMouseOver(event:MouseEvent) : void
      {
         this.isOver = true;
         this.redraw();
      }
      
      private function onMouseOut(event:MouseEvent) : void
      {
         this.isOver = false;
         this.isDown = false;
         this.redraw();
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         this.isDown = true;
         this.redraw();
      }
      
      private function onMouseUp(event:MouseEvent) : void
      {
         this.isDown = false;
         this.redraw();
      }
   }
}
