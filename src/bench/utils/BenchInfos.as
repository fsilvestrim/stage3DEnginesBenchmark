package bench.utils
{
	import bench.core.IBenchmarked;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;

	public class BenchInfos
	{
		public static var analysing			: Boolean		= false;
		public static var loopIterations	: int			= 0;
		public static var avgFPS			: Number		= 0;
		public static var benchResult		: String		= "";
		
		private static var stage			: Stage;
		private static var _currentBench 	: IBenchmarked	= null;
		public static var currentTestNr:uint;
		
		public static function get currentBench():IBenchmarked				{ return _currentBench; }
		public static function set currentBench(value:IBenchmarked):void 	{
			_currentBench = value;
			_currentBench.initialize(stage);
			stage.addChild(_currentBench as DisplayObject);
		}

		public static function cancelRendering(cleanText : Boolean):void {
			loopIterations = 0;
			analysing = false;
			if(cleanText) BenchTexts.cancelRendering();
		}
		
		public static function isAnalysing():Boolean {
			if(analysing){
				BenchTexts.hideRunning();
			}
			return analysing;
		}
		
		public static function disposeIfNeeded():void {
			if(currentBench != null) {
				currentBench.dispose();
				stage.removeChild(currentBench as DisplayObject);
			}
		}
		
		public static function initialize(stage:Stage):void {
			BenchInfos.stage = stage; 
		}
	}
}