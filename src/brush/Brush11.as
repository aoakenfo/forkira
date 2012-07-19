package brush
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;

	public class Brush11 extends Brush
	{
		public function Brush11()
		{
			super();
			
			brushNum = 11;
		}
		
		override public function mouseDown(mouseX:Number, mouseY:Number):void
		{
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			smoothedMouseX = mouseX;
			smoothedMouseY = mouseY;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{
			var skip:Boolean = lastMouseX == mouseX;
			
			if(lastMouseX == -1)
			{
				lastMouseX = mouseX;
				lastMouseY = mouseY;
				currentOffsetX = mouseX;
				currentOffsetY = mouseY;
				return null;
			}
			
			var dx2:Number = mouseX - lastMouseX;
			var dy2:Number = mouseY - lastMouseY;
			var dist2:Number = Math.sqrt(dx2*dx2 + dy2*dy2);
			
			var f:Number = 0.0;
			var fence:Number = 75;
			if (dist2 > fence)
				f = 1;
			else
				f = 1- (dist2 / fence);
			
			var firstPoint:Point = new Point(mouseX, mouseY);
			var secondPoint:Point = new Point(mouseX + offsetX, mouseY + offsetY);
			
			var interp:Point = Point.interpolate(firstPoint, secondPoint,f); // 1 <--> 0
			//var interp:Point = Point.interpolate(secondPoint, firstPoint,f); // 1 <--> 0
			
			currentOffsetX = mouseX - interp.x;
			currentOffsetY = mouseY - interp.y;
			
			var localX:int = mouseX + currentOffsetX;
			var localY:int = mouseY + currentOffsetY;
			
			smoothedMouseX = smoothedMouseX + smoothingFactor*(localX - smoothedMouseX);
			smoothedMouseY = smoothedMouseY + smoothingFactor*(localY - smoothedMouseY);
			
			mouseChangeVectorX = localX - lastMouseX;
			mouseChangeVectorY = localY - lastMouseY;
			
			var diff:int = mouseChangeVectorX * lastMouseChangeVectorX + mouseChangeVectorY * lastMouseChangeVectorY;
			if (diff < 0)
			{
				smoothedMouseX = lastSmoothedMouseX = lastMouseX;
				smoothedMouseY = lastSmoothedMouseY = lastMouseY;
				lastRotation += Math.PI;
				lastThickness = tipTaperFactor * lastThickness;
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
			
//			if(sampleColorList.length > 0)
//			{
//				if(currentIndex >= sampleColorList.length)
//					currentIndex = sampleColorList.length - 1; // should adjust currentIndex on delete event instead
//				
//				sampleColor = sampleColorList.getItemAt(currentIndex).fill.sampleColor;
//				++currentIndex;
//				if(currentIndex > sampleColorList.length - 1)
//					currentIndex = 0;
//			}
			
			//var stroke:Boolean = Math.random() > 0.7;
			//if(stroke)
			//	graphics.lineStyle(1,sampleColor, 0.75);
			if(!skip)
			{
			graphics.beginFill(sampleColor, 0.95);
			graphics.moveTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
			
			graphics.lineStyle(1,darkenColor(sampleColor, 0.6), 1);
			graphics.curveTo(controlX1,controlY1, smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
			
			graphics.lineStyle();
			graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
			
			graphics.lineStyle(1,darkenColor(sampleColor, 0.6), 1);
			graphics.curveTo(controlX2, controlY2, lastSmoothedMouseX - L0Cos0, lastSmoothedMouseY - L0Sin0);
			
			graphics.lineStyle();
			graphics.lineTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
			
			graphics.endFill();
			
			//round tip:
			//var taperThickness:Number = tipTaperFactor * lineThickness;
			//mouseEnabled = false;
			//graphics.clear();
			//graphics.beginFill(sampleColor, 0.55);
			//graphics.drawEllipse(localX - taperThickness, localY - taperThickness, 2*taperThickness, 2*taperThickness);
			//graphics.endFill();
			
			//quad segment
			//if(stroke)
			graphics.lineStyle(1,sampleColor, 0.75);
			
			graphics.beginFill(sampleColor, 0.55);
			graphics.moveTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
			graphics.lineTo(localX + tipTaperFactor*L1Cos1, localY + tipTaperFactor*L1Sin1);
			graphics.lineTo(localX - tipTaperFactor*L1Cos1, localY - tipTaperFactor*L1Sin1);
			graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
			graphics.lineTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);	
			graphics.endFill();
			}
			lastSmoothedMouseX = smoothedMouseX;
			lastSmoothedMouseY = smoothedMouseY;
			lastRotation = lineRotation;
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			
			lastThickness = lineThickness;
			
			return {t:11};
		}
	}
}