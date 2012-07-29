package brush
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;

	public class Brush10 extends Brush
	{
		public function Brush10()
		{
			super();
			
			brushNum = 10;
			iterations = 3;
			plusMinusOffsetRange = 10;
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
			graphics.beginFill(op.sampleColor, op.alpha);
			graphics.moveTo(op.lastSmoothedMouseX + op.L0Cos0, op.lastSmoothedMouseY + op.L0Sin0);
			
			if(op.lineStyleEnabled && Math.random() > 0.5)
				graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.curveTo(op.controlX1, op.controlY1, op.smoothedMouseX + op.L1Cos1, op.smoothedMouseY + op.L1Sin1);
			
			if(op.lineStyleEnabled && Math.random() > 0.5)
				graphics.lineStyle();
			
			graphics.lineTo(op.smoothedMouseX - op.L1Cos1, op.smoothedMouseY - op.L1Sin1);
			
			if(op.lineStyleEnabled && Math.random() > 0.5)
				graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.curveTo(op.controlX2, op.controlY2, op.lastSmoothedMouseX - op.L0Cos0, op.lastSmoothedMouseY - op.L0Sin0);
			
			if(op.lineStyleEnabled && Math.random() > 0.5)
				graphics.lineStyle();
			
			graphics.lineTo(op.lastSmoothedMouseX + op.L0Cos0, op.lastSmoothedMouseY + op.L0Sin0);
			
			graphics.endFill();
			
			if(op.lineStyleEnabled && Math.random() > 0.5)
				graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.beginFill(op.sampleColor, op.alpha);
			
			graphics.moveTo(op.smoothedMouseX + op.L1Cos1, op.smoothedMouseY + op.L1Sin1);
			graphics.lineTo(op.localX + op.tipTaperFactor * op.L1Cos1, op.localY + op.tipTaperFactor * op.L1Sin1);
			graphics.lineTo(op.localX - op.tipTaperFactor * op.L1Cos1, op.localY - op.tipTaperFactor * op.L1Sin1);
			graphics.lineTo(op.smoothedMouseX - op.L1Cos1, op.smoothedMouseY - op.L1Sin1);
			graphics.lineTo(op.smoothedMouseX + op.L1Cos1, op.smoothedMouseY + op.L1Sin1);	
			
			graphics.endFill();
		}
		
		override public function draw(graphics:Graphics, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Array
		{
			var objects:Array = new Array();
			
			for(var i:int = 0; i < iterations; ++i)
			{
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
				
				mouseX += Math.random() * plusMinusOffsetRange * (Math.random() > 0.5 ? -1 : 1);
				mouseY += Math.random() * plusMinusOffsetRange * (Math.random() > 0.5 ? -1 : 1);
			
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
				
				if(Math.random() > 0.5)
				{
					currentOffsetX = mouseX - interp.x;
					currentOffsetY = mouseY - interp.y;
				}
				
				var localX:int = mouseX + currentOffsetX;
				var localY:int = mouseY + currentOffsetY;
				
				if(Math.random() > 0.5)
				{
					smoothedMouseX = smoothedMouseX + smoothingFactor*(localX - smoothedMouseX);
					smoothedMouseY = smoothedMouseY + smoothingFactor*(localY - smoothedMouseY);
				}
				
				if(Math.random() > 0.5)
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
				
				targetLineThickness = minThickness + thicknessFactor * dist + (Math.random() * plusMinusOffsetRange);
				lineThickness = lastThickness + thicknessSmoothingFactor * (targetLineThickness - lastThickness);
				
				if(Math.random() > 0.5)
				{
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
				}
				
				graphics.beginFill(sampleColor, alpha);
				graphics.moveTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
				
				if(lineStyleEnabled && Math.random() > 0.5)
					graphics.lineStyle(lineWidth, sampleColor, alpha);
				
				graphics.curveTo(controlX1, controlY1, smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
				
				if(lineStyleEnabled && Math.random() > 0.5)
					graphics.lineStyle();
				
				graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
				
				if(lineStyleEnabled && Math.random() > 0.5)
					graphics.lineStyle(lineWidth, sampleColor, alpha);
				
				graphics.curveTo(controlX2, controlY2, lastSmoothedMouseX - L0Cos0, lastSmoothedMouseY - L0Sin0);
				
				if(lineStyleEnabled && Math.random() > 0.5)
					graphics.lineStyle();
				
				graphics.lineTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
				
				graphics.endFill();
				
				if(lineStyleEnabled && Math.random() > 0.5)
					graphics.lineStyle(lineWidth, sampleColor, alpha);
				
				graphics.beginFill(sampleColor, alpha);
				
				graphics.moveTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
				graphics.lineTo(localX + tipTaperFactor * L1Cos1, localY + tipTaperFactor * L1Sin1);
				graphics.lineTo(localX - tipTaperFactor * L1Cos1, localY - tipTaperFactor * L1Sin1);
				graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
				graphics.lineTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);	
				
				graphics.endFill();
				
				objects.push({
					t:brushNum,
					sampleColor:sampleColor,
					lineWidth:lineWidth,
					alpha:alpha,
					lineStyleEnabled:lineStyleEnabled,
					lastSmoothedMouseX:lastSmoothedMouseX,
					lastSmoothedMouseY:lastSmoothedMouseY,
					smoothedMouseX:smoothedMouseX,
					smoothedMouseY:smoothedMouseY,
					L0Cos0:L0Cos0,
					L0Sin0:L0Sin0,
					L1Cos1:L1Cos1,
					L1Sin1:L1Sin1,
					controlX1:controlX1,
					controlY1:controlY1,
					controlX2:controlX2,
					controlY2:controlY2,
					localX:localX,
					localY:localY,
					tipTaperFactor:tipTaperFactor
				});
				
				lastSmoothedMouseX = smoothedMouseX;
				lastSmoothedMouseY = smoothedMouseY;
				lastRotation = lineRotation;
				lastMouseX = mouseX;
				lastMouseY = mouseY;
				lastThickness = lineThickness;
			}
			
			return objects;
		}
	}
}