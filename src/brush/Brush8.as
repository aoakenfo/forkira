package brush
{
	import flash.display.Graphics;
	
	import mx.collections.ArrayList;

	public class Brush8 extends Brush
	{
		public function Brush8()
		{
			super();
			
			brushNum = 8;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{
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
			
			L0Sin0 = lineThickness*sin0;
			L0Cos0 = lineThickness*cos0;
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
			
			lastSmoothedMouseX = smoothedMouseX;
			lastSmoothedMouseY = smoothedMouseY;
			lastRotation = lineRotation;
			
			return {t:8};
		}
	}
}