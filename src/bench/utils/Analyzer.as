package bench.utils
{
	import flash.utils.getTimer;
	
	public class Analyzer 
	{
		static private var _t0:Array = [];
		static private var _block:Array = [];
		
		static public function test(p_steps:Number,p_f0:Function,... p_args):Number
		{
			var t0:Number = getTimer();
			var i:int;
			
			for (i = 0; i < p_steps; i++) p_f0.apply(null, p_args);
			
			return getTimer() - t0;
		}
		
		static public function compare(p_steps:Number,p_test0:String, p_f0:Function, p_arg0:Array, p_test1:String, p_f1:Function, p_arg1:Array):String
		{
			
			var dt0:Number=0;
			var dt1:Number=0;
			var t0:Number;
			var i:int;
			var k:int;
			var avg_step:Number = 10;
			
			for (k = 0; k < avg_step; k++)
			{
				if (k & 1)
				{
					t0 = getTimer();
					for (i = 0; i < p_steps; i++) p_f0.apply(null, p_arg0);
					dt0 += getTimer() - t0;
					
					t0 = getTimer();
					for (i = 0; i < p_steps; i++) p_f1.apply(null, p_arg1);
					dt1 += getTimer() - t0;
				}
				else
				{
				
					t0 = getTimer();
					for (i = 0; i < p_steps; i++) p_f1.apply(null, p_arg1);
					dt1 += getTimer() - t0;
					
					t0 = getTimer();
					for (i = 0; i < p_steps; i++) p_f0.apply(null, p_arg0);
					dt0 += getTimer() - t0;
					
				}
			}
			dt0 /= avg_step;
			dt1 /= avg_step;
			var ratio_log:String = "";
			var r:Number = (dt0 < dt1) ? (dt1/dt0) : (dt0/dt1);
			
			if (Math.abs(1 - r) < 0.01)
			{
				ratio_log = "["+p_test0 + "] as fast as [" + p_test1+"]";
			}
			else
			{
				var fast:String = (dt0 < dt1) ? p_test0 : p_test1;
				var slow:String = (dt0 < dt1) ? p_test1 : p_test0;				
				ratio_log = "["+fast + "] is " + (r.toFixed(2)) + "x faster than [" + slow+"]";
			}
			
			var log:String = "Benchmark @ " + p_steps + " steps> [" + p_test0 + ": " + dt0 + " ms] [" + p_test1 + ": " + dt1 + " ms] "+ratio_log;
			return log;
		}
		
		static public function start(p_block:String=""):void
		{
			_t0.push(getTimer());
			_block.push(p_block);
		}
		
		static public function end():String
		{
			if (_t0.length <= 0) return "";
			var s:String = _block.pop() + "> " + (getTimer() - Number(_t0.pop())) + "ms";
			trace(s);
			return s;
		}
	}
}