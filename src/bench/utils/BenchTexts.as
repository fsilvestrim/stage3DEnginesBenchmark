package bench.utils
{
	import bench.core.BenchConst;
	import bench.core.IBenchmarked;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class BenchTexts
	{
		private static var stage:Stage;
		
		public static var textOptions:TextField;
		public static var textResults:TextField;
		public static var textRunning:TextField;
		
		static public function initialize(stage:Stage) : void
		{
			BenchTexts.stage = stage;
			
			textOptions = new TextField();
			textOptions.defaultTextFormat = new TextFormat('Arial', 12, 0xffffff);
			textOptions.width = 300;
			textOptions.multiline = true;
			textOptions.wordWrap = true;
			textOptions.selectable = false;
			textOptions.height = 400;
			textOptions.mouseEnabled = false;
			
			textResults = new TextField();
			textResults.defaultTextFormat = new TextFormat('Arial', 12, 0x00ffff);
			textResults.width = 300;
			textResults.multiline = true;
			textResults.wordWrap = true;
			textResults.selectable = false;
			textResults.height = 200;
			textResults.mouseEnabled = false;
			
			textRunning = new TextField();
			textRunning.defaultTextFormat = new TextFormat('Arial', 20, 0x0, true, null, null, null, null, 'center');
			textRunning.text = 'BENCHMARK RUNNING';
			textRunning.height = 30;
			textRunning.width = 500;
			textRunning.background = true;
			textRunning.backgroundColor = 0xff0000;
			textRunning.selectable = false;
			textRunning.mouseEnabled = false;
			textRunning.visible = false;
			
			stage.addChild(textOptions);
			stage.addChild(textResults);
			stage.addChild(textRunning);
			
			stage.addEventListener(Event.RESIZE, resizeHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, mouseUpHandler);
			
			resizeHandler();
		}
		
		static private function mouseUpHandler(event:KeyboardEvent):void {
			textRunning.visible = false;
		}
		
		static public function resizeHandler(event:Event = null):void {
			textOptions.y = 0;
			textOptions.x = stage.stageWidth - textOptions.width;
			
			textResults.y = stage.stageHeight - textResults.height;
			textResults.x = stage.stageWidth - textResults.width;
			
			textRunning.y = stage.stageHeight - textRunning.height;
			textRunning.width = stage.stageWidth;
		}
		
		static public function updateTests():void {
			textOptions.htmlText = 'Current Benchmark: <b>' + BenchConst.CURRENT_NAME + '</b><br/>';
			textOptions.htmlText += 'Animation Mode: <b>' + BenchConst.ANIMATE_CURRENT + ' (keypad 1, 2 or 3)</b><br/>';
			if(BenchInfos.currentBench){
				textOptions.htmlText += 'Tests: ';
				textOptions.htmlText += '<ul>';
				for (var i:String in BenchConst.BENCHMARK_TEST) 
					textOptions.htmlText += '<li>Key ' + i + ' => ' + BenchConst.BENCHMARK_TEST[i].name + '</li>'; 
				textOptions.htmlText += '</ul>';
			}
			textOptions.htmlText += '----------------------------------------'; 
			textOptions.htmlText += 'Benchmarks: '; 
			textOptions.htmlText += '<ul>';
			for (var j:String in BenchConst.BENCHMARK_ENGINE) 
				textOptions.htmlText += '<li>Key ' + BenchConst.BENCHMARK_ENGINE[j].key + ' => ' + BenchConst.BENCHMARK_ENGINE[j].name + '</li>';
			textOptions.htmlText += '</ul>';
			textOptions.htmlText += '----------------------------------------'; 
		}
		
		static public function updateBenchmark() : Boolean {
			if(BenchInfos.loopIterations <= BenchConst.NUM_ITERATIONS) {
				var perc : int = int((BenchInfos.loopIterations/BenchConst.NUM_ITERATIONS)*100);
				var percE:String = '';
				for (var i:int = 0; i < 20; i++) percE += (perc*.2) >= i ? '=' : '~';
				textResults.htmlText = 'BENCHMARK RESULTS: ';
				textResults.htmlText += '[' + percE + '] = ' + perc + '%';
			} else if (BenchInfos.loopIterations >= BenchConst.NUM_ITERATIONS) {
				textResults.htmlText = 'BENCHMARK RESULTS: ';
				textResults.htmlText += BenchInfos.benchResult;
				textResults.htmlText += 'FPS Average: ' + int(BenchInfos.avgFPS/BenchConst.NUM_ITERATIONS);
				textRunning.visible = false;
				return true;
			}
			return false;
		}
		
		public static function cancelRendering():void {
			hideRunning();
			textResults.htmlText = 'BENCHMARK REVOKED';
		}
		
		public static function hideRunning():void {
			textRunning.visible = false;
		}
	}
}