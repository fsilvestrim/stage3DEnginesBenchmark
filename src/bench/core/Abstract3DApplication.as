package bench.core
{
	import bench.utils.BenchInfos;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import net.hires.debug.Stats;
	
	public class Abstract3DApplication extends Sprite
	{
		private var _tests					: Array = [];
		private var _info					: Object;
		protected var _textCount			: uint = 0;
		protected var _objCount				: uint = 0;
		protected var _running				: Boolean = false;
		protected var _bitFlags				: int = 0;
		protected var _meshCash				: Array = [];
		protected var _matCash				: Dictionary = new Dictionary();
		private var _specificAnimations		: Dictionary = new Dictionary();
		
		public function get tests():Array				{ return _tests;}
		public function get info():Object				{ return _info; }
		public function set info(value:Object):void		{ _info = value; }

		protected function getNextMesh() 	: * { return _meshCash[_objCount%BenchConst.NUM_AIRCRAFTS]; }
		public function addTest(numObjects:int, type:int, translate:Boolean):void { _tests.push([numObjects, type, translate]); }
		protected function startTests() : void {
			_running = true;
			
			for each (var a:Array in tests) 
				for (var i:int = 0; i < a[0]; i++)
					addPrimitive(a[1], a[2]);
		}
		
		protected function hasBitFlags(flags:int):Boolean					{ return (_bitFlags & flags) == flags; }
		protected function addPrimitive(type:int, translate:Boolean):void 	{ throw new Error('Must be overridden'); }
		protected function enableFreeCamera(freeCamera:Boolean) : void 		{ throw new Error('Must be overridden'); }
		
		public function start() : void {
			if(!hasBitFlags(BenchConst.PROPERTY_PARSE))
				startTests();
		}
		
		public function stop() : void {
			_running = false;
			reset();
		}
		
		protected function reset () : void {
			_textCount 			= 0;
			_objCount			= 0;
			_bitFlags 			= 0;
			_meshCash			= [];
			_tests				= [];
			_matCash			= new Dictionary();
		}
		
		public function hasAnimation (name:String) :Boolean {
			return _specificAnimations[name] != null;
		}
		
		public function setAnimations(freeCamera:Boolean=false, specific:Array=null):void {
			_specificAnimations	= new Dictionary();
			for each (var i:String in specific) _specificAnimations[i] = true;
			enableFreeCamera(freeCamera)
		}
		
		protected function update() : void {
		}
	}
}