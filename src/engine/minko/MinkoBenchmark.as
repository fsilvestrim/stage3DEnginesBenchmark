package bench.minko
{
	
	import aerys.minko.render.Effect;
	import aerys.minko.render.effect.hdr.HDREffect;
	import aerys.minko.render.effect.hdr.HDRQuality;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.QuadGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.render.material.phong.PhongProperties;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixTimeline;
	import aerys.minko.type.animation.timeline.ScalarTimeline;
	import aerys.minko.type.enum.ShadowMappingQuality;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	import aerys.minko.type.parser.collada.ColladaParser;
	
	import bench.core.BenchConst;
	import bench.core.IBenchmarked;
	import bench.minko.utils.PointsGeometry;
	import bench.minko.utils.PointsShader;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class MinkoBenchmark extends MinkoExampleApplication implements IBenchmarked
	{
		private var _mat			: Material;
		
		public function setProperties(properties:int, numTextures:int=0):void {
			super.initProperties(properties, numTextures);
			
			if(hasBitFlags(BenchConst.PROPERTY_PARSE)) {
				super.initProperties(properties, BenchConst.NUM_AIRCRAFTS);
				var loader : SceneLoader;
				var options : ParserOptions			= new ParserOptions();
				options.loadSkin					= false;
				options.mipmapTextures				= false;
				options.dependencyLoaderFunction	= null;
				options.parser						= ColladaParser;
				for (var i:int = 1; i <= numTextures; i++) {
					loader = new SceneLoader(options);
					loader.complete.add(onAssetComplete);
					loader.loadClass(BenchConst['OBJ_PLANE_' + i]);
				}
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_BLOOM)) {
				scene.postProcessingEffect = new HDREffect(HDRQuality.MEDIUM, 2);
				scene.postProcessingProperties.setProperties({
					hdrIntensity 	: 1,
					hdrExponent		: 1.2
				});
			}
		}
		
		private function onAssetComplete(loader : SceneLoader, result : Group) : void {
			var mesh : Mesh = ((result.getChildAt(0) as Group).getChildAt(1) as Group).getChildAt(0) as Mesh;
			if(mesh) _meshCash.push(mesh);
			if(_meshCash.length >= BenchConst.NUM_AIRCRAFTS) {
				startTests();
			}
		}
		
		private function getTex (texName:String, unique:Boolean=false) : TextureResource {
			if(unique) {
				var bmp : Bitmap = new (BenchConst[texName] as Class)();
				var tex : TextureResource = new TextureResource(bmp.width, bmp.height);
				tex.setContentFromBitmapData(bmp.bitmapData, true);
				return tex;
			}
			return _matCash[texName] ||= getTex(texName, true);
		}
		
		private function getMaterial() : Material {
			if(_mat != null && _textCount == 0) return _mat;
			
			_mat = new BasicMaterial({diffuseColor : BenchConst.COLOR_MATERIAL | 0x00FFFFFF});
			
			if(hasBitFlags(BenchConst.PROPERTY_LIGHT)) {
				_mat = new PhongMaterial(scene, {diffuseColor : BenchConst.COLOR_MATERIAL | 0x00FFFFFF});
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_PARSE | BenchConst.PROPERTY_MULTIPLE_TEXTURES)) {
				_mat.diffuseMap = getTex('TEXTURE_AIRPLANE_' + ((_objCount%BenchConst.NUM_AIRCRAFTS)+1));
			} else if(hasBitFlags(BenchConst.PROPERTY_PARSE | BenchConst.PROPERTY_UNIQUE_TEXTURES)) {
				_mat.diffuseMap = getTex('TEXTURE_AIRPLANE_' + ((_objCount%BenchConst.NUM_AIRCRAFTS)+1), true);
			} else if(hasBitFlags(BenchConst.PROPERTY_UNIQUE_TEXTURES)) {
				_mat.diffuseMap = getTex('TEXTURE_'+((_objCount%50) + 1), true);
			} else if(hasBitFlags(BenchConst.PROPERTY_MULTIPLE_TEXTURES)) {
				_mat.diffuseMap = getTex('TEXTURE_'+((_objCount%50) + 1));
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_PARSE | BenchConst.PROPERTY_SPECULAR)) {
				(_mat as PhongMaterial).specularMap = getTex('TEXTURE_AIRPLANE_SPEC');
				(_mat as PhongMaterial).specularMultiplier = 10;
			} else if(hasBitFlags(BenchConst.PROPERTY_SPECULAR)) {
				(_mat as PhongMaterial).specularMap = getTex('TEXTURE_SPECULAR');
				(_mat as PhongMaterial).specularMultiplier = 10;
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_SPRITESHEET)) {
				_mat.diffuseMap = getTex('TEXTURE_EXPLOSION');
				_mat.effect = new Effect(new PointsShader());
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_ALPHA)) {
				(_mat as PhongMaterial).diffuseMap = getTex('TEXTURE_ALPHA');
				(_mat as PhongMaterial).alphaThreshold = 1;
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_SHADOW)) {
				_dirLight.shadowCastingType			= ShadowMappingType.MATRIX;
				_dirLight.shadowMapSize				= 512;
				_dirLight.shadowQuality				= ShadowMappingQuality.HARD;
				
				scene.properties.setProperty(PhongProperties.SHADOW_BIAS, 1 / 256);
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_LIGHT)) {
				container.addChild(_light);
				container.addChild(_dirLight);
				container.addChild(_ambLight);
			}
			else if(container.contains(_light)) {
				container.removeChild(_ambLight);
				container.removeChild(_dirLight);
				container.removeChild(_light);
			}
			
			return _mat;
		}
		
		private function postSpecial(mesh:Mesh) : void {
			if(hasBitFlags(BenchConst.PROPERTY_SPRITESHEET)) {
				mesh.addController(new AnimationController(new <ITimeline>[
					new ScalarTimeline(
						'material.spritesheetFrameId',
						new <uint>[0, 1000],
						new <Number>[0, 74]
					)
				]));
			}
		}
		
		override protected function addPrimitive(type:int, translate:Boolean):void {
			var primitive 	: Mesh;
			var mat 		: Material = getMaterial();
			
			switch(type) {
				case BenchConst.TYPE_OBJ: 
					primitive = (getNextMesh() as Mesh).clone() as Mesh;
					primitive.material = mat;
					primitive.transform.appendUniformScale(0.001);
					break;
				case BenchConst.TYPE_CUBE: 
					if(mat && mat is PhongMaterial) (mat as PhongMaterial).castShadows = true;
					primitive = new Mesh(CubeGeometry.cubeGeometry, mat);
					primitive.transform.appendUniformScale(0.05);
					break;
				case BenchConst.TYPE_PLANE: 
					if(mat && mat is PhongMaterial)	(mat as PhongMaterial).receiveShadows = true;
					primitive = new Mesh(QuadGeometry.doubleSidedQuadGeometry, mat);
					primitive.transform.appendUniformScale(0.2);
					break;
				case BenchConst.TYPE_PARTICLE:
					primitive = new Mesh(new PointsGeometry(BenchConst.NUM_PARTICLES), mat);
					translate = false;
					break;
			}
			
			if(primitive == null) return;
			
			postSpecial(primitive);
			
			if(translate){
				primitive.transform
					.lock()
					.appendTranslation(
						-1 + Math.random() * 2,
						-1 + Math.random() * 2,
						-1 + Math.random() * 2
					)
					.unlock();
			}
			
			container.addChild(primitive);
			
			_objCount++;
		}
	}
}