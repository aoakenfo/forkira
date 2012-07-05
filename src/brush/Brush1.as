package brush
{
	import flash.display.Graphics;
	
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
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			
			graphics.moveTo(mouseX, mouseY);
			
			for(var i:int = 0; i < iterations; ++i)
				graphics.lineTo(mouseX - centerOffset + Math.random() * radius, mouseY - centerOffset + Math.random() * radius);
			
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