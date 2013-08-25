package bench.away
{
	import away3d.animators.ParticleAnimationSet;
	import away3d.animators.ParticleAnimator;
	import away3d.animators.data.ParticleProperties;
	import away3d.animators.data.ParticlePropertiesMode;
	import away3d.animators.nodes.ParticleBillboardNode;
	import away3d.animators.nodes.ParticleSpriteSheetNode;
	import away3d.animators.nodes.ParticleVelocityNode;
	import away3d.core.base.Geometry;
	import away3d.entities.Mesh;
	import away3d.events.AssetEvent;
	import away3d.filters.BloomFilter3D;
	import away3d.library.AssetLibrary;
	import away3d.library.assets.AssetType;
	import away3d.loaders.parsers.DAEParser;
	import away3d.materials.ColorMaterial;
	import away3d.materials.SinglePassMaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.methods.SoftShadowMapMethod;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.tools.helpers.ParticleGeometryHelper;
	import away3d.utils.Cast;
	
	import bench.core.BenchConst;
	import bench.core.IBenchmarked;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class Away3DBenchmark extends Away3DExampleApplication implements IBenchmarked
	{
		private var _mat				: SinglePassMaterialBase;
		
		private var _particlesSet		: Vector.<Geometry>;
		private var _particleAnimSet	: ParticleAnimationSet;
		private var _particleAnimator	: ParticleAnimator;

		private var softShadows:SoftShadowMapMethod;
		
		public function setProperties(properties:int, numTextures:int=0):void {
			super.initProperties(properties, numTextures);
			
			if(hasBitFlags(BenchConst.PROPERTY_PARSE)) {
				super.initProperties(properties, BenchConst.NUM_AIRCRAFTS);
				AssetLibrary.enableParser(DAEParser);
				AssetLibrary.addEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
				for (var i:int = 1; i <= numTextures; i++) AssetLibrary.loadData(new (BenchConst['OBJ_PLANE_' + i] as Class)());
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_BLOOM)) {
				var bloom:BloomFilter3D = new BloomFilter3D( 16, 16, .75, 3, 3);
				viewport.filters3d = [bloom];
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_SPRITESHEET)) {
				_particleAnimSet = new ParticleAnimationSet(true, true, true);
				_particleAnimSet.addAnimation(new ParticleBillboardNode());
				_particleAnimSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_STATIC));
				_particleAnimSet.addAnimation(new ParticleSpriteSheetNode(ParticlePropertiesMode.GLOBAL, true, false, 9, 9, 1, 0, 74));
				_particleAnimSet.initParticleFunc = initParticleParam;
				_particleAnimator = new ParticleAnimator(_particleAnimSet);
			}
		}
		
		private function getTex (texName:String, unique:Boolean=false) : TextureMaterial {
			if(unique) return new TextureMaterial(Cast.bitmapTexture(BenchConst[texName]));
			return _matCash[texName] ||= getTex(texName, true);
		}
		
		private function getMaterial() : SinglePassMaterialBase {
			if(_mat != null && _textCount == 0) return _mat;
			
			_mat = new ColorMaterial(BenchConst.COLOR_MATERIAL);
			
			if(hasBitFlags(BenchConst.PROPERTY_ALPHA)) {
				var texA : Bitmap = new BenchConst.TEXTURE_ALPHA();
				_mat = new TextureMaterial(new BitmapTexture(texA.bitmapData));
				_mat.alphaThreshold = 1;
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_PARSE | BenchConst.PROPERTY_MULTIPLE_TEXTURES)) {
				_mat = getTex('TEXTURE_AIRPLANE_' + ((_objCount%BenchConst.NUM_AIRCRAFTS)+1));
			} else if(hasBitFlags(BenchConst.PROPERTY_PARSE | BenchConst.PROPERTY_UNIQUE_TEXTURES)) {
				_mat = getTex('TEXTURE_AIRPLANE_' + ((_objCount%BenchConst.NUM_AIRCRAFTS)+1), true);
			} else if(hasBitFlags(BenchConst.PROPERTY_MULTIPLE_TEXTURES)) {
				_mat = getTex('TEXTURE_'+((_objCount%BenchConst.NUM_TEXTURES) + 1));
			} else if(hasBitFlags(BenchConst.PROPERTY_UNIQUE_TEXTURES)) {
				_mat = getTex('TEXTURE_'+((_objCount%BenchConst.NUM_TEXTURES) + 1), true);
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_PARSE | BenchConst.PROPERTY_SPECULAR)) {
				_mat.specularMap = Cast.bitmapTexture(BenchConst.TEXTURE_AIRPLANE_SPEC);
			} else if(hasBitFlags(BenchConst.PROPERTY_SPECULAR)) {
				_mat.specularMap = new BitmapTexture(new BenchConst.TEXTURE_SPECULAR().bitmapData);
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_SPRITESHEET)) {
				_mat = getTex('TEXTURE_EXPLOSION');
				_mat.blendMode = BlendMode.ADD;
				_mat.repeat = true;
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_LIGHT))	{
				_mat.lightPicker = new StaticLightPicker([_light, _dirLight]);
				container.addChild(_light);
				container.addChild(_dirLight);
			} else if(container.contains(_light)) {
				container.removeChild(_dirLight);
				container.removeChild(_light);
			}
			
			if(hasBitFlags(BenchConst.PROPERTY_SHADOW)){
				softShadows ||= new SoftShadowMapMethod(_dirLight, 29);
				softShadows.range = 3;
				_mat.shadowMethod = softShadows;
			}
			
			_mat.ambient = .05;
			_mat.ambientColor = 0xffffffff;
			
			return _mat;
		}
		
		private function postSpecial(mesh:Mesh) : void {
			if(hasBitFlags(BenchConst.PROPERTY_SPRITESHEET)) {
				mesh.animator = _particleAnimator;
				_particleAnimator.start();
			}
		}
		
		private function initParticleParam(param:ParticleProperties):void {
			param.startTime = Math.random()*1;
			param.duration = 6;
			param.delay = 0;
			var degree1:Number = Math.random() * Math.PI * 2;
			var degree2:Number = Math.random() * Math.PI * 2;
			var r:Number = 500;
			param[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(r * Math.sin(degree1) * Math.cos(degree2), r * Math.cos(degree1) * Math.cos(degree2), r * Math.sin(degree2));
		}
		
		private function onAssetComplete(event:AssetEvent):void {
			var mesh : Mesh = null;
			if(event.asset.assetType == AssetType.GEOMETRY  && event.asset.name.indexOf("geom-Plane") != -1)	{
				mesh = new Mesh (event.asset as Geometry);
			} else if (event.asset.assetType == AssetType.MESH  && event.asset.name.indexOf("Plane") != -1)		{
				mesh = event.asset as Mesh;
			}
			
			if(mesh) _meshCash.push(mesh);
			if(_meshCash.length >= BenchConst.NUM_AIRCRAFTS) {
				AssetLibrary.removeEventListener(AssetEvent.ASSET_COMPLETE, onAssetComplete);
				startTests();
			}
		}
		
		override protected function addPrimitive(type:int, translate:Boolean):void {
			var primitive 	: Mesh;
			var mat 		: SinglePassMaterialBase = getMaterial();
			
			switch(type) {
				case BenchConst.TYPE_OBJ: 
					primitive = (getNextMesh() as Mesh).clone() as Mesh;
					primitive.material = mat;
					break;
				case BenchConst.TYPE_CUBE: 
					primitive = new Mesh(new CubeGeometry(100,100,100), mat);
					break;
				case BenchConst.TYPE_PLANE: 
					primitive = new Mesh(new PlaneGeometry(2000,2000,1,1,true,true), mat);
					break;
				case BenchConst.TYPE_PARTICLE: 
					_particlesSet ||= new Vector.<Geometry>;
					for (var i:int = 0; i < BenchConst.NUM_PARTICLES; i++) _particlesSet.push(new PlaneGeometry(200,200,1,1,false));
					primitive = new Mesh(ParticleGeometryHelper.generateGeometry(_particlesSet), mat);
					translate = false;
					break;
			}
			
			if(primitive == null) return;
			
			postSpecial(primitive);
			
			if(translate){
				var scale : int = 2000;
				primitive.x = -(1*scale) + Math.random() * (2*scale);
				primitive.y = -(1*scale) + Math.random() * (2*scale);
				primitive.z = -(1*scale) + Math.random() * (2*scale);
				primitive.rotationX = 90;
			}
			
			container.addChild(primitive);
			
			_objCount++;
		}
	}
}