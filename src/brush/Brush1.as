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
			radius = 20;
			lineWidth = 10;
			centerOffset = radius * 0.5;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.moveTo(op.mouseX, op.mouseY);
			
			for(var i:int = 0; i < op.iterations; ++i)
				graphics.lineTo(op.mouseX - op.centerOffset + Math.random() * op.radius, op.mouseY - op.centerOffset + Math.random() * op.radius);	
		}
		
		override public function draw(graphics:Graphics, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Array
		{
			var objects:Array = new Array();
			
			if(colorList != null && colorList.length > 0)
			{
				if(currentColorListIndex >= colorList.length)
					currentColorListIndex = colorList.length - 1; // should adjust currentIndex on delete event instead
				
				sampleColor = colorList.getItemAt(currentColorListIndex).fill.color;
				++currentColorListIndex;
				if(currentColorListIndex > colorList.length - 1)
					currentColorListIndex = 0;
			}
			else
				updateSampleColor(mouseX, mouseY);
			
			offsetX = Math.random() * 10 + (Math.random() > 0.5 ? 1 : -1);
			offsetY = Math.random() * 10 + (Math.random() > 0.5 ? 1 : -1);
			
			mouseX += offsetX;
			mouseY += offsetY;
			
			graphics.lineStyle(lineWidth, sampleColor, alpha);
		
			graphics.moveTo(mouseX, mouseY);
		
			for(var i:int = 0; i < iterations; ++i)
				graphics.lineTo(mouseX - centerOffset + Math.random() * radius, mouseY - centerOffset + Math.random() * radius);
			
			objects.push({
				t:brushNum,
				lineWidth:lineWidth,
				sampleColor:sampleColor,
				alpha:alpha,
				mouseX:mouseX,
				mouseY:mouseY,
				iterations:iterations,
				centerOffset:centerOffset,
				radius:radius
			});
			
			return objects;
		}
	}
}