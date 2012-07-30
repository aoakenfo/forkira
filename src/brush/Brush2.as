package brush
{
	import flash.display.Graphics;
	
	import mx.collections.ArrayList;

	public class Brush2 extends Brush
	{
		public function Brush2()
		{
			super();
			
			brushNum = 2;
			lineStyleEnabled = true;
			lineThickness = 15;
			lineThicknessMultiplier = 10;
		}
		
		override public function mouseDown(mouseX:Number, mouseY:Number):void
		{
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			lastRotation = 0;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			if(op.lineStyleEnabled)
				graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.beginFill(op.sampleColor, op.alpha);
			
			graphics.moveTo(op.lastMouseX + op.L0Cos0, op.lastMouseY + op.L0Sin0);
			graphics.curveTo(op.controlX1, op.controlY1, op.mouseX + op.L1Cos1, op.mouseY + op.L1Sin1);
			graphics.lineTo(op.mouseX - op.L1Cos1, op.mouseY - op.L1Sin1);
			graphics.curveTo(op.controlX2, op.controlY2, op.lastMouseX - op.L0Cos0, op.lastMouseY - op.L0Sin0);
			graphics.lineTo(op.lastMouseX + op.L0Cos0, op.lastMouseY + op.L0Sin0);
			
			graphics.endFill();
		}
		
		override public function draw(graphics:Graphics, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Array
		{
			var objects:Array = new Array();
			
			updateSampleColor(mouseX, mouseY);	
			
			mouseChangeVectorX = mouseX - lastMouseX;
			mouseChangeVectorY = mouseY - lastMouseY;
			
			lineThickness =  (Math.random() * lineThicknessMultiplier);
			
			dx = mouseChangeVectorX;
			dy = mouseChangeVectorY;
			dist = Math.sqrt(dx*dx + dy*dy);
			
			if (dist != 0)
				lineRotation = Math.PI/2 + Math.atan2(dy,dx);
			else
				lineRotation = 0;
			
			sin0 = Math.sin(lastRotation);
			cos0 = Math.cos(lastRotation);
			sin1 = Math.sin(lineRotation);
			cos1 = Math.cos(lineRotation);
			
			L0Sin0 = lineThickness*sin0;
			L0Cos0 = lineThickness*cos0;
			L1Sin1 = lineThickness*sin1;
			L1Cos1 = lineThickness*cos1;
			
			if(lineStyleEnabled)
				graphics.lineStyle(lineWidth, sampleColor, alpha);
			
			graphics.beginFill(sampleColor, alpha);
			
			controlVecX = 0.33*dist*sin0;
			controlVecY = -0.33*dist*cos0;
			controlX1 = lastMouseX + L0Cos0 + controlVecX;
			controlY1 = lastMouseY + L0Sin0 + controlVecY;
			controlX2 = lastMouseX - L0Cos0 + controlVecX;
			controlY2 = lastMouseY - L0Sin0 + controlVecY;
			
			graphics.moveTo(lastMouseX + L0Cos0, lastMouseY + L0Sin0);
			graphics.curveTo(controlX1,controlY1, mouseX + L1Cos1, mouseY + L1Sin1);
			graphics.lineTo(mouseX - L1Cos1, mouseY - L1Sin1);
			graphics.curveTo(controlX2, controlY2, lastMouseX - L0Cos0, lastMouseY - L0Sin0);
			graphics.lineTo(lastMouseX + L0Cos0, lastMouseY + L0Sin0);
			
			graphics.endFill();
			
			objects.push({
				t:brushNum,
				lineStyleEnabled:lineStyleEnabled,
				lineWidth:lineWidth,
				sampleColor:sampleColor,
				alpha:alpha,
				mouseX:mouseX,
				mouseY:mouseY,
				lastMouseX:lastMouseX,
				lastMouseY:lastMouseY,
				L0Cos0:L0Cos0,
				L0Sin0:L0Sin0,
				L1Cos1:L1Cos1,
				L1Sin1:L1Sin1,
				controlX1:controlX1,
				controlY1:controlY1,
				controlX2:controlX2,
				controlY2:controlY2
			});
			
			lastRotation = lineRotation;
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			lastColour = sampleColor;
			
			return objects;
		}
		
		override public function help():Array
		{
			return new Array(
				"line-style-enabled <brush number, value>" +
				"\n    Example usage: line-style-enabled 2 0",
				
				"line-width <brush number, value>" +
				"\n    Example usage: line-width 2 10",
				
				"alpha <brush number, value>" +
				"\n    Example usage: alpha 2 0.5",
				
				"line-thickness-multiplier <brush number, value>" +
				"\n    Example usage: line-thickness-multiplier 2 20"
			);
		}
	}
}