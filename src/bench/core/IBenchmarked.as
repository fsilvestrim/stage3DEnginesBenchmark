package bench.core
{
	import flash.display.Stage;
	import flash.events.Event;

	public interface IBenchmarked
	{
		function get tests():Array;
		function get numTriangles () : int;
		function get info () : Object;
		function set info (value : Object) :void;
		
		function initialize (stage:Stage) : void;
		function dispose () : void;
		
		function resetContainer() : void;
		
		function setAnimations(freeCamera:Boolean = false, specific:Array=null) : void;
		function setProperties(properties:int, numTextures:int=0) : void;
		
		function addTest(numObjects:int, type:int, translate:Boolean):void;
		
		function start():void;
		function stop():void;
	}
}