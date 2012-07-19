package brush
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;

	public class Brush14 extends Brush
	{
		public function Brush14()
		{
			super();
			
			brushNum = 14;
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
			
//			if(colorList.length > 0)
//			{
//				if(currentIndex >= colorList.length)
//					currentIndex = colorList.length - 1; // should adjust currentIndex on delete event instead
//				
//				color = colorList.getItemAt(currentIndex).fill.color;
//				++currentIndex;
//				if(currentIndex > colorList.length - 1)
//					currentIndex = 0;
//			}
			
			//var stroke:Boolean = Math.random() > 0.7;
			//if(stroke)
			//	graphics.lineStyle(1,color, 0.75);
			
			var cx0:int = lastSmoothedMouseX + L0Cos0;
			var cy0:int = lastSmoothedMouseY + L0Sin0;
			var cx1:int = smoothedMouseX + L1Cos1;
			var cy1:int = smoothedMouseY + L1Sin1;
			var cx2:int = smoothedMouseX - L1Cos1;
			var cy2:int = smoothedMouseY - L1Sin1;
			var cx3:int = lastSmoothedMouseX - L0Cos0;
			var cy3:int = lastSmoothedMouseY - L0Sin0;
			
			var angle:Number = lineRotation + toRad(90);
			
			var mat:Matrix = new Matrix(); 
			mat.createGradientBox(dist,// w
				lineThickness,	// h
				angle,	// rotation
				0, 	// tx
				0); // ty
			
			if(lineRotation > 0)
				mat.translate(lastSmoothedMouseX, lastSmoothedMouseY);
			else
				mat.translate(smoothedMouseX, smoothedMouseY);
			
			graphics.beginGradientFill(GradientType.LINEAR, // type
				[sampleColor, lastColour], // colors
				[alpha, alpha], // alphas
				[0, 255], // ratios
				mat);
			
			lastColour = sampleColor;
			//if(!skip)
			{
			graphics.lineStyle(1, 0x000000, 1, true);
			
			graphics.moveTo(cx0, cy0);
			graphics.curveTo(controlX1,controlY1, cx1, cy1);
			
			graphics.lineStyle();
			graphics.lineTo(cx2, cy2);
			
			if(Math.random() > 0.3)
			graphics.lineStyle(1, 0x000000, 1, true);
			graphics.curveTo(controlX2, controlY2, cx3, cy3);
			
			graphics.lineStyle();
			graphics.lineTo(cx0, cy0);
			
			graphics.endFill();
			}
			lastSmoothedMouseX = smoothedMouseX;
			lastSmoothedMouseY = smoothedMouseY;
			lastRotation = lineRotation;
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			
			lastThickness = lineThickness;
			
			return {t:14};
		}
	}
}