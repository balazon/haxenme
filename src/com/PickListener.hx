package com;

/**
 * ...
 * @author Valentin
 */
interface PickListener
{
	public function onPicked(): Void;
	public function onPickReleased(): Void;
}