package com.company.assembleegameclient.mapeditor
{
import com.company.assembleegameclient.account.ui.TextInputField;
import com.company.assembleegameclient.editor.CommandEvent;
   import com.company.assembleegameclient.editor.CommandList;
   import com.company.assembleegameclient.editor.CommandQueue;
   import com.company.assembleegameclient.map.GroundLibrary;
   import com.company.assembleegameclient.map.RegionLibrary;
   import com.company.assembleegameclient.objects.ObjectLibrary;
   import com.company.assembleegameclient.screens.AccountScreen;
import com.company.assembleegameclient.screens.TitleMenuOption;
import com.company.assembleegameclient.ui.dropdown.DropDown;
   import com.company.util.IntPoint;
   import com.company.util.SpriteUtil;
   import com.hurlant.util.Base64;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
   import flash.net.FileFilter;
   import flash.net.FileReference;
import flash.text.TextFieldAutoSize;
import flash.utils.ByteArray;
   import kabam.lib.json.JsonParser;
   import kabam.rotmg.core.StaticInjectorContext;
import kabam.rotmg.core.signals.SetScreenSignal;
import kabam.rotmg.ui.view.TitleView;
import kabam.rotmg.ui.view.components.ScreenBase;
   import net.hires.debug.Stats;

import org.hamcrest.text.startsWith;

public class EditingScreen extends Sprite
   {
      
      private static const MAP_Y:int = 600 - MEMap.SIZE - 10;
      
      public static const stats_:Stats = new Stats();
      
      public var commandMenu_:MECommandMenu;
      
      private var commandQueue_:CommandQueue;
      
      public var meMap_:MEMap;
      
      public var infoPane_:InfoPane;
      
      public var chooserDrowDown_:DropDown;
      
      public var groundChooser_:GroundChooser;
      
      public var objChooser_:ObjectChooser;
      
      public var regionChooser_:RegionChooser;
      
      public var chooser_:Chooser;
      
      public var filename_:String = null;
      
      private var json:JsonParser;
      
      private var loadedFile_:FileReference = null;

      private var _search:TextInputField;

      public var returnButton_:TitleMenuOption;

      public var container:Sprite;
      
      public function EditingScreen()
      {
         super();
         this._search = new TextInputField("", false, "", "Search");
         this._search.x = 550;
         this._search.y = 6;
         addChild(this._search);
         this.json = StaticInjectorContext.getInjector().getInstance(JsonParser);
         this.commandMenu_ = new MECommandMenu();
         this.commandMenu_.x = 15;
         this.commandMenu_.y = MAP_Y;
         this.commandMenu_.addEventListener(CommandEvent.UNDO_COMMAND_EVENT,this.onUndo);
         this.commandMenu_.addEventListener(CommandEvent.REDO_COMMAND_EVENT,this.onRedo);
         this.commandMenu_.addEventListener(CommandEvent.CLEAR_COMMAND_EVENT,this.onClear);
         this.commandMenu_.addEventListener(CommandEvent.LOAD_COMMAND_EVENT,this.onLoad);
         this.commandMenu_.addEventListener(CommandEvent.SAVE_COMMAND_EVENT,this.onSave);
         this.commandMenu_.addEventListener(CommandEvent.TEST_COMMAND_EVENT,this.onTest);
         addChild(this.commandMenu_);
         this.commandQueue_ = new CommandQueue();
         this.meMap_ = new MEMap();
         this.meMap_.addEventListener(TilesEvent.TILES_EVENT,this.onTilesEvent);
         this.meMap_.x = 800 / 2 - MEMap.SIZE / 2;
         this.meMap_.y = MAP_Y;
         addChild(this.meMap_);
         this.infoPane_ = new InfoPane(this.meMap_);
         this.infoPane_.x = 4;
         this.infoPane_.y = 600 - InfoPane.HEIGHT - 10;
         addChild(this.infoPane_);
         this.chooserDrowDown_ = new DropDown(new <String>["Ground","Objects","Regions"],Chooser.WIDTH,26);
         this.chooserDrowDown_.x = this.meMap_.x + MEMap.SIZE + 4;
         this.chooserDrowDown_.y = MAP_Y;
         this.chooserDrowDown_.addEventListener(Event.CHANGE,this.onDropDownChange);
         addChild(this.chooserDrowDown_);
         this.groundChooser_ = new GroundChooser();
         this.groundChooser_.x = this.chooserDrowDown_.x;
         this.groundChooser_.y = this.chooserDrowDown_.y + this.chooserDrowDown_.height + 4;
         this.chooser_ = this.groundChooser_;
         addChild(this.groundChooser_);
         this.SetAllSearch("");
         this.objChooser_ = new ObjectChooser();
         this.objChooser_.x = this.chooserDrowDown_.x;
         this.objChooser_.y = this.chooserDrowDown_.y + this.chooserDrowDown_.height + 4;
         this.regionChooser_ = new RegionChooser();
         this.regionChooser_.x = this.chooserDrowDown_.x;
         this.regionChooser_.y = this.chooserDrowDown_.y + this.chooserDrowDown_.height + 4;
         this.returnButton_ = new TitleMenuOption("back to home", 18, false);
         this.returnButton_.addEventListener(MouseEvent.CLICK, onReturn);
         this.returnButton_.x = 795 - this.returnButton_.width;
         this.returnButton_.y = 4;
         addChild(this.returnButton_);
      }

      private function onReturn(e:Event) : void
      {
         this.returnButton_.removeEventListener(MouseEvent.CLICK, onReturn);
         parent.removeChild(this);

         var setScreen:SetScreenSignal = StaticInjectorContext.injector.getInstance(SetScreenSignal);
         setScreen.dispatch(new TitleView());
      }

      public function get searchStr():String {
         return (this._search.text());
      }

      public function SetAllSearch(item:String) : void
      {
         this._search.removeEventListener(Event.CHANGE, this.onSearchBarChange);
         this._search.inputText_.text = item;
         this._search.addEventListener(Event.CHANGE, this.onSearchBarChange);
      }

      private function onSearchBarChange(evt:Event) : void
      {
         switch (this.chooser_)
         {
            case this.groundChooser_:
               this.groundChooser_.reloadObjects(this.searchStr);
               break;
            case this.objChooser_:
                this.objChooser_.reloadObjects(this.searchStr);
                break;
         }
      }
      
      private function onTilesEvent(event:TilesEvent) : void
      {
         var tile:IntPoint = null;
         var type:int = 0;
         var oldName:String = null;
         var props:EditTileProperties = null;
         tile = event.tiles_[0];
         switch(this.commandMenu_.getCommand())
         {
            case MECommandMenu.DRAW_COMMAND:
               this.addModifyCommandList(event.tiles_,this.chooser_.layer_,this.chooser_.selectedType());
               break;
            case MECommandMenu.ERASE_COMMAND:
               this.addModifyCommandList(event.tiles_,this.chooser_.layer_,-1);
               break;
            case MECommandMenu.SAMPLE_COMMAND:
               type = this.meMap_.getType(tile.x_,tile.y_,this.chooser_.layer_);
               if(type == -1)
               {
                  return;
               }
               this.chooser_.setSelectedType(type);
               this.commandMenu_.setCommand(MECommandMenu.DRAW_COMMAND);
               break;
            case MECommandMenu.EDIT_COMMAND:
               oldName = this.meMap_.getObjectName(tile.x_,tile.y_);
               props = new EditTileProperties(event.tiles_,oldName);
               props.addEventListener(Event.COMPLETE,this.onEditComplete);
               addChild(props);
         }
         this.meMap_.draw();
      }
      
      private function onEditComplete(event:Event) : void
      {
         var props:EditTileProperties = event.currentTarget as EditTileProperties;
         this.addObjectNameCommandList(props.tiles_,props.getObjectName());
      }
      
      private function addModifyCommandList(tiles:Vector.<IntPoint>, layer:int, type:int) : void
      {
         var tile:IntPoint = null;
         var oldType:int = 0;
         var commandList:CommandList = new CommandList();
         for each(tile in tiles)
         {
            oldType = this.meMap_.getType(tile.x_,tile.y_,layer);
            if(oldType != type)
            {
               commandList.addCommand(new MEModifyCommand(this.meMap_,tile.x_,tile.y_,layer,oldType,type));
            }
         }
         if(commandList.empty())
         {
            return;
         }
         this.commandQueue_.addCommandList(commandList);
      }
      
      private function addObjectNameCommandList(tiles:Vector.<IntPoint>, objName:String) : void
      {
         var tile:IntPoint = null;
         var oldName:String = null;
         var commandList:CommandList = new CommandList();
         for each(tile in tiles)
         {
            oldName = this.meMap_.getObjectName(tile.x_,tile.y_);
            if(oldName != objName)
            {
               commandList.addCommand(new MEObjectNameCommand(this.meMap_,tile.x_,tile.y_,oldName,objName));
            }
         }
         if(commandList.empty())
         {
            return;
         }
         this.commandQueue_.addCommandList(commandList);
      }
      
      private function onDropDownChange(event:Event) : void
      {
         switch(this.chooserDrowDown_.getValue())
         {
            case "Ground":
               this.SetAllSearch(this.groundChooser_.getLastSearch());
               SpriteUtil.safeAddChild(this,this.groundChooser_);
               SpriteUtil.safeRemoveChild(this,this.objChooser_);
               SpriteUtil.safeRemoveChild(this,this.regionChooser_);
               this.chooser_ = this.groundChooser_;
               break;
            case "Objects":
               this.SetAllSearch(this.objChooser_.getLastSearch());
               SpriteUtil.safeRemoveChild(this,this.groundChooser_);
               SpriteUtil.safeAddChild(this,this.objChooser_);
               SpriteUtil.safeRemoveChild(this,this.regionChooser_);
               this.chooser_ = this.objChooser_;
               break;
            case "Regions":
               SpriteUtil.safeRemoveChild(this,this.groundChooser_);
               SpriteUtil.safeRemoveChild(this,this.objChooser_);
               SpriteUtil.safeAddChild(this,this.regionChooser_);
               this.chooser_ = this.regionChooser_;
               break;
         }
      }
      
      private function onUndo(event:CommandEvent) : void
      {
         this.commandQueue_.undo();
         this.meMap_.draw();
      }
      
      private function onRedo(event:CommandEvent) : void
      {
         this.commandQueue_.redo();
         this.meMap_.draw();
      }
      
      private function onClear(event:CommandEvent) : void
      {
         var tile:IntPoint = null;
         var oldTile:METile = null;
         var tiles:Vector.<IntPoint> = this.meMap_.getAllTiles();
         var commandList:CommandList = new CommandList();
         for each(tile in tiles)
         {
            oldTile = this.meMap_.getTile(tile.x_,tile.y_);
            if(oldTile != null)
            {
               commandList.addCommand(new MEClearCommand(this.meMap_,tile.x_,tile.y_,oldTile));
            }
         }
         if(commandList.empty())
         {
            return;
         }
         this.commandQueue_.addCommandList(commandList);
         this.meMap_.draw();
         this.filename_ = null;
      }
      
      private function createMapJSON() : String
      {
         var xi:int = 0;
         var tile:METile = null;
         var entry:Object = null;
         var entryJSON:String = null;
         var index:int = 0;
         var bounds:Rectangle = this.meMap_.getTileBounds();
         if(bounds == null)
         {
            return null;
         }
         var jm:Object = {};
         jm["width"] = int(bounds.width);
         jm["height"] = int(bounds.height);
         var dict:Object = {};
         var entries:Array = [];
         var byteArray:ByteArray = new ByteArray();
         for(var yi:int = bounds.y; yi < bounds.bottom; yi++)
         {
            for(xi = bounds.x; xi < bounds.right; xi++)
            {
               tile = this.meMap_.getTile(xi,yi);
               entry = this.getEntry(tile);
               entryJSON = this.json.stringify(entry);
               if(!dict.hasOwnProperty(entryJSON))
               {
                  index = entries.length;
                  dict[entryJSON] = index;
                  entries.push(entry);
               }
               else
               {
                  index = dict[entryJSON];
               }
               byteArray.writeShort(index);
            }
         }
         jm["dict"] = entries;
         byteArray.compress();
         jm["data"] = Base64.encodeByteArray(byteArray);
         return this.json.stringify(jm);
      }
      
      private function onSave(event:CommandEvent) : void
      {
         var mapJSON:String = this.createMapJSON();
         if(mapJSON == null)
         {
            return;
         }
         new FileReference().save(mapJSON,this.filename_ == null?"map.jm":this.filename_);
      }
      
      private function getEntry(tile:METile) : Object
      {
         var types:Vector.<int> = null;
         var id:String = null;
         var obj:Object = null;
         var entry:Object = {};
         if(tile != null)
         {
            types = tile.types_;
            if(types[Layer.GROUND] != -1)
            {
               id = GroundLibrary.getIdFromType(types[Layer.GROUND]);
               entry["ground"] = id;
            }
            if(types[Layer.OBJECT] != -1)
            {
               id = ObjectLibrary.getIdFromType(types[Layer.OBJECT]);
               obj = {"id":id};
               if(tile.objName_ != null)
               {
                  obj["name"] = tile.objName_;
               }
               entry["objs"] = [obj];
            }
            if(types[Layer.REGION] != -1)
            {
               id = RegionLibrary.getIdFromType(types[Layer.REGION]);
               entry["regions"] = [{"id":id}];
            }
         }
         return entry;
      }
      
      private function onLoad(event:CommandEvent) : void
      {
         this.loadedFile_ = new FileReference();
         this.loadedFile_.addEventListener(Event.SELECT,this.onFileBrowseSelect);
         this.loadedFile_.browse([new FileFilter("JSON Map (*.jm)","*.jm")]);
      }
      
      private function onFileBrowseSelect(event:Event) : void
      {
         var loadedFile:FileReference = event.target as FileReference;
         loadedFile.addEventListener(Event.COMPLETE,this.onFileLoadComplete);
         loadedFile.addEventListener(IOErrorEvent.IO_ERROR,this.onFileLoadIOError);
         try
         {
            loadedFile.load();
         }
         catch(e:Error)
         {
            trace("Error: " + e);
         }
      }
      
      private function onFileLoadComplete(event:Event) : void
      {
         var type:int = 0;
         var xi:int = 0;
         var entry:Object = null;
         var objs:Array = null;
         var regions:Array = null;
         var obj:Object = null;
         var region:Object = null;
         var loadedFile:FileReference = event.target as FileReference;
         this.filename_ = loadedFile.name;
         var jm:Object = this.json.parse(loadedFile.data.toString());
         var w:int = jm["width"];
         var h:int = jm["height"];
         var bounds:Rectangle = new Rectangle(int(MEMap.NUM_SQUARES / 2 - w / 2),int(MEMap.NUM_SQUARES / 2 - h / 2),w,h);
         this.meMap_.clear();
         this.commandQueue_.clear();
         var dict:Array = jm["dict"];
         var byteArray:ByteArray = Base64.decodeToByteArray(jm["data"]);
         byteArray.uncompress();
         for(var yi:int = bounds.y; yi < bounds.bottom; yi++)
         {
            for(xi = bounds.x; xi < bounds.right; xi++)
            {
               entry = dict[byteArray.readShort()];
               if(entry.hasOwnProperty("ground"))
               {
                  type = GroundLibrary.idToType_[entry["ground"]];
                  this.meMap_.modifyTile(xi,yi,Layer.GROUND,type);
               }
               objs = entry["objs"];
               if(objs != null)
               {
                  for each(obj in objs)
                  {
                     if(!ObjectLibrary.idToType_.hasOwnProperty(obj["id"]))
                     {
                        trace("ERROR: Unable to find: " + obj["id"]);
                     }
                     else
                     {
                        type = ObjectLibrary.idToType_[obj["id"]];
                        this.meMap_.modifyTile(xi,yi,Layer.OBJECT,type);
                        if(obj.hasOwnProperty("name"))
                        {
                           this.meMap_.modifyObjectName(xi,yi,obj["name"]);
                        }
                     }
                  }
               }
               regions = entry["regions"];
               if(regions != null)
               {
                  for each(region in regions)
                  {
                     type = RegionLibrary.idToType_[region["id"]];
                     this.meMap_.modifyTile(xi,yi,Layer.REGION,type);
                  }
               }
            }
         }
         this.meMap_.draw();
      }
      
      private function onFileLoadIOError(event:Event) : void
      {
         trace("error: " + event);
      }
      
      private function onTest(event:Event) : void
      {
         dispatchEvent(new MapTestEvent(this.createMapJSON()));
      }
   }
}
