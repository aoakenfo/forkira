package brush
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;

	public class Brush25 extends Brush
	{
		public function Brush25()
		{
			super();
			
			brushNum = 25;
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
		private var lineThickness:Number = 30;//5;//50;//5;//20;
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
		private var minThickness:Number = 0.4;
		private var thicknessFactor:Number = 0.25;
		private var lastThickness:Number = 0;
		private var thicknessSmoothingFactor:Number = 0.6;
		
		private var tipTaperFactor:Number = 0.8;
		private var currentOffsetX:Number = 0;
		private var currentOffsetY:Number = 0;
		
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
			
			for(var i:int = 0; i < 10; ++i)
			{
				//mouseX += Math.random() * 2 * (Math.random() > 0.5 ? -1 : 1);
				//mouseY += Math.random() * 2 * (Math.random() > 0.5 ? -1 : 1);
				
				var dx2:Number = mouseX - lastMouseX;
				var dy2:Number = mouseY - lastMouseY;
				var dist2:Number = Math.sqrt(dx2*dx2 + dy2*dy2);
				
					//currentOffsetX = mouseX - Math.random();
					//currentOffsetY = mouseY - Math.random();
				
				var localX:int = mouseX + currentOffsetX;
				var localY:int = mouseY + currentOffsetY;
				
				//if(Math.random() > 0.5)
				{
					smoothedMouseX = smoothedMouseX + smoothingFactor*(localX - smoothedMouseX);
					smoothedMouseY = smoothedMouseY + smoothingFactor*(localY - smoothedMouseY);
				}
				
				//if(Math.random() > 0.5)
				{
					mouseChangeVectorX = localX - lastMouseX;
					mouseChangeVectorY = localY - lastMouseY;
				}
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
				lineThickness = lastThickness + thicknessSmoothingFactor * (targetLineThickness - lastThickness) + (Math.random() * 5);
				//if(Math.random() > 0.5)
				{
					sin0 = Math.sin(lastRotation);
					cos0 = Math.cos(lastRotation);
					sin1 = Math.sin(lineRotation);
					cos1 = Math.cos(lineRotation);
					
					L0Sin0 = lastThickness*sin0;
					L0Cos0 = lastThickness*cos0;
					L1Sin1 = lineThickness*sin1;
					L1Cos1 = lineThickness*cos1;
					
					controlVecX = 0.66*dist*sin0;
					controlVecY = -0.66*dist*cos0;
					controlX1 = lastSmoothedMouseX + L0Cos0 + controlVecX;
					controlY1 = lastSmoothedMouseY + L0Sin0 + controlVecY;
					controlX2 = lastSmoothedMouseX - L0Cos0 + controlVecX;
					controlY2 = lastSmoothedMouseY - L0Sin0 + controlVecY;
				}
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
					graphics.beginFill(sampleColor, alpha);
					graphics.moveTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
					
					graphics.lineStyle(1,darkenColor(sampleColor, alpha), 1);
					graphics.curveTo(controlX1,controlY1, smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
					
					graphics.lineStyle();
					graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
					
					graphics.lineStyle(1,darkenColor(sampleColor, alpha), 1);
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
			}
			
			return {t:25};
		}
	}
}