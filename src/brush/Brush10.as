package brush
{
	import flash.display.Graphics;
	
	import mx.collections.ArrayList;
	
	public class Brush10 extends Brush
	{
		public function Brush10()
		{
			super();
			
			brushNum = 10;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{
			smoothedMouseX = smoothedMouseX + smoothingFactor*(mouseX - smoothedMouseX);
			smoothedMouseY = smoothedMouseY + smoothingFactor*(mouseY - smoothedMouseY);
			
			mouseChangeVectorX = mouseX - lastMouseX;
			mouseChangeVectorY = mouseY - lastMouseY;
			
			var diff:int = mouseChangeVectorX * lastMouseChangeVectorX + mouseChangeVectorY * lastMouseChangeVectorY;
			if (diff < 0)
			{
				smoothedMouseX = lastSmoothedMouseX = lastMouseX;
				smoothedMouseY = lastSmoothedMouseY = lastMouseY;
				lastRotation += Math.PI;
				lastThickness = tipTaperFactor*lastThickness;
			}
			
			dx = smoothedMouseX - lastSmoothedMouseX;
			dy = smoothedMouseY - lastSmoothedMouseY;
			dist = Math.sqrt(dx*dx + dy*dy);
			
			if (dist != 0)
				lineRotation = Math.PI/2 + Math.atan2(dy,dx);
			else
				lineRotation = 0;
			
			//We use a similar smoothing technique to change the thickness of the line, so that it doesn't
			//change too abruptly.
			targetLineThickness = minThickness + thicknessFactor * dist;
			lineThickness = lastThickness + thicknessSmoothingFactor * (targetLineThickness - lastThickness);
			
			sin0 = Math.sin(lastRotation);
			cos0 = Math.cos(lastRotation);
			sin1 = Math.sin(lineRotation);
			cos1 = Math.cos(lineRotation);
			
			L0Sin0 = lastThickness*sin0;
			L0Cos0 = lastThickness*cos0;
			L1Sin1 = lineThickness*sin1;
			L1Cos1 = lineThickness*cos1;
			
			controlVecX = 0.33*dist*sin0;
			controlVecY = -0.33*dist*cos0;
			controlX1 = lastSmoothedMouseX + L0Cos0 + controlVecX;
			controlY1 = lastSmoothedMouseY + L0Sin0 + controlVecY;
			controlX2 = lastSmoothedMouseX - L0Cos0 + controlVecX;
			controlY2 = lastSmoothedMouseY - L0Sin0 + controlVecY;
			
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			graphics.beginFill(sampleColor, alpha);
			
			graphics.moveTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
			graphics.curveTo(controlX1,controlY1,smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
			graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
			graphics.curveTo(controlX2, controlY2, lastSmoothedMouseX - L0Cos0, lastSmoothedMouseY - L0Sin0);
			graphics.lineTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
			
			graphics.endFill();
			
			//We draw the tip, which completes the line from the smoothed mouse position to the actual mouse position.
			//We won't actually add this to the drawn bitmap until a mouse up completes the drawing of the current line.
			
			//round tip:
			var taperThickness:Number = tipTaperFactor * lineThickness;
			//mc.graphics.clear();
			graphics.beginFill(sampleColor, alpha);
			graphics.drawEllipse(mouseX - taperThickness, mouseY - taperThickness, 2*taperThickness, 2*taperThickness);
			graphics.endFill();
			//quad segment
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			graphics.beginFill(sampleColor, alpha);
			graphics.moveTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
			graphics.lineTo(mouseX + tipTaperFactor*L1Cos1, mouseY + tipTaperFactor*L1Sin1);
			graphics.lineTo(mouseX - tipTaperFactor*L1Cos1, mouseY - tipTaperFactor*L1Sin1);
			graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
			graphics.lineTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);	
			graphics.endFill();
			
			lastSmoothedMouseX = smoothedMouseX;
			lastSmoothedMouseY = smoothedMouseY;
			lastRotation = lineRotation;
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			
			lastThickness = lineThickness;
			
			return {t:10};
		}
	}
}