package com.company.assembleegameclient.tutorial
{
   public class Step
   {
       
      
      public var text_:String;
      
      public var action_:String;
      
      public var uiDrawBoxes_:Vector.<UIDrawBox>;
      
      public var uiDrawArrows_:Vector.<UIDrawArrow>;
      
      public var reqs_:Vector.<Requirement>;
      
      public var satisfiedSince_:int = 0;
      
      public function Step(stepXML:XML)
      {
         var uiDrawBoxXML:XML = null;
         var uiDrawArrowXML:XML = null;
         var reqXML:XML = null;
         this.uiDrawBoxes_ = new Vector.<UIDrawBox>();
         this.uiDrawArrows_ = new Vector.<UIDrawArrow>();
         this.reqs_ = new Vector.<Requirement>();
         super();
         for each(uiDrawBoxXML in stepXML.UIDrawBox)
         {
            this.uiDrawBoxes_.push(new UIDrawBox(uiDrawBoxXML));
         }
         for each(uiDrawArrowXML in stepXML.UIDrawArrow)
         {
            this.uiDrawArrows_.push(new UIDrawArrow(uiDrawArrowXML));
         }
         for each(reqXML in stepXML.Requirement)
         {
            this.reqs_.push(new Requirement(reqXML));
         }
      }
      
      public function toString() : String
      {
         return "[" + this.text_ + "]";
      }
   }
}
