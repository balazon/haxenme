package com;
import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.Stage;
import nme.geom.Rectangle;
import nme.Lib;

/**
 * ...
 * @author Valentin
 */
class FretBoard extends Sprite, implements TouchSensorListener, implements PickListener
{
	var inited: Bool = false;
	
	var hasPicker : Bool = false;
	
	var sensor: TouchSensor;
	var picker: PickSensor;
	var fretPics : FretPics;
	var pickR: Rectangle;
	
	var size: Int;
	
	public function new() 
	{	
		super();
		
	}
	public function init(size: Int, sensorR: Rectangle, picsR: Rectangle, hasPicker: Bool = false, pickR: Rectangle = null)
	{	
		if (inited) return;
		else inited = true;
		
		this.size = size;
		this.hasPicker = hasPicker;
		
		
		
		Lib.trace("new fretpics");
		fretPics = new FretPics();
		fretPics.init(size, picsR);
		addChild(fretPics);
		
		Lib.trace("new sensor");
		sensor = new TouchSensor();
		sensor.init(size, sensorR);
		sensor.addTouchSensorListener(this);
		addChild(sensor);
		
		if(hasPicker && pickR != null) {
			Lib.trace("new picker");
			picker = new PickSensor();
			picker.init(pickR);
			picker.addPickListener(this);
			addChild(picker);
		}
		
	}
	
	public function resized(sensorR: Rectangle, picsR: Rectangle, pickR: Rectangle = null)
	{
		Lib.trace("fretboard resize ");
		sensor.resized(sensorR);
		fretPics.resized(picsR);
		if (pickR != null && hasPicker) picker.resized(pickR);
	}
	
	public function onSensorSense() 
	{	
		fretPics.refreshPics(sensor.getNotesBool());
	}
	
	public function onPicked(): Void 
	{
		sensor.strumPress();
	}
	public function onPickReleased(): Void
	{
		sensor.strumRelease();
	}
	
}