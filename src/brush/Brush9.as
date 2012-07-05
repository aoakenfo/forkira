
package brush
{
	import flash.display.Graphics;
	
	import mx.collections.ArrayList;
	
	public class Brush9 extends Brush
	{
		public function Brush9()
		{
			super();
			
			brushNum = 9;
		}
		
		// TODO: move into base class
		private var lastMouseChangeVectorX:Number;
		private var lastMouseChangeVectorY:Number;
		private var mouseChangeVectorX:Number;
		private var mouseChangeVectorY:Number;
		private var dx:Number;
		private var dy:Number;
		private var dist:Number;
		private var startX:Number;
		private var startY:Number;
		private var lineThickness:Number = 15;//5;//50;//5;//20;
		private var lineRotation:Number;
		private var lastRotation:Number;
		private var L0Sin0:Number;
		private var L0Cos0:Number;
		private var L1Sin1:Number;
		private var L1Cos1:Number;
		private var sin0:Number;
		private var cos0:Number;
		private var sin1:Number;
		private var cos1:Number;
		private var controlVecX:Number;
		private var controlVecY:Number;
		private var controlX1:Number;
		private var controlY1:Number;
		private var controlX2:Number;
		private var controlY2:Number;
		private var lastColour:uint;
		
		private var smoothedMouseX:Number = 0;
		private var smoothedMouseY:Number = 0;
		private var lastSmoothedMouseX:Number = 0;
		private var lastSmoothedMouseY:Number = 0;
		private var smoothingFactor:Number = 0.3;  //Should be set to something between 0 and 1.  Higher numbers mean less smoothing.
		
		private var targetLineThickness:Number;
		private var minThickness:Number = 0.2;
		private var thicknessFactor:Number = 0.25;
		private var lastThickness:Number = 0;
		private var thicknessSmoothingFactor:Number = 0.3;
		
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
			
			lastSmoothedMouseX = smoothedMouseX;
			lastSmoothedMouseY = smoothedMouseY;
			lastRotation = lineRotation;
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			
			lastThickness = lineThickness;
			
			return {t:9};
		}
	}
}