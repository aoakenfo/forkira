package brush
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;

	public class Brush13 extends Brush
	{
		public function Brush13()
		{
			super();
			
			brushNum = 13;
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
		
		private var tipTaperFactor:Number = 0.8;
		private var offsetX:Number = 0;
		private var offsetY:Number = 0;
		private var currentOffsetX:Number = 0;
		private var currentOffsetY:Number = 0;
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{
//			if(lastMouseX == -1)
//			{
//				lastMouseX = mouseX;
//				lastMouseY = mouseY;
//				currentOffsetX = mouseX;
//				currentOffsetY = mouseY;
//				return;
//			}
			
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
			
			L0Sin0 = 40*sin0;//lastThickness*sin0;
			L0Cos0 = 40*cos0;//lastThickness*cos0;
			L1Sin1 = 40*sin1;//lineThickness*sin1;
			L1Cos1 = 40*cos1;//lineThickness*cos1;
			
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
				40,	// h
				angle,	// rotation
				0, 	// tx
				0); // ty
			
			if(lineRotation > 0)
				mat.translate(lastSmoothedMouseX, lastSmoothedMouseY);
			else
				mat.translate(smoothedMouseX, smoothedMouseY);
			
			graphics.beginGradientFill(GradientType.LINEAR, // type
				[sampleColor, lastColour], // colors
				[0.5, 0.5], // alphas
				[0, 255], // ratios
				mat);
			
			lastColour = sampleColor;
			
			graphics.moveTo(cx0, cy0);
			
			graphics.lineStyle(1,darkenColor(sampleColor, alpha), alpha);
			graphics.curveTo(controlX1,controlY1, cx1, cy1);
			
			graphics.lineStyle();
			graphics.lineTo(cx2, cy2);
			
			graphics.lineStyle(1,darkenColor(sampleColor, alpha), alpha);
			graphics.curveTo(controlX2, controlY2, cx3, cy3);
			
			graphics.lineStyle();
			graphics.lineTo(cx0, cy0);
			
			graphics.endFill();
			
			//round tip:
			//var taperThickness:Number = tipTaperFactor * lineThickness;
			//tipLayer.mouseEnabled = false;
			//tipLayer.graphics.clear();
			//tipLayer.graphics.beginFill(color, 0.55);
			//tipLayer.graphics.drawEllipse(localX - taperThickness, localY - taperThickness, 2*taperThickness, 2*taperThickness);
			//tipLayer.graphics.endFill();
			
			//quad segment
			//if(stroke)
			//tipLayer.graphics.lineStyle(1,color, 0.75);
			
			//tipLayer.graphics.beginFill(color, 0.55);
			//tipLayer.graphics.moveTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
			//tipLayer.graphics.lineTo(localX + tipTaperFactor*L1Cos1, localY + tipTaperFactor*L1Sin1);
			//tipLayer.graphics.lineTo(localX - tipTaperFactor*L1Cos1, localY - tipTaperFactor*L1Sin1);
			//tipLayer.graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
			//tipLayer.graphics.lineTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);	
			//tipLayer.graphics.endFill();
			
			lastSmoothedMouseX = smoothedMouseX;
			lastSmoothedMouseY = smoothedMouseY;
			lastRotation = lineRotation;
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			
			lastThickness = lineThickness;
			
			return {t:13};
		}
	}
}