package bench.away
{
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.lights.DirectionalLight;
	import away3d.lights.PointLight;
	
	import bench.core.Abstract3DApplication;
	import bench.core.BenchConst;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	public class Away3DExampleApplication extends Abstract3DApplication
	{
		private var _view				: View3D;
		private var _scene				: Scene3D;
		private var _camera				: Camera3D;
		private var _cameraController	: HoverController;
		
		private var _lastPanAngle		: Number;
		private var _lastTiltAngle		: Number;
		private var _lastMouseX			: Number;
		private var _lastMouseY			: Number;
		private var _move				: Boolean;
		
		private var _sceneContainer		: ObjectContainer3D;
		private var _stage				: Stage;
		
		protected var _light			: PointLight;
		protected var _dirLight			: DirectionalLight;
		
		protected function get viewport() 	: View3D				{ return _view; }
		protected function get camera() 	: Camera3D				{ return _camera; }
		protected function get container() 	: ObjectContainer3D		{ return _sceneContainer; }
		
		public function get numTriangles () : int 					{ return _view.renderedFacesCount; }
		
		public function initialize(stage:Stage) : void
		{
			_stage 				= stage;
			
			_scene 				= new Scene3D();
			
			_camera 			= new Camera3D();
			_camera.lens.near	= .02;
			_camera.lens.far	= 500000;
			_camera.z 			= -6000;
			
			_view 					= new View3D();
			_view.scene 			= _scene;
			_view.camera 			= _camera;
			_view.backgroundColor 	= BenchConst.COLOR_BACKGROUND;
			stage.addChild(_view);
			
			_cameraController 			= new HoverController(_camera, null, 0, 0, 600, -90, 90);
			_cameraController.yFactor 	= 1;
			_cameraController.distance 	= 6000;
			
			resetContainer();
			
			_cameraController.lookAtObject = _sceneContainer;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(Event.RESIZE, onResize);
			
			onResize();
		}
		
		override public function start():void {
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			super.start();
		}
		
		override public function stop():void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			super.stop();
		}
		
		override protected function enableFreeCamera (value:Boolean) : void {
			_cameraController.autoUpdate = value;
		}
		
		public function resetContainer () : void {
			reset();
			if(_sceneContainer) _scene.removeChild(_sceneContainer);
			_sceneContainer = new ObjectContainer3D();
			_scene.addChild(_sceneContainer);
		}
		
		private function onResize(event:Event = null):void {
			_view.width = _stage.stageWidth;
			_view.height = _stage.stageHeight;
		}
		
		private function onEnterFrame(e:Event):void {
			super.update();
			
			if(_running && !BenchConst.FREE_CAMERA) {
				if(hasAnimation(BenchConst.ANIMATE_GROUP)) 				{ 
					container.rotationY += 1; 
				} else if(hasAnimation(BenchConst.ANIMATE_CAMERA)) 		{ 
					_cameraController.panAngle += 2;
					_cameraController.update(); 
				} else if(hasAnimation(BenchConst.ANIMATE_UNITIES)) 		{ 
					for (var i:int = 0; i < _sceneContainer.numChildren; i++) 
						_sceneContainer.getChildAt(i).rotate(new Vector3D(1,1,1), 2);
				}
				
				if(hasAnimation(BenchConst.ANIMATE_LIGHT) && _dirLight != null) 	{ _dirLight.rotate(new Vector3D(1,1,1), 1); }
			}
			
			if (_move) {
				_cameraController.panAngle = 0.3 * (_stage.mouseX - _lastMouseX) + _lastPanAngle;
				_cameraController.tiltAngle = 0.3 * (_stage.mouseY - _lastMouseY) + _lastTiltAngle;
			}
			
			_view.render();
		}
		
		private function onMouseDown(event:MouseEvent):void {
			_lastPanAngle = _cameraController.panAngle;
			_lastTiltAngle = _cameraController.tiltAngle;
			_lastMouseX = _stage.mouseX;
			_lastMouseY = _stage.mouseY;
			_move = true;
			_stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		private function onMouseUp(e:MouseEvent):void {
			_move = false;
			_stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);    
		}
		
		private function onStageMouseLeave(event:Event):void {
			_move = false;
			_stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}
		
		private function onMouseWheel(event:MouseEvent) : void {
			_cameraController.distance -= event.delta*50;
			
			if (_cameraController.distance < 400)			_cameraController.distance = 400;
			else if (_cameraController.distance > 10000)	_cameraController.distance = 10000;
		}
		
		public function dispose () : void {
			stage.removeChild(_view);
			
			_cameraController = null;
			
			_scene.removeChild(_sceneContainer);
			_sceneContainer.dispose();
			
			_view.dispose();
			_view = null;
			
			_camera.dispose();
			_camera = null;
			
			_scene = null;
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.removeEventListener(Event.RESIZE, onResize);
		}
		
		protected function initProperties(properties:int, numTextures:int):void {
			if(_light == null){
				_light = new PointLight();
				_light.color = BenchConst.COLOR_LIGHT;
				_dirLight = new DirectionalLight(0,-1,0);
				_dirLight.ambient = 0.1;
				_dirLight.diffuse = 0.7;
				_dirLight.color = 0xffffffff;
				_dirLight.castsShadows = true;
			}
			_textCount = numTextures;
			_bitFlags = properties;
		}
	}
}