package com;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Rectangle;
import nme.events.TouchEvent;
import nme.Lib;
import nme.events.MouseEvent;

/**
 * ...
 * @author Valentin
 */
class TouchSensor extends Sprite
{	
	var inited: Bool = false;
	var listeners : Array < TouchSensorListener>;
	var notes: Array<Bool>;
	var note_ids: Array<Int>;
	var note_times_start: Array<Int>;
	var note_times_end: Array<Int>;
	var notes_picked: Array<Bool>;
	
	public static var MOUSE_ID: Int = -1;
	static var INVALID: Int = -2;
	static var PICKER: Int = -3;
	
	var rect: Sprite;
	static var sensew: Float = 100;
	static var senseh: Float = 100;
	
	var fretBoardSize: Int;
	
	
	
	
	//for Main.textChange -- debugging
	var m: Main;
	
	
	public function new() 
	{
		super();
		Lib.trace("sensor new");
	}
	
	public function init(fretBoardSize: Int,pos: Rectangle): Void
	{
		if (inited) return;
		else inited = true;
		
		this.fretBoardSize = fretBoardSize;
		notes = new Array<Bool>();
		note_ids = new Array<Int>();
		note_times_start = new Array<Int>();
		note_times_end = new Array<Int>();
		notes_picked = new Array<Bool>();
		for ( i in 0...fretBoardSize) {
			notes[i] = false;
			note_times_start[i] = 0;
			note_times_end[i] = 0;
			note_ids[i] = INVALID;
			notes_picked[i] = false;
		}
		
		addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		addEventListener(TouchEvent.TOUCH_OUT, onTouchOut);
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseBegin);
		addEventListener(MouseEvent.MOUSE_UP, onMouseEnd);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		
		listeners = new Array<TouchSensorListener>();
		
		
		rect = new Sprite();
		rect.graphics.beginFill (0x000000, 0.005);
		rect.graphics.drawRect (0, 0, sensew, senseh);
		rect.mouseChildren = false;
		addChild(rect);
		
		resized(pos);
	}
	
	public function resized(pos: Rectangle)
	{
		Lib.trace("sensor resized with: "+ pos.x + " " + pos.y + " " + pos.width + " " + pos.height);
		this.x = pos.x;
		this.y = pos.y;
		this.rect.width = pos.width;
		this.rect.height = pos.height;
	}
	
	public function addTouchSensorListener(sl: TouchSensorListener) 
	{
		listeners.push(sl);
	}
	private function onTouchBegin(event: TouchEvent): Void 
	{	
		onDown(event.localX, event.localY,event.touchPointID);
	}
	private function onMouseBegin(event: MouseEvent): Void 
	{	
		onDown(event.localX,event.localY,MOUSE_ID);
	}
	private function onTouchEnd(event: TouchEvent): Void 
	{	
		onUp(event.localX,event.localY,event.touchPointID);
	}
	private function onMouseEnd (event: MouseEvent) : Void
	{
		onUp(event.localX, event.localY,MOUSE_ID);
	}
	private function onTouchOut(event: TouchEvent) : Void
	{
		onOut(event.localX, event.localY, event.touchPointID);
	}
	private function onMouseOut(event: MouseEvent) : Void 
	{
		onOut(event.localX,event.localY,MOUSE_ID);
	}
	private function onOut(x: Float,y:Float, touchId: Int)
	{
		onUp(x, y, touchId);
	}
	private function Index(x: Float) : Int
	{
		return  Std.int(x * fretBoardSize / sensew) ;
	}
	private function onDown(x: Float, y: Float, touchId: Int) : Void
	{
		Main.m.textChange("touch begin");
		Lib.trace("sensorwh: " + width+ "  " + height );
		var index = Index(x);
		//var index: Int =  Std.int(2.6
		singlePressed(index,touchId);
		
		Lib.trace("touch begin , localXY: " + x + " " + y +  " index: "+index);
	}
	private function onUp(x: Float, y: Float, touchId: Int) 
	{
		Main.m.textChange("touch end");
		for (i in 0...fretBoardSize) {
			if (note_ids[i] == touchId) {
				released(x,i);
				break;
			}
		}
		
	}
	private function singlePressed(index: Int, touchId: Int) : Void
	{
		note_ids[index] = touchId;
		note_times_start[index] = Lib.getTimer();
		notes[index] = true;
		notifySensorListeners();
		Main.m.textChange("pressed " + index);
	}
	private function released(x: Float,index: Int) : Void
	{
		notes[index] = false;
		note_times_end[index] = Lib.getTimer();
		var range = note_times_end[index] - note_times_start[index];
		Lib.trace("range: " + range + "ms");
		Main.m.textChange("range: " + range + "ms");
		
		var endIndex = Index(x);
		if (endIndex != index && index != PICKER) slide(index, endIndex);
		
		note_ids[index] = INVALID;
		notifySensorListeners();
		
		
		var max:Int = INVALID;
		for (i in 0...index) {
			if (notes[i] == true && i > max) max = i;
		}
		if (max != INVALID) pull_off(max);
	}
	public function strumPress(): Void 
	{	
		var out : String = "strumPress: ";
		var empty: Bool = true;
		for (i in 0...fretBoardSize) {
			if (notes[i] == true) {
				empty = false;
				out = out + " " + i;
				notes_picked[i] = true;
			}
		}
		if (!empty) Main.m.textChange(out);
		else Main.m.textChange("empty strumPress");
	}
	private function notesReleased(released: Array<Bool>): Void
	{
		var out : String  = "strumRelease: ";
		var empty : Bool = true;
		for (i in 0...fretBoardSize) {
			if (notes_picked[i] == true) {
				empty = false;
				out = out + " " + i;
				notes_picked[i] = false;
			}
		}
		if (!empty) Main.m.textChange(out);
		else Main.m.textChange("empty strumRelease");
	}
	public function strumRelease(): Void
	{	
		notesReleased(notes_picked);
	}
	private function pull_off(index: Int) : Void
	{
		Main.m.textChange("PULL OFF " + index);
	}
	private function slide(startIndex: Int, endIndex: Int) : Void
	{
		Main.m.textChange("SLIDE " + startIndex + " " + endIndex);
	}
	private function notifySensorListeners() : Void
	{
		for (ls in listeners) {
			ls.onSensorSense();
		}
		//Main.m.textChange("notify " + listeners.length);
	}
	public function getNotesBool(): Array<Bool>
	{
		return notes;
	}
	
}