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
			lineStyleEnabled = true;
		}
		
		override public function mouseDown(mouseX:Number, mouseY:Number):void
		{
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			lastRotation = 0;
			lineRotation = 0;
			smoothedMouseX = mouseX;
			smoothedMouseY = mouseY;
			lastSmoothedMouseX = mouseX;
			lastSmoothedMouseY = mouseY;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			if(op.lineStyleEnabled)
				graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.beginFill(op.sampleColor, op.alpha);
			
			graphics.moveTo(op.lastSmoothedMouseX + op.L0Cos0, op.lastSmoothedMouseY + op.L0Sin0);
			graphics.curveTo(op.controlX1, op.controlY1, op.smoothedMouseX + op.L1Cos1, op.smoothedMouseY + op.L1Sin1);
			graphics.lineTo(op.smoothedMouseX - op.L1Cos1, op.smoothedMouseY - op.L1Sin1);
			graphics.curveTo(op.controlX2, op.controlY2, op.lastSmoothedMouseX - op.L0Cos0, op.lastSmoothedMouseY - op.L0Sin0);
			graphics.lineTo(op.lastSmoothedMouseX + op.L0Cos0, op.lastSmoothedMouseY + op.L0Sin0);
			
			graphics.endFill();
		}
		
		override public function draw2(graphics:Graphics, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Array
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
			
			smoothedMouseX = smoothedMouseX + smoothingFactor*(mouseX - smoothedMouseX);
			smoothedMouseY = smoothedMouseY + smoothingFactor*(mouseY - smoothedMouseY);
			
			dx = smoothedMouseX - lastSmoothedMouseX;
			dy = smoothedMouseY - lastSmoothedMouseY;
			dist = Math.sqrt(dx*dx + dy*dy);
			
			if (dist != 0)
				lineRotation = Math.PI/2 + Math.atan2(dy,dx);
			else
				lineRotation = 0;
			
			sin0 = Math.sin(lastRotation);
			cos0 = Math.cos(lastRotation);
			sin1 = Math.sin(lineRotation);
			cos1 = Math.cos(lineRotation);
			
			L1Sin1 = lineThickness*sin1;
			L1Cos1 = lineThickness*cos1;
			L0Sin0 = L1Sin1;
			L0Cos0 = L1Cos1;
			
			controlVecX = 0.33*dist*sin0;
			controlVecY = -0.33*dist*cos0;
			controlX1 = lastSmoothedMouseX + L0Cos0 + controlVecX;
			controlY1 = lastSmoothedMouseY + L0Sin0 + controlVecY;
			controlX2 = lastSmoothedMouseX - L0Cos0 + controlVecX;
			controlY2 = lastSmoothedMouseY - L0Sin0 + controlVecY;
			
			if(lineStyleEnabled)
				graphics.lineStyle(lineWidth, sampleColor, alpha);
			
			graphics.beginFill(sampleColor, alpha);
			
			graphics.moveTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
			graphics.curveTo(controlX1, controlY1, smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
			graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
			graphics.curveTo(controlX2, controlY2, lastSmoothedMouseX - L0Cos0, lastSmoothedMouseY - L0Sin0);
			graphics.lineTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
			
			graphics.endFill();
			
			objects.push({
				t:7,
				lineWidth:lineWidth,
				sampleColor:sampleColor,
				alpha:alpha,
				lineStyleEnabled:lineStyleEnabled,
				L0Cos0:L0Cos0,
				L0Sin0:L0Sin0,
				L1Cos1:L1Cos1,
				L1Sin1:L1Sin1,
				controlX1:controlX1,
				controlY1:controlY1,
				controlX2:controlX2,
				controlY2:controlY2,
				smoothedMouseX:smoothedMouseX,
				smoothedMouseY:smoothedMouseY,
				lastSmoothedMouseX:lastSmoothedMouseX,
				lastSmoothedMouseY:lastSmoothedMouseY
			});
			
			lastSmoothedMouseX = smoothedMouseX;
			lastSmoothedMouseY = smoothedMouseY;
			lastRotation = lineRotation;
			
			return objects;
		}
	}
}