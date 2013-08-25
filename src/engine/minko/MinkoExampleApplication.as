package bench.minko
{
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.scene.node.light.PointLight;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import bench.core.Abstract3DApplication;
	import bench.core.BenchConst;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MinkoExampleApplication extends Abstract3DApplication
	{
		private var _viewport			: Viewport			= new Viewport();
		private var _camera				: Camera			= null;
		private var _cameraController	: ArcBallController	= null;
		private var _scene				: Scene				= new Scene();
		private var _cursor				: Point				= new Point();
		private var _stage				: Stage				= null;
		private var _group				: Group;
		
		protected var _light		: PointLight;
		protected var _dirLight		: DirectionalLight;
		protected var _ambLight		: AmbientLight;
		private var _cameraEnabled	: Boolean;
		
		private static const TMP_MATRIX : Matrix4x4 = new Matrix4x4();
		private static const EPSILON	: Number	= 0.001;
		private var _position			: Vector4	= new Vector4(0, 0, 0, 1);
		
		protected function get viewport() : Viewport					{ return _viewport; }
		protected function get camera() : Camera						{ return _camera; }
		protected function get cameraController() : ArcBallController	{ return _cameraController; }
		protected function get container() : Group						{ return _group; }
		protected function get scene() : Scene							{ return _scene; }
		
		public function get numTriangles () : int 						{ return _scene.numTriangles; }
		
		public function initialize(stage:Stage) : void
		{
			_stage = stage;
			_stage.addChild(_viewport);
			_viewport.backgroundColor = BenchConst.COLOR_BACKGROUND;
			
			_camera = new Camera();
			_cameraController = new ArcBallController();
			_cameraController.bindDefaultControls(_stage);
			_cameraController.minDistance 	= 1;
			_cameraController.distance 		= 3.8;
			_cameraController.yaw 			= Math.PI * -.5;
			_cameraController.pitch 		= Math.PI / 2;
			camera.addController(_cameraController);
			
			_group = new Group();
			_scene.addChild(_group);
			_scene.addChild(_camera);
			resetContainer();
		}
		
		
		override public function start():void {
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			super.start();
		}
		
		override public function stop():void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			super.stop();
		}
		
		override protected function enableFreeCamera(value:Boolean) : void {
			_cameraEnabled = value;
		}
		
		public function resetContainer () : void {
			reset();
			_group.removeAllChildren();
		}
		
		private function onEnterFrame(event : Event) : void {
			if(_running && !BenchConst.FREE_CAMERA) {
				if(hasAnimation(BenchConst.ANIMATE_LIGHT))			{ _dirLight.transform.appendRotation(0.01, Vector4.ONE); }
				
				if(hasAnimation(BenchConst.ANIMATE_GROUP)) 			{ 
					container.transform.appendRotation(0.04, Vector4.Y_AXIS); 
				} else if(hasAnimation(BenchConst.ANIMATE_UNITIES))	{
					for (var i:int = 0; i < _group.numChildren; i++) {
						_group.getChildAt(i).transform.lock();
						var tx : Vector4 = _group.getChildAt(i).transform.getTranslation().clone(); 
						_group.getChildAt(i).transform.setTranslation(0,0,0);
						_group.getChildAt(i).transform.appendRotation(0.04, Vector4.ONE);
						_group.getChildAt(i).transform.setTranslation(tx.x,tx.y,tx.z);
						_group.getChildAt(i).transform.unlock();
					}
				} else if(hasAnimation(BenchConst.ANIMATE_CAMERA)) 	{
					_cameraController.yaw += 0.025;
					
					_position.set(
						_cameraController.lookAt.x + _cameraController.distance * Math.cos(_cameraController.yaw) * Math.sin(_cameraController.pitch),
						_cameraController.lookAt.y + _cameraController.distance * Math.cos(_cameraController.pitch),
						_cameraController.lookAt.z + _cameraController.distance * Math.sin(_cameraController.yaw) * Math.sin(_cameraController.pitch)
					);
					
					TMP_MATRIX.lookAt(_cameraController.lookAt, _position, _cameraController.up);
					
					var numTargets : uint = _cameraController.numTargets;
					for (var targetId : uint = 0; targetId < numTargets; ++targetId)
						_cameraController.getTarget(targetId).transform.copyFrom(TMP_MATRIX); 
				}
			}
			
			_scene.render(_viewport);
			
			_cameraController.enabled = _cameraEnabled;
		}
		
		public function dispose () : void {
			resetContainer();
			_viewport.dispose();
			_stage.removeChild(_viewport);
			
			_camera = null;
			_cameraController = null;
		}
		
		public function initProperties(properties:int, numTextures:int):void {
			if(_light == null){
				_light = new PointLight(BenchConst.COLOR_LIGHT, 0.6, 0.8, 64, 5.);
				_dirLight = new DirectionalLight(BenchConst.COLOR_AMBIENT_LIGHT | 0x00FFFFFF, .7, .1);
				_dirLight.x = 0;
				_dirLight.y = -1;
				_dirLight.z = 0;
				_ambLight = new AmbientLight(BenchConst.COLOR_AMBIENT_LIGHT | 0x00FFFFFF, .05);
			}
			_bitFlags = properties;
			_textCount = numTextures;
		}
	}
}