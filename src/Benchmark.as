package
{
	import bench.core.BenchConst;
	import bench.core.IBenchmarked;
	import bench.utils.Analyzer;
	import bench.utils.BenchInfos;
	import bench.utils.BenchTexts;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import net.hires.debug.Stats;
	
	[SWF(backgroundColor=0x0)]
	public class Benchmark extends Sprite
	{
		private var timer : Timer = new Timer(0);
		private var frame:int = 0;
		
		/**
		 * Missing: ENV map
		 * Benchmarks:
		 * - drawcalls
		 * - Memory
         * - With debugger
		 * - Release Version
		 * - SOFTWARE Mode
		 * - diff computers
		 */		
		public function Benchmark() {
			if (stage)	initialize();
			else		stage.addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		protected function initialize(event:Event = null):void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			
			stage.removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, mouseDownHandler);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
			timer.addEventListener(TimerEvent.TIMER, timerHandler);
			
			BenchConst.initialize();
			Stats.initialize(stage);
			BenchTexts.initialize(stage);
			BenchInfos.initialize(stage);
			BenchTexts.updateTests();
		}
		
		protected function onEnterFrameHandler(event:Event):void {
			if(!BenchInfos.currentBench) return;
			
			Stats.triangles = BenchInfos.currentBench.numTriangles;
			Stats.update();
			
			if(!BenchInfos.analysing) return;
		}
		
		private function startNewBenchmark(keyCode:int):void {
			//animate option //keypad
			if(keyCode >= 97 && keyCode <= 105)
				BenchConst.ANIMATE_CURRENT = BenchConst.ANIMATE_OPTIONS[keyCode-97] || null; 
			
			//get new benchmark
			var newBench : IBenchmarked = BenchConst.BENCHMARK_ENGINE[keyCode] ? new BenchConst.BENCHMARK_ENGINE[keyCode].clazz() : null;
			
			//create new benchmark or start test
			if(newBench) {
				//dispose current benchmark
				BenchInfos.disposeIfNeeded();
				BenchInfos.currentBench = newBench;
				BenchInfos.currentBench.info = BenchConst.BENCHMARK_ENGINE[keyCode];
				newBench = null;
			} else if (BenchInfos.currentBench && BenchConst.BENCHMARK_TEST[String.fromCharCode(keyCode).toUpperCase()] ){
				startBenchmarkTest(String.fromCharCode(keyCode).toUpperCase());
			}
		}
		
		public function startBenchmarkTest(testKeyString:String):void {
			Stats.restart();
			BenchInfos.avgFPS 			= 0;
			BenchInfos.analysing 		= true;
			//BenchInfos.currentTestNr 	= testNumber;
			cleanAllPreviuosSettings();
			
			//benchmark start
			Analyzer.start(BenchConst.CURRENT_NAME + ", test. " + null + " ");
			
			//test
			BenchConst.BENCHMARK_TEST[testKeyString].test(BenchInfos.currentBench);
			BenchInfos.currentBench.start();
			
			//benchmark end
			BenchInfos.benchResult = bench.utils.Analyzer.end();
			
			//timer analyser stops
			timer.start();
		}
		
		private function cleanAllPreviuosSettings():void {
			frame = 0;
			BenchInfos.currentBench.resetContainer();
			BenchInfos.currentBench.setAnimations(false);
			BenchInfos.currentBench.setProperties(0);
		}
		
		protected function timerHandler(event:TimerEvent):void {
			BenchInfos.loopIterations++;
			BenchInfos.avgFPS += Stats.fps;
			
			var done : Boolean = BenchTexts.updateBenchmark();
			
			if (done) {
				BenchInfos.currentBench.stop();
				cancelRendering(false);
			}
		}
		
		private function cancelRendering(cleanText : Boolean) : void {
			BenchInfos.currentBench.stop();
			BenchInfos.cancelRendering(cleanText); 
			timer.stop();
		}
		
		protected function mouseDownHandler(event:KeyboardEvent):void {
			if(event.keyCode == 27) 		cancelRendering(true); //ESC
			if(BenchInfos.isAnalysing()) 	return;
			
			startNewBenchmark(event.keyCode);
			
			//update text
			BenchTexts.updateTests();
		}
	}
}