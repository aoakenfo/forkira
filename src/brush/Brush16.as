package brush
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;

	public class Brush16 extends Brush
	{
		private var bristles:Array = new Array();
		public function Brush16()
		{
			super();
			
			brushNum = 16;
			
			for(var i:int = 0; i < 10; ++i)
			{
				bristles.push({
					lastMouseX:-1,
					lastMouseY:-1,
					startX: 0,
					startY: 0,
					lastMouseChangeVectorX: 0,
					lastMouseChangeVectorY: 0,
					mouseChangeVectorX: 0,
					mouseChangeVectorY: 0,
					dx: 0,
					dy: 0,
					dist: 0,
					startX: 0,
					startY: 0,
					lineThickness: 15,
					lineRotation: 0,
					lastRotation: 0,
					L0Sin0: 0,
					L0Cos0: 0,
					L1Sin1: 0,
					L1Cos1: 0,
					sin0: 0,
					cos0: 0,
					sin1: 0,
					cos1: 0,
					controlVecX: 0,
					controlVecY: 0,
					controlX1: 0,
					controlY1: 0,
					controlX2: 0,
					controlY2: 0,
					lastColour: 0,
					
					smoothedMouseX: 0,
					smoothedMouseY: 0,
					lastSmoothedMouseX: 0,
					lastSmoothedMouseY: 0,
					smoothingFactor: 0.5,
					
					targetLineThickness: 0,
					minThickness: 0.2,
					thicknessFactor: 0.25,
					lastThickness: 0,
					thicknessSmoothingFactor: 0.3,
					
					tipTaperFactor: 0.8,
					offsetX: 0,
					offsetY: 0,
					currentOffsetX: 0,
					currentOffsetY: 0,
					
					accumulatedDist: 0,
					
					currentIndex: 0,
					offsetX:0,
					offsetY:0
				});
			}
		}
		
		// TODO: move into base class
//		private var lastMouseChangeVectorX:Number;
//		private var lastMouseChangeVectorY:Number;
//		private var mouseChangeVectorX:Number;
//		private var mouseChangeVectorY:Number;
//		private var dx:Number;
//		private var dy:Number;
//		private var dist:Number;
//		private var startX:Number;
//		private var startY:Number;
//		private var lineThickness:Number = 15;//5;//50;//5;//20;
//		private var lineRotation:Number;
//		private var lastRotation:Number;
//		private var L0Sin0:Number;
//		private var L0Cos0:Number;
//		private var L1Sin1:Number;
//		private var L1Cos1:Number;
//		private var sin0:Number;
//		private var cos0:Number;
//		private var sin1:Number;
//		private var cos1:Number;
//		private var controlVecX:Number;
//		private var controlVecY:Number;
//		private var controlX1:Number;
//		private var controlY1:Number;
//		private var controlX2:Number;
//		private var controlY2:Number;
//		private var lastColour:uint;
//		
//		private var smoothedMouseX:Number = 0;
//		private var smoothedMouseY:Number = 0;
//		private var lastSmoothedMouseX:Number = 0;
//		private var lastSmoothedMouseY:Number = 0;
//		private var smoothingFactor:Number = 0.3;  //Should be set to something between 0 and 1.  Higher numbers mean less smoothing.
//		
//		private var targetLineThickness:Number;
//		private var minThickness:Number = 0.2;
//		private var thicknessFactor:Number = 0.25;
//		private var lastThickness:Number = 0;
//		private var thicknessSmoothingFactor:Number = 0.3;
//		
//		private var tipTaperFactor:Number = 0.8;
//		private var offsetX:Number = 0;
//		private var offsetY:Number = 0;
//		private var currentOffsetX:Number = 0;
//		private var currentOffsetY:Number = 0;
//		
//		private var accumulatedDist:Number = 0;
//		
//		private var currentIndex:int = 0;
		
		private function darkenColor(c:uint, factor:Number):uint
		{
			var r:Number = (c >> 16);
			var g:Number = (c >> 8) & 0xFF;
			var b:Number = c & 0xFF;
			
			var newRed:Number = Math.min(255, r*factor);
			var newGreen:Number = Math.min(255, g*factor);
			var newBlue:Number = Math.min(255, b*factor);
			
			return (newRed << 16) | (newGreen << 8) | (newBlue);
		}
		
		private function map(value:Number,
							  low1:Number,
							  high1:Number,
							  low2:Number = 0,
							  high2:Number = 1):Number {
			//if the value and the 1st range low are equal to
			// the new value must be low2
			if (value == low1) {
				return low2;
			}
			
			//normalize both sets to a 0-? range
			var range1:Number = high1 - low1;
			var range2:Number = high2 - low2;
			
			//normalize the value to the new normalized range
			var result:Number = value - low1;
			
			//define the range as a percentage (0.0 to 1.0)
			var ratio:Number = result / range1;
			
			//find the value in the new normalized-range
			result = ratio * range2;
			
			//un-normalize the value in the new range
			result += low2;
			
			return result;
		}
		
		private var sourceLocal:Point = new Point();
		
		override public function mouseDown(mouseX:Number, mouseY:Number):void
		{
			for each(var b:Object in bristles)
			{
				b.offsetX = (Math.random() > 0.5 ? Math.random() * 10 : -Math.random() * 10),
				b.offsetY = (Math.random() > 0.5 ? Math.random() * 10 : -Math.random() * 10)
				b.currentOffsetX = b.offsetX;
				b.currentOffsetY = b.offsetY;
				
				b.accumulatedDist = 0;
			
				b.startX = b.lastMouseX = b.smoothedMouseX = b.lastSmoothedMouseX = mouseX;
				b.startY = b.lastMouseY = b.smoothedMouseY = b.lastSmoothedMouseY = mouseY;
				
				b.lastRotation = Math.PI/2;
				
				b.lastThickness = 0;
			}
		}
		
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
					
			for each(var b:Object in bristles)
			{
				//b.offsetX =  (Math.random() > 0.5 ? Math.random() * 45 : -Math.random() * 45),
				//b.offsetY = (Math.random() > 0.5 ? Math.random() * 45 : -Math.random() * 45)
						
				mouseX += b.offsetX;
				mouseY += b.offsetY;
				
				sourceLocal = sourceBitmap.globalToLocal(new Point(mouseX + 40, mouseY + 70));
				
				// clamp
				if(sourceLocal.x < 0)
					sourceLocal.x = 0;
				else if(sourceLocal.x > sourceBitmap.source.bitmapData.width)
					sourceLocal.x = sourceBitmap.source.bitmapData.width - 1;
				if(sourceLocal.y < 0)
					sourceLocal.y = 0;
				else if(sourceLocal.y > sourceBitmap.source.bitmapData.height)
					sourceLocal.y = sourceBitmap.source.bitmapData.height - 1;
				
				sampleColor = sourceBitmap.source.bitmapData.getPixel(sourceLocal.x, sourceLocal.y);
				
				
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
			var secondPoint:Point = new Point(mouseX + b.offsetX, mouseY + b.offsetY);
			
			var interp:Point = Point.interpolate(firstPoint, secondPoint,f); // 1 <--> 0
			//var interp:Point = Point.interpolate(secondPoint, firstPoint,f); // 1 <--> 0
			
			b.currentOffsetX = mouseX - interp.x;
			b.currentOffsetY = mouseY - interp.y;
			
			var localX:int = mouseX + b.currentOffsetX;
			var localY:int = mouseY + b.currentOffsetY;
			
			b.smoothedMouseX = b.smoothedMouseX + b.smoothingFactor*(localX - b.smoothedMouseX);
			b.smoothedMouseY = b.smoothedMouseY + b.smoothingFactor*(localY - b.smoothedMouseY);
			
			b.mouseChangeVectorX = localX - b.lastMouseX;
			b.mouseChangeVectorY = localY - b.lastMouseY;
			
			var diff:int = b.mouseChangeVectorX * b.lastMouseChangeVectorX + b.mouseChangeVectorY * b.lastMouseChangeVectorY;
			if (diff < 0)
			{
				b.smoothedMouseX = b.lastSmoothedMouseX = b.lastMouseX;
				b.smoothedMouseY = b.lastSmoothedMouseY = b.lastMouseY;
				b.lastRotation += Math.PI;
				b.lastThickness = b.tipTaperFactor * b.lastThickness;
			}
			
			b.dx = b.smoothedMouseX - b.lastSmoothedMouseX;
			b.dy = b.smoothedMouseY - b.lastSmoothedMouseY;
			b.dist = Math.sqrt(b.dx*b.dx + b.dy*b.dy);
			
			if (b.dist != 0)
				b.lineRotation = Math.PI/2 + Math.atan2(b.dy,b.dx);
			else
				b.lineRotation = 0;
			
			
			b.targetLineThickness = b.minThickness + b.thicknessFactor * b.dist;
			b.lineThickness = b.lastThickness + b.thicknessSmoothingFactor * (b.targetLineThickness - b.lastThickness);
			//b.thicknessFactor = 0.25;
			//b.lineThickness = b.dist * b.thicknessFactor;
			
			b.sin0 = Math.sin(b.lastRotation);
			b.cos0 = Math.cos(b.lastRotation);
			b.sin1 = Math.sin(b.lineRotation);
			b.cos1 = Math.cos(b.lineRotation);
			
			b.L0Sin0 = b.lastThickness*b.sin0;
			b.L0Cos0 = b.lastThickness*b.cos0;
			b.L1Sin1 = b.lineThickness*b.sin1;
			b.L1Cos1 = b.lineThickness*b.cos1;
			
			b.controlVecX = 0.33*b.dist*b.sin0;
			b.controlVecY = -0.33*b.dist*b.cos0;
			b.controlX1 = b.lastSmoothedMouseX + b.L0Cos0 + b.controlVecX;
			b.controlY1 = b.lastSmoothedMouseY + b.L0Sin0 + b.controlVecY;
			b.controlX2 = b.lastSmoothedMouseX - b.L0Cos0 + b.controlVecX;
			b.controlY2 = b.lastSmoothedMouseY - b.L0Sin0 + b.controlVecY;
			
			if(colorList != null && colorList.length > 0)
			{
				if(b.currentIndex >= colorList.length)
					b.currentIndex = colorList.length - 1; // should adjust currentIndex on delete event instead
				
				sampleColor = colorList.getItemAt(b.currentIndex).fill.color;
				++b.currentIndex;
				if(b.currentIndex > colorList.length - 1)
					b.currentIndex = 0;
			}
			
			var cx0:int = b.lastSmoothedMouseX + b.L0Cos0;
			var cy0:int = b.lastSmoothedMouseY + b.L0Sin0;
			var cx1:int = b.smoothedMouseX + b.L1Cos1;
			var cy1:int = b.smoothedMouseY + b.L1Sin1;
			var cx2:int = b.smoothedMouseX - b.L1Cos1;
			var cy2:int = b.smoothedMouseY - b.L1Sin1;
			var cx3:int = b.lastSmoothedMouseX - b.L0Cos0;
			var cy3:int = b.lastSmoothedMouseY - b.L0Sin0;
			
			var angle:Number = b.lineRotation + toRad(90);
			
			var mat:Matrix = new Matrix(); 
			mat.createGradientBox(b.dist,// w
				b.lineThickness,	// h
				angle,	// rotation
				0, 	// tx
				0); // ty
			
			if(b.lineRotation > 0)
				mat.translate(b.lastSmoothedMouseX, b.lastSmoothedMouseY);
			else
				mat.translate(b.smoothedMouseX, b.smoothedMouseY);
			
			b.accumulatedDist += b.dist;
			//var opacity:Number = 1 - map(accumulatedDist, 0, 1000, 0, 1);
			//accumulatedDist = 0;
			
			graphics.lineStyle();
			
			graphics.beginGradientFill(GradientType.LINEAR, // type
				[sampleColor, b.lastColour], // colors
				[alpha, alpha], // alphas
				[0, 255], // ratios
				mat);
			
			b.lastColour = sampleColor;
			
			
			graphics.lineStyle(1,darkenColor(sampleColor, 0.6), alpha);
			graphics.moveTo(cx0, cy0);
			graphics.curveTo(b.controlX1,b.controlY1, cx1, cy1);
			
			graphics.lineStyle();
			graphics.lineTo(cx2, cy2);
			
			graphics.lineStyle(1,darkenColor(sampleColor, 0.6), alpha);
			graphics.curveTo(b.controlX2, b.controlY2, cx3, cy3);
			
			graphics.lineStyle();
			graphics.lineTo(cx0, cy0);
			
			graphics.endFill();
			
			//round tip:
			//var taperThickness:Number = tipTaperFactor * lineThickness;
			//tipLayer = new Sprite();
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
			
			b.lastSmoothedMouseX = b.smoothedMouseX;
			b.lastSmoothedMouseY = b.smoothedMouseY;
			b.lastRotation = b.lineRotation;
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			
			b.lastThickness = b.lineThickness;
			
			} // TODO: return array of objects for bristles
			
			return {t:16};
		}
	}
}