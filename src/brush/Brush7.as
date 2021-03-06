package brush
{
	import flash.display.Graphics;
	
	import mx.collections.ArrayList;

	public class Brush7 extends Brush
	{
		public function Brush7()
		{
			super();
			
			brushNum = 7;
			radius = 30;
		}

		override public function drawOp(graphics:Graphics, op:Object):void
		{
			graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			for(var i:int = 1; i <= op.radius; i += op.lineWidth + 1)
				graphics.drawCircle(op.mouseX, op.mouseY, i);
			
			graphics.endFill();
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
			
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			
			for(var i:int = 1; i <= radius; i += lineWidth + 1)
				graphics.drawCircle(mouseX, mouseY, i);
			
			objects.push({
				t:brushNum,
				lineWidth:lineWidth,
				sampleColor:sampleColor,
				alpha:alpha,
				radius:radius,
				mouseX:mouseX,
				mouseY:mouseY
			});
			
			return objects;
		}
		
		override public function help():Array
		{
			return new Array(
				"line-width <brush number, value>" +
				"\n    Example usage: line-width 7 10",
				
				"alpha <brush number, value>" +
				"\n    Example usage: alpha 7 0.5",
				
				"radius <brush number, value>" +
				"\n    Example usage: radius 7 10"
			);
		}
	}
}