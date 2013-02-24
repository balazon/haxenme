package com;
import nme.Assets;
import nme.display.Sprite;
import nme.display.Bitmap;
import nme.events.TouchEvent;
import nme.events.MouseEvent;
import nme.geom.Rectangle;

/**
 * ...
 * @author Valentin
 */
class PickSensor extends Sprite
{
	var inited : Bool = false;
	var picku: Bitmap;
	var pickp: Bitmap;
	var listener: PickListener;
	
	public function new() 
	{
		super();
	}
	public function init(pos: Rectangle) : Void
	{
		if (inited) return;
		else inited = true;
		
		picku = new Bitmap(Assets.getBitmapData("img/picku.png"));
		pickp = new Bitmap(Assets.getBitmapData("img/pickp.png"));
		addChild(picku);
		addChild(pickp);
		pickp.visible = false;
		
		addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		addEventListener(TouchEvent.TOUCH_OUT, onTouchOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseEnd);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		
		resized(pos);
	}
	public function resized(pos: Rectangle) : Void
	{	
		this.x = pos.x;
		this.y = pos.y;
		this.width = pos.width;
		this.height = pos.height;
	}
	public function addPickListener(l :PickListener )
	{
		listener = l;
	}
	private function onMouseDown(event: MouseEvent) : Void
	{
		onDown(event.localX, event.localY, TouchSensor.MOUSE_ID);
	}
	private function onMouseEnd (event: MouseEvent) : Void
	{
		onUp(event.localX, event.localY,TouchSensor.MOUSE_ID);
	}
	private function onMouseOut(event: MouseEvent) : Void 
	{
		onOut(event.localX,event.localY,TouchSensor.MOUSE_ID);
	}
	private function onTouchBegin(event: TouchEvent): Void 
	{	
		onDown(event.localX, event.localY,event.touchPointID);
	}
	private function onTouchEnd(event: TouchEvent): Void 
	{	
		onUp(event.localX,event.localY,event.touchPointID);
	}
	private function onTouchOut(event: TouchEvent) : Void
	{
		onOut(event.localX, event.localY, event.touchPointID);
	}
	private function onOut(x: Float,y:Float, touchId: Int)
	{
		onUp(x, y, touchId);
	}
	private function onDown(x: Float, y: Float, touchId: Int) : Void
	{
		listener.onPicked();
		picku.visible = false;
		pickp.visible = true;
		
	}
	private function onUp(x: Float, y: Float, touchId: Int) 
	{
		pickp.visible = false;
		picku.visible = true;
		listener.onPickReleased();
	}
	
}