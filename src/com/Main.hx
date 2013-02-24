package com;

import nme.display.Sprite;
import nme.geom.Rectangle;
import nme.Lib;
import nme.text.TextField;
import nme.events.Event;
/**
 * ...
 * @author Valentin
 */

class Main extends Sprite
{
	var inited:Bool;
	var tf : TextField;
	var first_color: Bool;
	
	var fretBoard: FretBoard;
	public static var m: Main;
	
	var sensorR: Rectangle;
	var fretR: Rectangle;
	var pickR: Rectangle;
	
	
	

	/* ENTRY POINT */
	
	
	
	function init() 
	{
		if (inited) return;
		inited = true;

		// (your code here)
		
		// Stage:
		// stage.stageWidth x stage.stageHeight @ stage.dpiScale
		
		// Assets:
		// nme.Assets.getBitmapData("img/assetname.jpg");
		tf = new TextField();
		tf.textColor = 0xFFFFFF;
		tf.x = 10;
		tf.y = 10;
		tf.height = 50;
		tf.width = 200;
		
		
		Lib.trace("fretboard new");
		fretBoard = new FretBoard();
		resetRects();
		fretBoard.init(5, sensorR, fretR,false,pickR);
		addChild(fretBoard);
		
		addChild(tf);
		tf.text = "asd";
		
		Lib.trace("stagewh: " + stage.stageWidth + "  " + stage.stageHeight);
	}
	function resetRects(): Void
	{
		sensorR = new Rectangle(0, stage.stageHeight * 0.8, stage.stageWidth*0.8, stage.stageHeight * 0.2);
		fretR = new Rectangle(0, stage.stageHeight * 0.8, stage.stageWidth * 0.8, stage.stageHeight * 0.2);
		pickR = new Rectangle(stage.stageWidth * 0.8, stage.stageHeight * 0.1, stage.stageWidth * 0.2, stage.stageHeight * 0.3);
	}
	
	function resize(e) 
	{
		if (!inited) init();
		// else (resize or orientation change)
		resetRects();
		fretBoard.resized(sensorR,fretR);
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		m = new Main();
		Lib.current.addChild(m);
	}
	
	
	
	public function textChange(text1: String) :Void 
	{
		tf.text = text1;
	}
}
