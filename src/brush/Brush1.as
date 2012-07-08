package brush
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;

	public class Brush1 extends Brush
	{		
		public function Brush1()
		{
			super();
			
			brushNum = 1;
			radius = 5;
			centerOffset = radius * 0.5;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			graphics.lineStyle(op.lw, op.sc, op.a);
			
			graphics.moveTo(op.mx, op.my);
			
			for(var i:int = 0; i < op.i; ++i)
				graphics.lineTo(op.mx - op.co + Math.random() * op.r, op.my - op.co + Math.random() * op.r);	
		}
		
		private var sourceLocal:Point = new Point();
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{
			for(var j:int = 0; j < 4; ++j)
			{
				offsetX = j * 5;//Math.random() * 10 + (Math.random() > 0.5 ? 1 : -1);
				offsetY = j * 5;//Math.random() * 10 + (Math.random() > 0.5 ? 1 : -1);
				
				mouseX += offsetX;
				mouseY += offsetY;
				
				sourceLocal = sourceBitmap.globalToLocal(new Point(mouseX + 40, mouseY + 70));
				
				// clamp
				if(sourceLocal.x < 0)
					sourceLocal.x = 0;
				else if(sourceLocal.x > sourceBitmap.source.bitmapData.width)
					sourceLocal.x = sourceBitmap.source.bitmapData.width - 1;
				if(sourceLocal.y < 0)
					sourceLocal.y = 0;
				else if(sourceLocal.y > sourceBitmap.source.bitmapData.height)
					sourceLocal.y = sourceBitmap.source.bitmapData.height - 1;
					
				sampleColor = sourceBitmap.source.bitmapData.getPixel(sourceLocal.x, sourceLocal.y);
					
				graphics.lineStyle(lineWidth, sampleColor, alpha);
			
				graphics.moveTo(mouseX, mouseY);
			
				for(var i:int = 0; i < iterations; ++i)
					graphics.lineTo(mouseX - centerOffset + Math.random() * radius, mouseY - centerOffset + Math.random() * radius);
			
			}
			return {
				t:1,
				lw:lineWidth,
				sc:sampleColor,
				a:alpha,
				mx:mouseX,
				my:mouseY,
				r:radius,
				co:centerOffset,
				i:iterations
			};
		}
	}
}