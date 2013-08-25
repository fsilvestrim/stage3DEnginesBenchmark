package bench.flare
{
	import bench.core.Abstract3DApplication;
	import bench.core.BenchConst;
	
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Camera3D;
	import flare.core.Light3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.loaders.ColladaLoader;
	import flare.system.Device3D;
	import flare.system.Input3D;
	import flare.utils.Vector3DUtils;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	public class FlareExampleApplication extends Abstract3DApplication
	{
		private var _scene:Viewer3D;
		private var _out:Vector3D = new Vector3D();
		private var _freeCamera:Boolean;
		private var _container:Mesh3D;
		
		protected var _light		: Light3D;
		private var _triangles		: int = -1;
		private var _cameraDistance	: int = 300;
		
		protected function get camera() : Camera3D						{ return _scene.camera; }
		protected function get scene() : Scene3D						{ return _scene; }
		protected function get container() : Mesh3D						{ return _container; }
	
		public function get numTriangles () : int 						{ return _triangles; }
		
		public function initialize(stage:Stage) : void {
			_container = new Mesh3D();
			_scene = new Viewer3D(stage);
			
			_scene.showLogo = false;
			_scene.registerClass( ColladaLoader );
			_scene.autoResize = true;
			_scene.antialias = 2;
			_scene.camera = new Camera3D();
			_scene.camera.setPosition( 0, 0, -700 );
			
			var bgColor : Object = getColor(BenchConst.COLOR_BACKGROUND);
			_scene.clearColor = new Vector3D(bgColor.r, bgColor.b, bgColor.g);
			
			scene.lights.defaultLight = null;
			scene.lights.maxPointLights = 1;
			scene.lights.maxDirectionalLights = 1;
			
			_scene.addChild(_container);
			_scene.addEventListener( Scene3D.UPDATE_EVENT, enterFrameHandler );
		}
		
		public function initProperties(properties:int, numTextures:int):void {
			if(_light == null){
				var pointColor : Object = getColor(BenchConst.COLOR_AMBIENT_LIGHT);
				_light = new Light3D('', Light3D.POINT);
				_light.infinite = true;
				_light.color = new Vector3D( pointColor.r, pointColor.g, pointColor.b )
				_light.setPosition(-_cameraDistance, _cameraDistance, -_cameraDistance);
			}
			_bitFlags = properties;
			_textCount = numTextures;
		}
		
		public function resetContainer () : void {
			reset();
			
			for each (var i:Pivot3D in _container.children)
				_container.removeChild(i);
		}
		
		public function dispose () : void {
			resetContainer();
			
			_scene.pause();
			_scene.removeEventListener( Scene3D.UPDATE_EVENT, enterFrameHandler );
			_scene.parent = null;
			_scene.endFrame();
			_scene = null;
		}
		
		override protected function enableFreeCamera(value:Boolean) : void {
			_freeCamera = value;
		}
		
		protected function enterFrameHandler(event : Event) : void {
			_triangles = Device3D.trianglesDrawn;
			
			if(_running && !BenchConst.FREE_CAMERA) {
				if(hasAnimation(BenchConst.ANIMATE_GROUP)) 				{ 
					_container.rotateY(1); 
				} else if(hasAnimation(BenchConst.ANIMATE_CAMERA)) 		{ 
					camera.rotateY(1, true, Vector3DUtils.ZERO); 
				} else if(hasAnimation(BenchConst.ANIMATE_UNITIES)) 	{
					for each (var i:Pivot3D in _container.children)
						i.rotateAxis(1, new Vector3D(1,1,1));
				}
				
				if(hasAnimation(BenchConst.ANIMATE_LIGHT) && _light != null) 	{
					_light.x = Math.cos( getTimer() / 1000 ) * _cameraDistance;
					_light.y = _cameraDistance
					_light.z = Math.sin( getTimer() / 1000 ) * _cameraDistance;
				}
			}
			
			if (!_freeCamera) return;
			
			// simple orbit camera.
			if ( Input3D.mouseDown ) {
				camera.rotateY( Input3D.mouseXSpeed * 0.1, true, Vector3DUtils.ZERO );
				camera.rotateX( Input3D.mouseYSpeed * 0.1, true, Vector3DUtils.ZERO );
			}
			
			if ( Input3D.delta != 0 ) camera.translateZ( camera.getPosition( false, _out ).length * Input3D.delta / 20 );
		}
		
		private function getColor (color:uint) : Object { 
			var result : Object = {};
			result.r = (color >>> 16) / 255.;
			result.g = ((color >> 8) & 0xff) / 255.;
			result.b = (color & 0xff) / 255.;
			return result;
		}
	}
}