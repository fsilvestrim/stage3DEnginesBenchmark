package bench.minko.utils
{
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.BillboardsGeometry;
	import aerys.minko.render.geometry.stream.IVertexStream;
	import aerys.minko.render.geometry.stream.IndexStream;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
	
	import flash.display.BitmapData;
	
	public class PointsGeometry extends Geometry
	{
		public function PointsGeometry(numPoints : uint = 10000)
		{
			var vertices 		: Vector.<Number> 	= new <Number>[];
			var indices 		: Vector.<uint> 	= new <uint>[];
			
			for (var x : uint = 0; x < numPoints; ++x)
			{
				var posX 	: Number 	= (Math.random() - 0.5) * 10;
				var posY 	: Number 	= (Math.random() - 0.5) * 10;
				var posZ 	: Number 	= (Math.random() - 0.5) * 10;
				var o		: uint		= x << 2;
				
				vertices.push(
					-.5, .5, posX, posY, posZ,
					-.5, -.5, posX, posY, posZ,
					.5, -.5, posX, posY, posZ,
					.5, .5, posX, posY, posZ
				);
				
				indices.push(o + 0, o + 1, o + 2, o + 0, o + 2, o + 3);
			}
			
			super(
				new <IVertexStream>[
					VertexStream.fromVector(StreamUsage.STATIC, PointsShader.VERTEX_FORMAT, vertices)
				],
				IndexStream.fromVector(StreamUsage.STATIC, indices)
			);
		}
	}
}