package kabam.rotmg.game.view.components
{
   import com.company.assembleegameclient.ui.tooltip.TextToolTip;
   import com.company.ui.SimpleText;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFormat;
   import org.osflash.signals.natives.NativeSignal;
   
   public class StatView extends Sprite
   {
       
      
      public var fullName_:String;
      
      public var description_:String;
      
      public var nameText_:SimpleText;
      
      public var valText_:SimpleText;
      
      public var redOnZero_:Boolean;
      
      public var val_:int = -1;
      
      public var boost_:int = -1;
      
      public var valColor_:uint = 11776947;

      public var max_:int = -1;

      public var level_:int = 0;
      
      public var toolTip_:TextToolTip;
      
      public var mouseOver:NativeSignal;
      
      public var mouseOut:NativeSignal;
      
      public function StatView(name:String, fullName:String, desc:String, redOnZero:Boolean)
      {
         this.toolTip_ = new TextToolTip(3552822,10197915,"","",200);
         super();
         this.fullName_ = fullName;
         this.description_ = desc;
         this.nameText_ = new SimpleText(13,11776947,false,0,0);
         this.nameText_.text = name + " -";
         this.nameText_.updateMetrics();
         this.nameText_.x = -this.nameText_.width;
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.nameText_);
         this.valText_ = new SimpleText(13,this.valColor_,false,0,0);
         this.valText_.setBold(true);
         this.valText_.text = "-";
         this.valText_.updateMetrics();
         this.valText_.filters = [new DropShadowFilter(0,0,0)];
         this.valText_.y = -3;
         addChild(this.valText_);
         this.redOnZero_ = redOnZero;
         this.mouseOver = new NativeSignal(this,MouseEvent.MOUSE_OVER,MouseEvent);
         this.mouseOut = new NativeSignal(this,MouseEvent.MOUSE_OUT,MouseEvent);
      }
      
      public function addTooltip() : void
      {
         this.toolTip_.setTitle(this.fullName_);
         this.toolTip_.setText(this.description_);
         if(!stage.contains(this.toolTip_))
         {
            stage.addChild(this.toolTip_);
         }
      }
      
      public function removeTooltip() : void
      {
         if(this.toolTip_.parent != null)
         {
            this.toolTip_.parent.removeChild(this.toolTip_);
         }
      }


      public function draw(val:int, boost:int, max:int, postMax:int = 0, level:int = 0) : void
      {
         var _loc5_:uint = 0;
         if(postMax == this.level_ && val == this.val_ && boost == this.boost_)
         {
            return;
         }
         this.val_ = val;
         this.boost_ = boost;
         this.max_ = max;
         this.level_ = level;
         if(postMax >= 10)
         {
            _loc5_ = 0x00ff88;
         }
         else if(val - boost >= max)
         {
            _loc5_ = 16572160;
         }
         else if(this.redOnZero_ && this.val_ <= 0 || this.boost_ < 0)
         {
            _loc5_ = 16726072;
         }
         else if(this.boost_ > 0)
         {
            _loc5_ = 6206769;
         }
         else
         {
            _loc5_ = 11776947;
         }
         if(this.valColor_ != _loc5_)
         {
            this.valColor_ = _loc5_;
            this.valText_.setColor(this.valColor_);
         }
         this.setNewText();
      }
      /*public function draw(val:int, boost:int, max:int) : void
      {
         var newValColor:uint = 0;
         var format:TextFormat = null;
         if(val == this.val_ && boost == this.boost_)
         {
            return;
         }
         this.val_ = val;
         this.boost_ = boost;
         if(val - boost >= max)
         {
            newValColor = 16572160;
         }
         else if(this.redOnZero_ && this.val_ <= 0 || this.boost_ < 0)
         {
            newValColor = 16726072;
         }
         else if(this.boost_ > 0)
         {
            newValColor = 6206769;
         }
         else
         {
            newValColor = 11776947;
         }
         if(this.valColor_ != newValColor)
         {
            this.valColor_ = newValColor;
            format = this.valText_.defaultTextFormat;
            format.color = this.valColor_;
            this.valText_.setTextFormat(format);
            this.valText_.defaultTextFormat = format;
         }
         this.valText_.text = this.val_.toString();
         if(this.boost_ != 0)
         {
            this.valText_.text = this.valText_.text + (" (" + (this.boost_ > 0?"+":"") + this.boost_.toString() + ")");
         }
         this.valText_.updateMetrics();
      }*/

      public function setNewText() : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = this.val_.toString();
         _loc3_ = this.max_ - (this.val_ - this.boost_);
         if(this.level_ >= 20 && _loc3_ > 0)
         {
            _loc2_ = _loc2_ + ("|" + _loc3_.toString());
         }
         if(this.boost_ != 0)
         {
            _loc2_ = _loc2_ + (" (" + (this.boost_ > 0?"+":"") + this.boost_.toString() + ")");
         }
         this.valText_.setText(_loc2_);
         this.valText_.updateMetrics();
      }
   }
}
