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
			lineThickness = 40;
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
			var mat:Matrix = new Matrix(); 
			mat.createGradientBox(op.dist,// w
				op.lineThickness,	// h
				op.angle,	// rotation
				0, 	// tx
				0); // ty
			
			if(op.lineRotation > 0)
				mat.translate(op.lastSmoothedMouseX, op.lastSmoothedMouseY);
			else
				mat.translate(op.smoothedMouseX, op.smoothedMouseY);
			
			graphics.beginGradientFill(GradientType.LINEAR, // type
				[op.sampleColor, op.lastColour], // colors
				[op.alpha, op.alpha], // alphas
				[0, 255], // ratios
				mat);
			
			graphics.moveTo(op.cx0, op.cy0);
			
			if(op.lineStyleEnabled)
				graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.curveTo(op.controlX1, op.controlY1, op.cx1, op.cy1);
			
			if(op.lineStyleEnabled)
				graphics.lineStyle();
			
			graphics.lineTo(op.cx2, op.cy2);
			
			if(op.lineStyleEnabled)
				graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.curveTo(op.controlX2, op.controlY2, op.cx3, op.cy3);
			
			if(op.lineStyleEnabled)
				graphics.lineStyle();
			
			graphics.lineTo(op.cx0, op.cy0);
			
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
			//lineThickness = lastThickness + thicknessSmoothingFactor * (targetLineThickness - lastThickness);
			
			sin0 = Math.sin(lastRotation);
			cos0 = Math.cos(lastRotation);
			sin1 = Math.sin(lineRotation);
			cos1 = Math.cos(lineRotation);
			
			L0Sin0 = lineThickness*sin0;//lastThickness*sin0;
			L0Cos0 = lineThickness*cos0;//lastThickness*cos0;
			L1Sin1 = lineThickness*sin1;//lineThickness*sin1;
			L1Cos1 = lineThickness*cos1;//lineThickness*cos1;
			
			controlVecX = 0.33*dist*sin0;
			controlVecY = -0.33*dist*cos0;
			controlX1 = lastSmoothedMouseX + L0Cos0 + controlVecX;
			controlY1 = lastSmoothedMouseY + L0Sin0 + controlVecY;
			controlX2 = lastSmoothedMouseX - L0Cos0 + controlVecX;
			controlY2 = lastSmoothedMouseY - L0Sin0 + controlVecY;
			
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
			
			graphics.moveTo(cx0, cy0);
			
			if(lineStyleEnabled)
				graphics.lineStyle(lineWidth, sampleColor, alpha);
			
			graphics.curveTo(controlX1, controlY1, cx1, cy1);
			
			if(lineStyleEnabled)
				graphics.lineStyle();
			
			graphics.lineTo(cx2, cy2);
			
			if(lineStyleEnabled)
				graphics.lineStyle(lineWidth, sampleColor, alpha);
			
			graphics.curveTo(controlX2, controlY2, cx3, cy3);
			
			if(lineStyleEnabled)
				graphics.lineStyle();
			
			graphics.lineTo(cx0, cy0);
			
			graphics.endFill();
			
			objects.push({
				t:13,
				dist:dist,
				lineStyleEnabled:lineStyleEnabled,
				lineThickness:lineThickness,
				angle:angle,
				lineWidth:lineWidth,
				lastSmoothedMouseX:lastSmoothedMouseX,
				lastSmoothedMouseY:lastSmoothedMouseY,
				sampleColor:sampleColor,
				lastColour:lastColour,
				alpha:alpha,
				lineWidth:lineWidth,
				cx0:cx0,
				cy0:cy0,
				cx1:cx1,
				cy1:cy1,
				cx2:cx2,
				cy2:cy2,
				cx3:cx3,
				cy3:cy3,
				controlX1:controlX1,
				controlY1:controlY1,
				controlX2:controlX2,
				controlY2:controlY2,
				lineRotation:lineRotation,
				smoothedMouseX:smoothedMouseX,
				smoothedMouseY:smoothedMouseY
			});
			
			lastSmoothedMouseX = smoothedMouseX;
			lastSmoothedMouseY = smoothedMouseY;
			lastRotation = lineRotation;
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			lastThickness = lineThickness;
			lastColour = sampleColor;
			
			return objects;
		}
	}
}