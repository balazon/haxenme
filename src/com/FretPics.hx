package com;
import nme.display.Sprite;
import nme.geom.Rectangle;
import nme.display.Bitmap;

/**
 * ...
 * @author Valentin
 */
class FretPics extends Sprite
{
	var inited: Bool = false;
	
	var size: Int;
	
	var nu_pic: Array<Bitmap>;
	var np_pic: Array<Bitmap>;
	
	public function new() 
	{
		super();
	}
	
	public function init(size: Int, pos: Rectangle): Void
	{
		if (inited) return;
		else inited = true;
		
		this.size = size;
		
		nu_pic = new Array<Bitmap>();
		np_pic = new Array<Bitmap>();
		for (i in 0...size) {
			nu_pic[i] = new Bitmap(nme.Assets.getBitmapData("img/n" + (i + 1) + "u.png"));
			np_pic[i] = new Bitmap(nme.Assets.getBitmapData("img/n" + (i + 1) + "p.png"));
			addChild(nu_pic[i]);
			addChild(np_pic[i]);
			np_pic[i].visible = false;
		}
		resized(pos);
		
	}
	
	public function resized(pos: Rectangle): Void
	{
		for (i in 0...size) {
			nu_pic[i].width = pos.width / size;
			np_pic[i].width = pos.width / size;
			nu_pic[i].height = pos.height;
			np_pic[i].height = pos.height;
			nu_pic[i].x = pos.x + i * pos.width / size;
			np_pic[i].x = pos.x + i * pos.width / size;
			nu_pic[i].y = pos.y;
			np_pic[i].y = pos.y;
		}
	}
	
	public function refreshPics(fretButtons: Array<Bool>): Void
	{
		for (i in 0...size) {
			if (fretButtons[i] == true) {
				np_pic[i].visible = true;
				nu_pic[i].visible = false;
			}else {
				np_pic[i].visible = false;
				nu_pic[i].visible = true;
			}
		}
	}
}