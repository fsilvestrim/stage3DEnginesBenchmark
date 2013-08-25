package bench.minko.utils
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.geometry.stream.format.VertexComponentType;
	import aerys.minko.render.geometry.stream.format.VertexFormat;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.DepthTest;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	import aerys.minko.type.enum.TriangleCulling;
	
	public class PointsShader extends Shader
	{
		public static const VERTEX_FORMAT	: VertexFormat	= new VertexFormat(
			VertexComponent.XY,
			VertexComponent.XYZ
		);
		
		private static const TIMESCALE	: Number	= 0.30;
		private static const COLS		: int		= 9;
		private static const ROWS		: int		= 9;
		
		override protected function initializeSettings(settings:ShaderSettings):void {
			super.initializeSettings(settings);
			
			settings.triangleCulling = TriangleCulling.NONE;
			settings.blending = Blending.ALPHA;
			settings.depthWriteEnabled = true;
			settings.priority = -10.;
			settings.depthSortDrawCalls = true;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			var time 		: SFloat 	= multiply(this.time, 0.001, TIMESCALE);
			var uv 			: SFloat 	= getVertexAttribute(VertexComponent.XY).xy;
			var shift		: SFloat	= cos(add(multiply(time, uv.y), uv.x));
			
			var position 	: SFloat 	= getVertexAttribute(VertexComponent.XYZ);
			var corner 		: SFloat 	= multiply(getVertexAttribute(VertexComponent.XY), float4(1, 1, 0, 0));
			
			position = add(position, float4(0, power(multiply(shift, 0.1), 1.5), 0, 0));
			
			position = localToView(position);
			position.incrementBy(corner);
			
			return multiply4x4(position, projectionMatrix);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var frame		: SFloat = floor(meshBindings.getParameter("spritesheetFrameId", 1));
			var uv			: SFloat = add(0.5, interpolate(getVertexAttribute(VertexComponent.XY).xy));
			var diffuseMap	: SFloat = meshBindings.getTextureParameter(
				"diffuseMap",
				meshBindings.getConstant("diffuseFiltering", SamplerFiltering.LINEAR),
				meshBindings.getConstant("diffuseMipMapping", SamplerMipMapping.LINEAR),
				meshBindings.getConstant("diffuseWrapping", SamplerWrapping.CLAMP)
			);
			
			var spriteSheetOffset	: SFloat = float2(
				modulo(frame, COLS),
				floor(divide(frame, ROWS))
			);
			
			var spriteSheetUv	: SFloat = divide(add(spriteSheetOffset, uv), COLS);
			
			var diffuse : SFloat = sampleTexture(diffuseMap, spriteSheetUv);
			
			kill(subtract(0.5, lessThan(diffuse.w, .1)));
			
			return  diffuse;
		}
	}
}