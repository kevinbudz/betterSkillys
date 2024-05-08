package com.company.assembleegameclient.tutorial
{
   import com.company.assembleegameclient.game.GameSprite;
   import com.company.assembleegameclient.objects.GameObject;
   import com.company.assembleegameclient.objects.Player;
   import com.company.assembleegameclient.parameters.Parameters;
   import com.company.util.PointUtil;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BlurFilter;
   import flash.utils.getTimer;
   import kabam.rotmg.assets.EmbeddedData;
   
   public class Tutorial extends Sprite
   {
      
      public static const NEXT_ACTION:String = "Next";
      
      public static const MOVE_FORWARD_ACTION:String = "MoveForward";
      
      public static const MOVE_BACKWARD_ACTION:String = "MoveBackward";
      
      public static const ROTATE_LEFT_ACTION:String = "RotateLeft";
      
      public static const ROTATE_RIGHT_ACTION:String = "RotateRight";
      
      public static const MOVE_LEFT_ACTION:String = "MoveLeft";
      
      public static const MOVE_RIGHT_ACTION:String = "MoveRight";
      
      public static const UPDATE_ACTION:String = "Update";
      
      public static const ATTACK_ACTION:String = "Attack";
      
      public static const DAMAGE_ACTION:String = "Damage";
      
      public static const KILL_ACTION:String = "Kill";
      
      public static const SHOW_LOOT_ACTION:String = "ShowLoot";
      
      public static const TEXT_ACTION:String = "Text";
      
      public static const SHOW_PORTAL_ACTION:String = "ShowPortal";
      
      public static const ENTER_PORTAL_ACTION:String = "EnterPortal";
      
      public static const NEAR_REQUIREMENT:String = "Near";
      
      public static const EQUIP_REQUIREMENT:String = "Equip";
       
      
      public var gs_:GameSprite;
      
      public var steps_:Vector.<Step>;
      
      public var currStepId_:int = 0;
      
      private var darkBox_:Sprite;
      
      private var boxesBack_:Shape;
      
      private var boxes_:Shape;
      
      private var tutorialMessage_:TutorialMessage = null;
      
      public function Tutorial(gs:GameSprite)
      {
         var stepXML:XML = null;
         var g:Graphics = null;
         this.steps_ = new Vector.<Step>();
         this.darkBox_ = new Sprite();
         this.boxesBack_ = new Shape();
         this.boxes_ = new Shape();
         super();
         this.gs_ = gs;
         for each(stepXML in EmbeddedData.tutorialXML.Step)
         {
            this.steps_.push(new Step(stepXML));
         }
         addChild(this.boxesBack_);
         addChild(this.boxes_);
         g = this.darkBox_.graphics;
         g.clear();
         g.beginFill(0,0.1);
         g.drawRect(0,0,800,600);
         g.endFill();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.draw();
      }
      
      private function onRemovedFromStage(event:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var currStep:Step = null;
         var satisfied:Boolean = false;
         var req:Requirement = null;
         var timeDiff:int = 0;
         var uiDrawBox:UIDrawBox = null;
         var uiDrawArrow:UIDrawArrow = null;
         var player:Player = null;
         var close:Boolean = false;
         var go:GameObject = null;
         var dist:Number = NaN;
         var t:Number = Math.abs(Math.sin(getTimer() / 300));
         this.boxesBack_.filters = [new BlurFilter(5 + t * 5,5 + t * 5)];
         this.boxes_.graphics.clear();
         this.boxesBack_.graphics.clear();
         for(var i:int = 0; i < this.steps_.length; i++)
         {
            currStep = this.steps_[i];
            satisfied = true;
            for each(req in currStep.reqs_)
            {
               player = this.gs_.map.player_;
               switch(req.type_)
               {
                  case NEAR_REQUIREMENT:
                     close = false;
                     for each(go in this.gs_.map.goDict_)
                     {
                        if(!(go.objectType_ != req.objectType_ || req.objectName_ != "" && go.name_ != req.objectName_))
                        {
                           dist = PointUtil.distanceXY(go.x_,go.y_,player.x_,player.y_);
                           if(dist <= req.radius_)
                           {
                              close = true;
                              break;
                           }
                        }
                     }
                     if(!close)
                     {
                        satisfied = false;
                     }
                     continue;
                  default:
                     trace("ERROR: unrecognized req: " + req.type_);
                     continue;
               }
            }
            if(!satisfied)
            {
               currStep.satisfiedSince_ = 0;
            }
            else
            {
               if(currStep.satisfiedSince_ == 0)
               {
                  currStep.satisfiedSince_ = getTimer();
               }
               timeDiff = getTimer() - currStep.satisfiedSince_;
               for each(uiDrawBox in currStep.uiDrawBoxes_)
               {
                  uiDrawBox.draw(5 * t,this.boxes_.graphics,timeDiff);
                  uiDrawBox.draw(6 * t,this.boxesBack_.graphics,timeDiff);
               }
               for each(uiDrawArrow in currStep.uiDrawArrows_)
               {
                  uiDrawArrow.draw(5 * t,this.boxes_.graphics,timeDiff);
                  uiDrawArrow.draw(6 * t,this.boxesBack_.graphics,timeDiff);
               }
            }
         }
      }
      
      internal function doneAction(action:String) : void
      {
         var req:Requirement = null;
         var player:Player = null;
         var close:Boolean = false;
         var go:GameObject = null;
         var dist:Number = NaN;
         if(this.currStepId_ >= this.steps_.length)
         {
            return;
         }
         var currStep:Step = this.steps_[this.currStepId_];
         if(action != currStep.action_)
         {
            return;
         }
         while(true)
         {
            loop0:
            for each(req in currStep.reqs_)
            {
               player = this.gs_.map.player_;
               switch(req.type_)
               {
                  case NEAR_REQUIREMENT:
                     close = false;
                     for each(go in this.gs_.map.goDict_)
                     {
                        if(go.objectType_ == req.objectType_)
                        {
                           dist = PointUtil.distanceXY(go.x_,go.y_,player.x_,player.y_);
                           if(dist <= req.radius_)
                           {
                              close = true;
                              break;
                           }
                        }
                     }
                     if(!close)
                     {
                        break loop0;
                     }
                     continue;
                  case EQUIP_REQUIREMENT:
                     if(player.equipment_[req.slot_] != req.objectType_)
                     {
                        return;
                     }
                     continue;
                  default:
                     trace("ERROR: unrecognized req: " + req.type_);
                     continue;
               }
            }
            var _loc8_:* = this;
            this.currStepId_++;
            this.draw();
            return;
         }
      }
      
      private function draw() : void
      {
         var uiDrawBox:UIDrawBox = null;
      }
   }
}
