package bench.core
{
	import aerys.minko.Minko;
	
	import away3d.Away3D;
	
	import bench.away.Away3DBenchmark;
	import bench.flare.FlareBenchmark;
	import bench.minko.MinkoBenchmark;
	import bench.utils.BenchInfos;
	
	import flare.Flare3D;
	
	import flash.utils.Dictionary;

	public class BenchConst {
	
		/*****************************************/
		/*********** Internal use only ***********/
		/*****************************************/
		static private var NEXT_TEST					: uint = 0;
		static private var NEXT_TYPE 					: uint = 0;
		
		/*****************************************/
		/*********** Initializations *************/
		/*****************************************/
		public static const BENCHMARK_ENGINE 			: Dictionary = new Dictionary();
		public static const BENCHMARK_TEST 				: Dictionary = new Dictionary();
		
		/*****************************************/
		/*************** Getters *****************/
		/*****************************************/
		public static function get CURRENT_NAME ()		: String { return BenchInfos.currentBench ? BenchInfos.currentBench.info.name : 'NONE'; }
		
		/*****************************************/
		/**************** Consts *****************/
		/*****************************************/
		static public const ANIMATE_CAMERA				: String = 'camera';
		static public const ANIMATE_GROUP				: String = 'group';
		static public const ANIMATE_UNITIES				: String = 'unities';
		static public const ANIMATE_OPTIONS				: Array  = [ANIMATE_CAMERA, ANIMATE_GROUP, ANIMATE_UNITIES];
		static public const ANIMATE_LIGHT				: String = 'light';
		
		
		static public const TYPE_CUBE					: int = NEXT_TYPE++;
		static public const TYPE_PLANE 					: int = NEXT_TYPE++;
		static public const TYPE_BILLBOARD 				: int = NEXT_TYPE++;
		static public const TYPE_PARTICLE				: int = NEXT_TYPE++;
		static public const TYPE_OBJ					: int = NEXT_TYPE++;
		
		static public const PROPERTY_LIGHT				: int = 4;
		static public const PROPERTY_SHADOW				: int = 16;
		static public const PROPERTY_SPECULAR			: int = 32;
		static public const PROPERTY_ALPHA				: int = 64;
		static public const PROPERTY_SPRITESHEET		: int = 128;
		static public const PROPERTY_UNIQUE_TEXTURES	: int = 256;
		static public const PROPERTY_BLOOM				: int = 512;
		static public const PROPERTY_PARSE				: int = 1024;
		static public const PROPERTY_MULTIPLE_TEXTURES	: int = 2048;
		
		public static const NUM_ITERATIONS 				: int	= 500;
		public static const NUM_AIRCRAFTS				: int	= 4;
		public static const NUM_TEXTURES				: int	= 50;
		public static const NUM_PARTICLES				: int	= 10000;
		
		public static const COLOR_MATERIAL				: uint	= 0x00ffff;
		public static const COLOR_BACKGROUND			: uint	= 0xAAAAAA;
		public static const COLOR_LIGHT					: uint	= 0x0000ff;
		public static const COLOR_AMBIENT_LIGHT			: uint 	= 0xffffff;
		
		/*****************************************/
		/********* Initial configuration *********/
		/*****************************************/
		static public var ANIMATE_CURRENT				: String = ANIMATE_GROUP;
		static public const FREE_CAMERA 				: Boolean = true;
		
		/*****************************************/
		/**************** Images *****************/
		/*****************************************/
		[Embed(source='/asset/meshes/Plane_1.DAE', mimeType='application/octet-stream')] public static var OBJ_PLANE_1	: Class;
		[Embed(source='/asset/meshes/Plane_2.DAE', mimeType='application/octet-stream')] public static var OBJ_PLANE_2	: Class;
		[Embed(source='/asset/meshes/Plane_3.DAE', mimeType='application/octet-stream')] public static var OBJ_PLANE_3	: Class;
		[Embed(source='/asset/meshes/Plane_4.DAE', mimeType='application/octet-stream')] public static var OBJ_PLANE_4	: Class;
		
		[Embed(source='/asset/meshes/Maps/Planes_spec.png')]		public static var TEXTURE_AIRPLANE_SPEC	: Class;
		[Embed(source='/asset/meshes/Maps/Plane_1.png')]			public static var TEXTURE_AIRPLANE_1	: Class;
		[Embed(source='/asset/meshes/Maps/Plane_2.png')]			public static var TEXTURE_AIRPLANE_2	: Class;
		[Embed(source='/asset/meshes/Maps/Plane_3.png')]			public static var TEXTURE_AIRPLANE_3	: Class;
		[Embed(source='/asset/meshes/Maps/Plane_4.png')]			public static var TEXTURE_AIRPLANE_4	: Class;
		
		[Embed(source='/asset/specular_alpha_map.png')]		public static var TEXTURE_SPECULAR	: Class;
		[Embed(source='/asset/transparent.png')]			public static var TEXTURE_ALPHA		: Class;
		[Embed(source='/asset/explosion.png')]				public static var TEXTURE_EXPLOSION	: Class;
		
		[Embed(source='/asset/textures/texture_1.png')] 	public static var TEXTURE_1		: Class;
		[Embed(source='/asset/textures/texture_2.png')] 	public static var TEXTURE_2		: Class;
		[Embed(source='/asset/textures/texture_3.png')] 	public static var TEXTURE_3		: Class;
		[Embed(source='/asset/textures/texture_4.png')] 	public static var TEXTURE_4		: Class;
		[Embed(source='/asset/textures/texture_5.png')] 	public static var TEXTURE_5		: Class;
		[Embed(source='/asset/textures/texture_6.png')] 	public static var TEXTURE_6		: Class;
		[Embed(source='/asset/textures/texture_7.png')] 	public static var TEXTURE_7		: Class;
		[Embed(source='/asset/textures/texture_8.png')] 	public static var TEXTURE_8		: Class;
		[Embed(source='/asset/textures/texture_9.png')] 	public static var TEXTURE_9		: Class;
		[Embed(source='/asset/textures/texture_10.png')] 	public static var TEXTURE_10	: Class;
		[Embed(source='/asset/textures/texture_11.png')] 	public static var TEXTURE_11	: Class;
		[Embed(source='/asset/textures/texture_12.png')] 	public static var TEXTURE_12	: Class;
		[Embed(source='/asset/textures/texture_13.png')] 	public static var TEXTURE_13	: Class;
		[Embed(source='/asset/textures/texture_14.png')] 	public static var TEXTURE_14	: Class;
		[Embed(source='/asset/textures/texture_15.png')] 	public static var TEXTURE_15	: Class;
		[Embed(source='/asset/textures/texture_16.png')] 	public static var TEXTURE_16	: Class;
		[Embed(source='/asset/textures/texture_17.png')] 	public static var TEXTURE_17	: Class;
		[Embed(source='/asset/textures/texture_18.png')] 	public static var TEXTURE_18	: Class;
		[Embed(source='/asset/textures/texture_19.png')] 	public static var TEXTURE_19	: Class;
		[Embed(source='/asset/textures/texture_20.png')] 	public static var TEXTURE_20	: Class;
		[Embed(source='/asset/textures/texture_21.png')] 	public static var TEXTURE_21	: Class;
		[Embed(source='/asset/textures/texture_22.png')] 	public static var TEXTURE_22	: Class;
		[Embed(source='/asset/textures/texture_23.png')] 	public static var TEXTURE_23	: Class;
		[Embed(source='/asset/textures/texture_24.png')] 	public static var TEXTURE_24	: Class;
		[Embed(source='/asset/textures/texture_25.png')] 	public static var TEXTURE_25	: Class;
		[Embed(source='/asset/textures/texture_26.png')] 	public static var TEXTURE_26	: Class;
		[Embed(source='/asset/textures/texture_27.png')] 	public static var TEXTURE_27	: Class;
		[Embed(source='/asset/textures/texture_28.png')] 	public static var TEXTURE_28	: Class;
		[Embed(source='/asset/textures/texture_29.png')] 	public static var TEXTURE_29	: Class;
		[Embed(source='/asset/textures/texture_30.png')] 	public static var TEXTURE_30	: Class;
		[Embed(source='/asset/textures/texture_31.png')] 	public static var TEXTURE_31	: Class;
		[Embed(source='/asset/textures/texture_32.png')] 	public static var TEXTURE_32	: Class;
		[Embed(source='/asset/textures/texture_33.png')] 	public static var TEXTURE_33	: Class;
		[Embed(source='/asset/textures/texture_34.png')] 	public static var TEXTURE_34	: Class;
		[Embed(source='/asset/textures/texture_35.png')] 	public static var TEXTURE_35	: Class;
		[Embed(source='/asset/textures/texture_36.png')] 	public static var TEXTURE_36	: Class;
		[Embed(source='/asset/textures/texture_37.png')] 	public static var TEXTURE_37	: Class;
		[Embed(source='/asset/textures/texture_38.png')] 	public static var TEXTURE_38	: Class;
		[Embed(source='/asset/textures/texture_39.png')] 	public static var TEXTURE_39	: Class;
		[Embed(source='/asset/textures/texture_40.png')] 	public static var TEXTURE_40	: Class;
		[Embed(source='/asset/textures/texture_41.png')] 	public static var TEXTURE_41	: Class;
		[Embed(source='/asset/textures/texture_42.png')] 	public static var TEXTURE_42	: Class;
		[Embed(source='/asset/textures/texture_43.png')] 	public static var TEXTURE_43	: Class;
		[Embed(source='/asset/textures/texture_44.png')] 	public static var TEXTURE_44	: Class;
		[Embed(source='/asset/textures/texture_45.png')] 	public static var TEXTURE_45	: Class;
		[Embed(source='/asset/textures/texture_46.png')] 	public static var TEXTURE_46	: Class;
		[Embed(source='/asset/textures/texture_47.png')] 	public static var TEXTURE_47	: Class;
		[Embed(source='/asset/textures/texture_48.png')] 	public static var TEXTURE_48	: Class;
		[Embed(source='/asset/textures/texture_49.png')] 	public static var TEXTURE_49	: Class;
		[Embed(source='/asset/textures/texture_50.png')] 	public static var TEXTURE_50	: Class;
		
		/*****************************************/
		/**************** Shaders ****************/
		/*****************************************/
		[Embed(source='/asset/shaders/bloom.flsl.compiled', mimeType='application/octet-stream')] public static var SHADER_FLARE_BLOOM	: Class;
		
		
		static public function initialize () : void {
			/*****************************************/
			/**************** Engines ****************/
			/*****************************************/
			BENCHMARK_ENGINE[112] = {
				key : 'F1',
				name: 'AWAY 3D v' +  Away3D.MAJOR_VERSION + '.' + Away3D.MINOR_VERSION + 'A',
					clazz: Away3DBenchmark
			};
			BENCHMARK_ENGINE[113] = {
				key : 'F2',
				name : 'MINKO v' + Minko.VERSION,
					clazz: MinkoBenchmark
			};
			BENCHMARK_ENGINE[114] = {
				key : 'F3',
				name: 'FLARE v' + Flare3D.version,
					clazz: FlareBenchmark
			};
			
			/*****************************************/
			/***************** Tests *****************/
			/*****************************************/
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : '1000 Cubes',
				test : function (b:IBenchmarked) : void {
					b.addTest(1000, BenchConst.TYPE_CUBE, true); 
					b.setAnimations(FREE_CAMERA, [ANIMATE_CURRENT]);
					b.setProperties(0);
				}
			};
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : '500 Cubes (w/ Light)',
				test : function (b:IBenchmarked) : void {
					b.addTest(500, BenchConst.TYPE_CUBE, true);
					b.setAnimations(FREE_CAMERA, [ANIMATE_CURRENT, ANIMATE_LIGHT]); 	
					b.setProperties(BenchConst.PROPERTY_LIGHT); 	
				}
			};
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : '500 Cubes (w/ Light & Shadow)',
				test : function (b:IBenchmarked) : void {
					b.addTest(5, BenchConst.TYPE_PLANE, true);
					b.addTest(500, BenchConst.TYPE_CUBE, true);
					b.setAnimations(FREE_CAMERA, [ANIMATE_CURRENT, ANIMATE_LIGHT]); 	
					b.setProperties(BenchConst.PROPERTY_LIGHT | BenchConst.PROPERTY_SHADOW); 	
				}
			};
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : '500 Cubes (w/ Light & Specularity)',
				test : function (b:IBenchmarked) : void {
					b.addTest(500, BenchConst.TYPE_CUBE, true);
					b.setAnimations(FREE_CAMERA, [ANIMATE_CURRENT, ANIMATE_LIGHT]); 	
					b.setProperties(BenchConst.PROPERTY_LIGHT | BenchConst.PROPERTY_SPECULAR); 	
				}
			};
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : '500 Cubes + Light + Alphamap',
				test : function (b:IBenchmarked) : void {
					b.addTest(500, BenchConst.TYPE_CUBE, true);
					b.setAnimations(FREE_CAMERA, [ANIMATE_CURRENT, ANIMATE_LIGHT]); 	
					b.setProperties(BenchConst.PROPERTY_LIGHT | BenchConst.PROPERTY_ALPHA); 	
				}
			};
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : '500 Cubes (w/ ' + BenchConst.NUM_TEXTURES + ' diff. Materials)',
				test : function (b:IBenchmarked) : void {
					b.addTest(500, BenchConst.TYPE_CUBE, true);
					b.setAnimations(FREE_CAMERA, [ANIMATE_CURRENT, ANIMATE_LIGHT]); 	
					b.setProperties(BenchConst.PROPERTY_LIGHT | BenchConst.PROPERTY_SPECULAR | BenchConst.PROPERTY_MULTIPLE_TEXTURES, 50); 	
				}
			};
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : '500 Cubes (w/ Bloom effect)',
				test : function (b:IBenchmarked) : void {
					b.addTest(500, BenchConst.TYPE_CUBE, true);
					b.setAnimations(FREE_CAMERA, [ANIMATE_CURRENT, ANIMATE_LIGHT]); 	
					b.setProperties(BenchConst.PROPERTY_LIGHT | BenchConst.PROPERTY_BLOOM); 	
				}
			};
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : '500 Planes (w/ Mat & Light & Specular)',
				test : function (b:IBenchmarked) : void {
					b.addTest(500, BenchConst.TYPE_OBJ, true);  
					b.setAnimations(FREE_CAMERA, [ANIMATE_CURRENT, ANIMATE_LIGHT]);
					b.setProperties(BenchConst.PROPERTY_LIGHT | BenchConst.PROPERTY_SPECULAR | BenchConst.PROPERTY_MULTIPLE_TEXTURES | BenchConst.PROPERTY_PARSE, 4);
				}
			};
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : '1500 Planes (w/ Light & Specular)',
				test : function (b:IBenchmarked) : void {
					b.addTest(1500, BenchConst.TYPE_OBJ, true);  
					b.setAnimations(FREE_CAMERA, [ANIMATE_CURRENT, ANIMATE_LIGHT]);
					b.setProperties(BenchConst.PROPERTY_LIGHT | BenchConst.PROPERTY_SPECULAR | BenchConst.PROPERTY_PARSE );
				}
			};
			BENCHMARK_TEST[NEXT_TEST++] = {
				name : NUM_PARTICLES + ' Particles (w/ Sprite sheet anim.)',
				test : function (b:IBenchmarked) : void {
					b.addTest(1, BenchConst.TYPE_PARTICLE, false);
					b.setAnimations(FREE_CAMERA); 	
					b.setProperties(BenchConst.PROPERTY_SPRITESHEET); 	
				}
			};
		}
	}
}