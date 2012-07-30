package brush
{
	import flash.display.Graphics;
	
	import mx.collections.ArrayList;

	public class Brush8 extends Brush
	{
		public var roundedCorner:Number = 10;

		public function Brush8()
		{
			super();
			
			brushNum = 8;
			offsetX = 30;
			offsetY = 30;
			lineWidth = 4;
			lineStyleEnabled = true;
			randomizeOffset = false;
			plusMinusOffsetRange = 50;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			if(op.lineStyleEnabled)
				graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.beginFill(op.sampleColor, op.alpha);
			
			if(op.randomizeOffset)
			{
				op.offsetX = Math.random() * op.plusMinusOffsetRange;
				op.offsetY = Math.random() * op.plusMinusOffsetRange;
			}
			
			graphics.drawRoundRect(op.mouseX - (op.offsetX * 0.5),  op.mouseY - (op.offsetY * 0.5), op.offsetX, op.offsetY, op.roundedCorner, op.roundedCorner);
			
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
			
			if(lineStyleEnabled)
				graphics.lineStyle(lineWidth, sampleColor, alpha);
			
			graphics.beginFill(sampleColor, alpha);
			
			if(randomizeOffset)
			{
				offsetX = Math.random() * plusMinusOffsetRange;
				offsetY = Math.random() * plusMinusOffsetRange;
			}
			
			graphics.drawRoundRect(mouseX - (offsetX * 0.5),  mouseY - (offsetY * 0.5), offsetX, offsetY, roundedCorner, roundedCorner);
			
			graphics.endFill();
			
			objects.push({
				t:brushNum,
				lineStyleEnabled:lineStyleEnabled,
				lineWidth:lineWidth,
				sampleColor:sampleColor,
				alpha:alpha,
				randomizeOffset:randomizeOffset,
				plusMinusOffsetRange:plusMinusOffsetRange,
				offsetX:offsetX,
				offsetY:offsetY,
				mouseX:mouseX,
				mouseY:mouseY,
				roundedCorner:roundedCorner
			});
			
			return objects;
		}
		
		override public function help():Array
		{
			return new Array(
				"line-style-enabled <brush number, value>" +
				"\n    Example usage: line-style-enabled 8 1",
				
				"line-width <brush number, value>" +
				"\n    Example usage: line-width 8 10",
				
				"alpha <brush number, value>" +
				"\n    Example usage: alpha 8 0.5",
				
				"offset-x <brush number, value>" +
				"\n    Example usage: randomize-offset 8 10",
				
				"offset-y <brush number, value>" +
				"\n    Example usage: offset-y 8 20",
				
				"randomize-offset <brush number, value>" +
				"\n    Example usage: randomize-offset 8 1",
				
				"plus-minus-offset-range <brush number, value>" +
				"\n    Examlple usage: plus-minus-offset-range 8 40"
			);
		}
	}
}