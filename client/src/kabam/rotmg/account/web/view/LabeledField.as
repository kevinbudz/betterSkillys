package kabam.rotmg.account.web.view
{
   import com.company.ui.SimpleText;
   import flash.filters.DropShadowFilter;
   
   public class LabeledField extends FormField
   {
       
      
      public var nameText_:SimpleText;
      
      public var inputText_:SimpleText;
      
      public var isHighlighted:Boolean;
      
      public function LabeledField(name:String, isPassword:Boolean, w:uint = 238, h:uint = 30)
      {
         super();
         this.nameText_ = new SimpleText(18,TEXT_COLOR,false,0,0);
         this.nameText_.setBold(true);
         this.nameText_.text = name;
         this.nameText_.updateMetrics();
         this.nameText_.filters = [new DropShadowFilter(0,0,0)];
         addChild(this.nameText_);
         this.inputText_ = new SimpleText(20,TEXT_COLOR,true,w,h);
         this.inputText_.y = 30;
         this.inputText_.x = 6;
         this.inputText_.border = false;
         this.inputText_.displayAsPassword = isPassword;
         this.inputText_.updateMetrics();
         addChild(this.inputText_);
         this.setErrorHighlight(false);
      }
      
      public function text() : String
      {
         return this.inputText_.text;
      }
      
      override public function getHeight() : Number
      {
         return 68;
      }
      
      public function setErrorHighlight(hasError:Boolean) : void
      {
         this.isHighlighted = hasError;
         drawSimpleTextBackground(this.inputText_,0,0,hasError);
      }
   }
}
