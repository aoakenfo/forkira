package brush
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;

	public class Brush6 extends Brush
	{
		public function Brush6()
		{
			super();
			
			brushNum = 6;
			lineThicknessMultiplier = .25;
			alpha = .5;
			plusMinusOffsetRange = 20;
			
			totalBristles(5);
		}
		
		override public function totalBristles(numBristles:Number):void
		{
			offsetBristles = numBristles > 1;
			bristles = new Array();
			
			for(var i:int = 0; i < numBristles; ++i)
			{
				bristles.push({
					lastMouseX:-1,
					lastMouseY:-1,
					lastMouseChangeVectorX: 0,
					lastMouseChangeVectorY: 0,
					mouseChangeVectorX: 0,
					mouseChangeVectorY: 0,
					dx: 0,
					dy: 0,
					dist: 0,
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
		
		override public function mouseDown(mouseX:Number, mouseY:Number):void
		{
			for each(var b:Object in bristles)
			{
				if(offsetBristles)
				{
					b.offsetX = (Math.random() > 0.5 ? Math.random() * 10 : -Math.random() * 10),
					b.offsetY = (Math.random() > 0.5 ? Math.random() * 10 : -Math.random() * 10)
				}
				
				b.currentOffsetX = b.offsetX;
				b.currentOffsetY = b.offsetY;
				
				b.accumulatedDist = 0;
			
				b.lastMouseX = b.smoothedMouseX = b.lastSmoothedMouseX = mouseX;
				b.lastMouseY = b.smoothedMouseY = b.lastSmoothedMouseY = mouseY;
				
				b.lastRotation = 0;
				b.lineRotation = 0;
				b.lastThickness = 0;
			}
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void 
		{ 
			var mat:Matrix = new Matrix(); 
			mat.createGradientBox(op.dist,// w
				op.lineThickness,	// h
				op.angle,	// rotation
				0, 	// tx
				0); // ty
			
			if(op.lineStyleEnabled)
				graphics.lineStyle();
			
			graphics.beginGradientFill(GradientType.LINEAR, // type
				[op.sampleColor, op.lastColour], // colors
				[op.alpha, op.alpha], // alphas
				[0, 255], // ratios
				mat);
			
			if(op.lineStyleEnabled)
				graphics.lineStyle(alpha, op.sampleColor, op.alpha);
			
			graphics.moveTo(op.cx0, op.cy0);
			graphics.curveTo(op.controlX1,op.controlY1, op.cx1, op.cy1);
			
			if(op.lineStyleEnabled)
				graphics.lineStyle();
			
			graphics.lineTo(op.cx2, op.cy2);
			
			if(op.lineStyleEnabled)
				graphics.lineStyle(alpha, op.sampleColor, op.alpha);
			
			graphics.curveTo(op.controlX2, op.controlY2, op.cx3, op.cy3);
			
			if(op.lineStyleEnabled)
				graphics.lineStyle();
			
			graphics.lineTo(op.cx0, op.cy0);
			
			graphics.endFill();
		}
		
		override public function draw(graphics:Graphics, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Array
		{	
			var objects:Array = new Array();
			
			for each(var b:Object in bristles)
			{
				if(randomizeOffset)
				{
					b.offsetX =  (Math.random() > 0.5 ? Math.random() * plusMinusOffsetRange : -Math.random() * plusMinusOffsetRange),
					b.offsetY = (Math.random() > 0.5 ? Math.random() * plusMinusOffsetRange : -Math.random() * plusMinusOffsetRange)
				}
				
				mouseX += b.offsetX;
				mouseY += b.offsetY;
				
				updateSampleColor(mouseX, mouseY);
				
//				alpha =  (sampleColor >> 24 & 0xFF) / 255.0;
//				var red:uint = sampleColor >> 16 & 0xFF;
//				var green:uint = sampleColor >> 8 & 0xFF;
//				var blue:uint = sampleColor & 0xFF;
				
				var dx2:Number = mouseX - b.lastMouseX;
				var dy2:Number = mouseY - b.lastMouseY;
				var dist2:Number = Math.sqrt(dx2*dx2 + dy2*dy2);
			
				var f:Number = 0.0;
				var fence:Number = 75;
				if (dist2 > fence)
					f = 1;
				else
					f = 1- (dist2 / fence);
			
				var firstPoint:Point = new Point(mouseX, mouseY);
				var secondPoint:Point = new Point(mouseX + b.offsetX, mouseY + b.offsetY);
			
				//var interp:Point = Point.interpolate(firstPoint, secondPoint,f); // 1 <--> 0
				var interp:Point = Point.interpolate(secondPoint, firstPoint,f); // 1 <--> 0
			
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
				
				//b.targetLineThickness = b.minThickness + b.thicknessFactor * b.dist;
				//b.lineThickness = b.lastThickness + b.thicknessSmoothingFactor * (b.targetLineThickness - b.lastThickness);
				//b.thicknessFactor = 0.25;
				b.lineThickness = b.dist * 0.25;//b.thicknessFactor;
				
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
				
				if(lineStyleEnabled)
					graphics.lineStyle();
				
				graphics.beginGradientFill(GradientType.LINEAR, // type
					[sampleColor, b.lastColour], // colors
					[alpha, alpha], // alphas
					[0, 255], // ratios
					mat);
			
				if(lineStyleEnabled)
					graphics.lineStyle(alpha, sampleColor, alpha);
				
				graphics.moveTo(cx0, cy0);
				graphics.curveTo(b.controlX1,b.controlY1, cx1, cy1);
				
				if(lineStyleEnabled)
					graphics.lineStyle();
				
				graphics.lineTo(cx2, cy2);
				
				if(lineStyleEnabled)
					graphics.lineStyle(alpha, sampleColor, alpha);
				
				graphics.curveTo(b.controlX2, b.controlY2, cx3, cy3);
				
				if(lineStyleEnabled)
					graphics.lineStyle();
				
				graphics.lineTo(cx0, cy0);
				
				graphics.endFill();
			
				objects.push({
					t:brushNum,
					dist:b.dist,
					lineThickness:b.lineThickness,
					angle:angle,
					lineStyleEnabled:lineStyleEnabled,
					sampleColor:sampleColor,
					lastColour:b.lastColour,
					alpha:alpha,
					cx0:cx0,
					cy0:cy0,
					cx1:cx1,
					cy1:cy1,
					cx2:cx2,
					cy2:cy2,
					cx3:cx3,
					cy3:cy3,
					controlX1:b.controlX1,
					controlY1:b.controlY1,
					controlX2:b.controlX2,
					controlY2:b.controlY2
				});
				
				b.lastColour = sampleColor;
				b.lastSmoothedMouseX = b.smoothedMouseX;
				b.lastSmoothedMouseY = b.smoothedMouseY;
				b.lastRotation = b.lineRotation;
				b.lastMouseX = mouseX;
				b.lastMouseY = mouseY;
				b.lastThickness = b.lineThickness;
			}
			
			return objects;
		}
		
		override public function help():Array
		{
			return new Array(
				"line-style-enabled <brush number, value>" +
				"\n    Example usage: line-style-enabled 6 1",
				
				"line-width <brush number, value>" +
				"\n    Example usage: line-width 6 10",
				
				"alpha <brush number, value>" +
				"\n    Example usage: alpha 6 0.5",
				
				"total-bristles <brush number, value>" +
				"\n    Example usage: total-bristles 6 10",
				
				"randomize-offset <brush number, value>" +
				"\n    Example usage: randomize-offset 6 1",
				
				"plus-minus-offset-range <brush number, value>" +
				"\n    Examlple usage: plus-minus-offset-range 6 40"
			);
		}
	}
}