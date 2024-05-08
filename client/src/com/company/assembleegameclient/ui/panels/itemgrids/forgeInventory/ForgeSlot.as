package com.company.assembleegameclient.ui.panels.itemgrids.forgeInventory
{
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.Slot;
import com.company.ui.SimpleText;
import com.company.util.GraphicsUtil;
import com.company.util.MoreColorUtil;
import com.company.util.SpriteUtil;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.geom.Point;

public class ForgeSlot extends Slot
{

    private static const DOSE_MATRIX:Matrix = function():Matrix
    {
        var m:* = new Matrix();
        m.translate(10,5);
        return m;
    }();


    public var objectType_:int;
    public var objectId_:String;
    public var included_:Boolean;

    public var id:uint;

    public var item_:int;

    public var itemBitmap_:Bitmap;

    public var overlay_:Shape;

    private var overlayFill_:GraphicsSolidFill;

    private var lineStyle_:GraphicsStroke;

    private var overlayPath_:GraphicsPath;

    private var graphicsData_:Vector.<IGraphicsData>;

    public function ForgeSlot(item:int, cuts:Array, id:uint)
    {
        var texture:BitmapData = null;
        var eqXML:XML = null;
        var offset:Point = null;
        var tempText:SimpleText = null;
        this.overlayFill_ = new GraphicsSolidFill(16711310,1);
        this.lineStyle_ = new GraphicsStroke(2,false,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.ROUND,3,this.overlayFill_);
        this.overlayPath_ = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[this.lineStyle_,this.overlayPath_,GraphicsUtil.END_STROKE];
        super(0,0,cuts);
        this.id = id;
        this.item_ = item;
        if(this.item_ != -1)
        {
            SpriteUtil.safeRemoveChild(this,backgroundImage_);
            texture = ObjectLibrary.getRedrawnTextureFromType(this.item_,80,true);
            eqXML = ObjectLibrary.xmlLibrary_[this.item_];
            this.objectType_ = eqXML.@type;
            this.objectId_ = eqXML.@id;
            if(eqXML.hasOwnProperty("Doses"))
            {
                texture = texture.clone();
                tempText = new SimpleText(12,16777215,false,0,0);
                tempText.text = String(eqXML.Doses);
                tempText.updateMetrics();
                texture.draw(tempText,DOSE_MATRIX);
            }
            else if(eqXML && eqXML.hasOwnProperty("Quantity"))
            {
                texture = texture.clone();
                tempText = new SimpleText(12,16777215,false,0,0);
                tempText.text = String(eqXML.Quantity);
                tempText.updateMetrics();
                texture.draw(tempText,DOSE_MATRIX);
            }
            offset = offsets(this.item_,type_,false);
            this.itemBitmap_ = new Bitmap(texture);
            this.itemBitmap_.x = WIDTH / 2 - this.itemBitmap_.width / 2 + offset.x;
            this.itemBitmap_.y = HEIGHT / 2 - this.itemBitmap_.height / 2 + offset.y;
            SpriteUtil.safeAddChild(this,this.itemBitmap_);
        }
        this.overlay_ = this.getOverlay();
        addChild(this.overlay_);
    }

    public function setIncluded(included:Boolean) : void
    {
        this.included_ = included;
        //this.overlay_.visible = this.included_;
        if(this.included_)
        {
            fill_.color = 16764247;
        }
        else
        {
            fill_.color = 5526612;
        }
        drawBackground();
    }

    private function getOverlay() : Shape
    {
        var shape:Shape = new Shape();
        GraphicsUtil.clearPath(this.overlayPath_);
        GraphicsUtil.drawCutEdgeRect(0,0,WIDTH,HEIGHT,4,cuts_,this.overlayPath_);
        shape.graphics.drawGraphicsData(this.graphicsData_);
        return shape;
    }
}
}
