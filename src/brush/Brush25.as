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
			
			for(var i:int = 0; i < iterations; ++i)
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
				
				targetLineThickness = minThickness + thicknessFactor * dist;
				lineThickness = lastThickness + thicknessSmoothingFactor * (targetLineThickness - lastThickness) + (Math.random() * 5);
				
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
					
				graphics.lineStyle(1,sampleColor, 0.75);
				
				graphics.beginFill(sampleColor, 0.55);
				graphics.moveTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
				graphics.lineTo(localX + tipTaperFactor*L1Cos1, localY + tipTaperFactor*L1Sin1);
				graphics.lineTo(localX - tipTaperFactor*L1Cos1, localY - tipTaperFactor*L1Sin1);
				graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
				graphics.lineTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);	
				graphics.endFill();
				
				objects.push({
					t:25
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