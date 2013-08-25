/**
 * stats.as
 * https://github.com/mrdoob/Hi-ReS-Stats
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 * 
 *	addChild( new Stats() );
 *
 **/

package net.hires.debug {
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class Stats {	
		
		static protected const WIDTH : uint = 70;
		static protected const HEIGHT : uint = 120;
		
		static private var colors : Object = {
			bg : 0x000033,
			fps : 0xffff00,
			ms : 0x00ff00,
			mem : 0x00ffff,
			memmax : 0xff0070,
			triangles : 0xffffff
		};
		
		static protected var xml : XML;
		
		static protected var text : TextField;
		static protected var style : StyleSheet;
		
		static protected var time : uint;
		static protected var ms : uint;
		static protected var ms_prev : uint;
		static protected var mem : Number;
		static protected var mem_max : Number;
		
		static private  var numFrames: int= 0;
		static private  var updateTime: int= 0;
		static private  var framerate: int= 0;
		
		static public var triangles : uint;
		
		static protected var fps_graph : uint;
		static protected var mem_graph : uint;
		static protected var mem_max_graph : uint;
		
		static private var textLength:int;
		static private var stage:Stage;
		static private var sprite:Sprite;
		
		public static function get frameNumber():int { return numFrames; }
		public static function get fps():int { return framerate; }

		static private function hex2css( color : int ) : String { return "#" + color.toString(16); }
		
		/**
		 * <b>Stats</b> FPS, MS and MEM, all in one.
		 */
		static public function initialize(stage:Stage) : void {
			Stats.stage = stage;
			
			mem_max = 0;
			
			xml = <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax><triangles>TRI:</triangles></xml>;
			
			style = new StyleSheet();
			style.setStyle('xml', {fontSize:'9px', fontFamily:'_sans', leading:'-2px'});
			style.setStyle('fps', {color: hex2css(colors.fps)});
			style.setStyle('ms', {color: hex2css(colors.ms)});
			style.setStyle('mem', {color: hex2css(colors.mem)});
			style.setStyle('memMax', {color: hex2css(colors.memmax)});
			style.setStyle('triangles', {color: hex2css(colors.triangles)});
			
			textLength = xml.children().length() * 12;
			text = new TextField();
			text.width = WIDTH;
			text.height = textLength;
			text.styleSheet = style;
			text.condenseWhite = true;
			text.selectable = false;
			text.mouseEnabled = false;
			
			sprite = new Sprite();
			
			stage.addChild(sprite);
			
			sprite.graphics.beginFill(colors.bg);
			sprite.graphics.drawRect(0, 0, WIDTH, HEIGHT);
			sprite.graphics.endFill();
			
			sprite.addChild(text);
			
			sprite.graphics.drawRect(0, textLength, WIDTH, HEIGHT - textLength);
			
			framerate = stage.frameRate;
			
			restart();
		}
		
		static public function destroy(e : Event) : void {
			sprite.graphics.clear();
			while(sprite.numChildren > 0) sprite.removeChildAt(0);			
		}
		
		static public function restart() : void {
			updateTime = time;
			numFrames = 0;
		}
		
		static public function update() : void {
			
			++numFrames;
			
			time = getTimer();
			
			if ((time - updateTime) >= 1000.) {
				
				framerate = numFrames / ((time - updateTime) / 1000.);
				
				ms_prev = time;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				mem_max = mem_max > mem ? mem_max : mem;
				
				xml.fps = "FPS: " + framerate  + " / " + stage.frameRate; 
				xml.mem = "MEM: " + mem;
				xml.memMax = "MAX: " + mem_max;
				xml.triangles = "TRI: " + (triangles || 0);		
				
				numFrames = 0;
				updateTime = time;
			}
			
			xml.ms = "MS: " + (time - ms);
			ms = time;
			
			text.htmlText = xml;
		}
	}
}