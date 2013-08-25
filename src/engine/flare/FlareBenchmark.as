package bench.flare
{
	import bench.core.BenchConst;
	import bench.core.IBenchmarked;
	import bench.flare.utils.CubesMesh;
	
	import flare.basic.Scene3D;
	import flare.core.Mesh3D;
	import flare.core.Particles3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.flsl.FLSLMaterial;
	import flare.loaders.ColladaLoader;
	import flare.materials.Material3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.AlphaMaskFilter;
	import flare.materials.filters.ColorFilter;
	import flare.materials.filters.LightFilter;
	import flare.materials.filters.SkinTransformFilter;
	import flare.materials.filters.SpecularFilter;
	import flare.materials.filters.SpecularMapFilter;
	import flare.materials.filters.TextureMapFilter;
	import flare.primitives.Cube;
	import flare.primitives.Plane;
	import flare.primitives.Quad;
	
	import flash.display.BlendMode;
	import flash.display.Stage;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class FlareBenchmark extends FlareExampleApplication implements IBenchmarked
	{

		private var bloomQuad:Quad;
		private var bloomTexture:Texture3D;

		private var _mat:Shader3D;
		
		public function setProperties(properties:int, numTextures:int=0):void {
			super.initProperties(properties, numTextures);
			
			
			if(hasBitFlags(BenchConst.PROPERTY_PARSE)) {
				super.initProperties(properties, BenchConst.NUM_AIRCRAFTS);
				var loader : ColladaLoader;
				for (var i:int = 1; i <= numTextures; i++) {
					loader = new ColladaLoader( XML(new BenchConst['OBJ_PLANE_' + i]()), null, scene, "", false, Context3DTriangleFace.BACK );
					loader.addEventListener(Scene3D.COMPLETE_EVENT, completeEvent);
					loader.load();
				}
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_BLOOM)) {
				bloomTexture = new Texture3D( new Point( 256, 256 ), true );
				var bloomMaterial : FLSLMaterial = new FLSLMaterial( "bloom", new BenchConst.SHADER_FLARE_BLOOM );
				bloomMaterial.params.bloomTexture.value = bloomTexture;
				bloomMaterial.params.intensity.value[0] = 3;
				bloomMaterial.params.power.value[0] = 2;
				bloomQuad = new Quad( "bloom", 0, 0, 0, 0, true, bloomMaterial );
			}
		}
		
		protected function completeEvent(event:Event):void {
			var loader : ColladaLoader = event.currentTarget as ColladaLoader;
			loader.removeEventListener(Scene3D.COMPLETE_EVENT, completeEvent);
			var mesh : Mesh3D = loader.children[1] as Mesh3D;
			if(mesh) _meshCash.push(mesh);
			if(_meshCash.length >= BenchConst.NUM_AIRCRAFTS) {
				startTests();
			}
		}
		
		override protected function enterFrameHandler(event:Event):void {
			super.enterFrameHandler(event);
			
			if(hasBitFlags(BenchConst.PROPERTY_BLOOM)) {
				scene.render( scene.camera, false, bloomTexture );
				bloomQuad.draw();
			}
		}
		
		private function getTex (texName:String, unique:Boolean=false) : Texture3D {
			if(unique) return new Texture3D(new BenchConst[texName]().bitmapData);
			return _matCash[texName] ||= getTex(texName, true);
		}
		
		private function getMaterial() : Material3D {
			if(_mat != null && _textCount == 0) return _mat;
			
			_mat = new Shader3D('baseMaterial', null, hasBitFlags(BenchConst.PROPERTY_LIGHT));
			var tex : Texture3D;
			var texName : String;
			
			_mat.filters.push( new ColorFilter( BenchConst.COLOR_MATERIAL, .5, BlendMode.MULTIPLY ) );
			
			if(hasBitFlags(BenchConst.PROPERTY_PARSE | BenchConst.PROPERTY_MULTIPLE_TEXTURES)) {
				_mat.filters.push( new TextureMapFilter( getTex('TEXTURE_AIRPLANE_' + ((_objCount%BenchConst.NUM_AIRCRAFTS)+1) ) ) );
			} else if(hasBitFlags(BenchConst.PROPERTY_PARSE | BenchConst.PROPERTY_UNIQUE_TEXTURES)) {
				_mat.filters.push( new TextureMapFilter( getTex('TEXTURE_AIRPLANE_' + ((_objCount%BenchConst.NUM_AIRCRAFTS)+1), true ) ) );
			} else if(hasBitFlags(BenchConst.PROPERTY_UNIQUE_TEXTURES)) {
				_mat.filters.push( new TextureMapFilter( getTex('TEXTURE_'+((_objCount%50) + 1, true)) ) );
			} else if(hasBitFlags(BenchConst.PROPERTY_MULTIPLE_TEXTURES)) {
				_mat.filters.push( new TextureMapFilter( getTex('TEXTURE_'+((_objCount%50) + 1)) ) );
			} else if(hasBitFlags(BenchConst.PROPERTY_ALPHA)) {
				_mat.filters.push( new TextureMapFilter( getTex('TEXTURE_ALPHA') ) );
				_mat.filters.push( new AlphaMaskFilter( 1 ) );
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_PARSE | BenchConst.PROPERTY_SPECULAR)) {
				_mat.filters.push( new SpecularMapFilter(getTex('TEXTURE_AIRPLANE_SPEC'), 200, 10 ) );
			} else if(hasBitFlags(BenchConst.PROPERTY_SPECULAR)) {
				_mat.filters.push( new SpecularMapFilter(getTex('TEXTURE_SPECULAR'), 200, 10 ) );
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_SPRITESHEET)) {
				//_mat.filters.push( new TextureMapFilter( getTex('TEXTURE_EXPLOSION') ) );
				//needs to write a shader for it
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_SHADOW)) {
				//needs to write a shader for it
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_LIGHT)) {
				scene.addChild(_light);
				scene.lights.techniqueName = LightFilter.LINEAR;
			} else if(scene.getChildByName(_light.name) != null) {
				scene.removeChild(_light);
				scene.lights.techniqueName = LightFilter.NO_LIGHTS
			}
			
			_mat.build();
			
			return _mat;
		}
		
		override protected function addPrimitive(type:int, translate:Boolean):void {
			var primitive 	: Pivot3D;
			var mat 		: Material3D = getMaterial();
			
			switch(type) {
				case BenchConst.TYPE_OBJ:
					primitive = (getNextMesh() as Mesh3D).clone() as Mesh3D;
					primitive.setMaterial(mat);
					primitive.setScale(.2, .2, .2);
					break;
				case BenchConst.TYPE_CUBE: 
					primitive = new Cube('', 10, 10, 10, 1, mat);
					break;
				case BenchConst.TYPE_PLANE: 
					mat.twoSided = true;
					primitive = new Plane('', 10, 10, 1, mat);
					break;
				case BenchConst.TYPE_PARTICLE:
					primitive = new CubesMesh();
					for (var i:int = 0; i < BenchConst.NUM_PARTICLES; i++) 
						(primitive as CubesMesh).addCube( Math.random() * 1000 - 500, Math.random() * 1000 - 500, Math.random() * 1000 - 500, 5, Math.random() * 0.99 + 0.01 );
					translate = false;
					break;
			}
			
			if(primitive == null) return;
			
			//postSpecial(primitive);
			
			if(translate){
				var scale : int = 200;
				primitive.x = -(1*scale) + Math.random() * (2*scale);
				primitive.y = -(1*scale) + Math.random() * (2*scale);
				primitive.z = -(1*scale) + Math.random() * (2*scale);
				//primitive.rotateX(90);
			}
			
			container.addChild(primitive);
			
			_objCount++;
		}
	}
}