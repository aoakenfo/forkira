package brush
{
	import flash.display.Graphics;
	
	import mx.collections.ArrayList;

	public class Brush6 extends Brush
	{
		public function Brush6()
		{
			super();
			
			brushNum = 6;
			plusMinusOffsetRange = 10;
			lineStyleEnabled = true;
		}
		
		// TODO: move into base class
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
		
		override public function mouseDown(mouseX:Number, mouseY:Number):void
		{
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			lastRotation = 0;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			if(op.lineStyleEnabled)
				graphics.lineStyle(op.lineWidth, op.sampleColor, op.alpha);
			
			graphics.beginFill(op.sampleColor, op.alpha);
			
			graphics.moveTo(op.lastMouseX + op.L0Cos0, op.lastMouseY + op.L0Sin0);
			graphics.curveTo(op.controlX1, op.controlY1, op.mouseX + op.L1Cos1, op.mouseY + op.L1Sin1);
			graphics.lineTo(op.mouseX - op.L1Cos1, op.mouseY - op.L1Sin1);
			graphics.curveTo(op.controlX2, op.controlY2, op.lastMouseX - op.L0Cos0, op.lastMouseY - op.L0Sin0);
			graphics.lineTo(op.lastMouseX + op.L0Cos0, op.lastMouseY + op.L0Sin0);
			
			graphics.endFill();
		}
		
		override public function draw2(graphics:Graphics, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Array
		{
			var objects:Array = new Array();
			
			updateSampleColor(mouseX, mouseY);	
			
			mouseChangeVectorX = mouseX - lastMouseX;
			mouseChangeVectorY = mouseY - lastMouseY;
			
			lineThickness = Math.random() * plusMinusOffsetRange;
			
			dx = mouseChangeVectorX;
			dy = mouseChangeVectorY;
			dist = Math.sqrt(dx*dx + dy*dy);
			
			if (dist != 0)
				lineRotation = Math.PI/2 + Math.atan2(dy,dx);
			else
				lineRotation = 0;
			
			sin0 = Math.sin(lastRotation);
			cos0 = Math.cos(lastRotation);
			sin1 = Math.sin(lineRotation);
			cos1 = Math.cos(lineRotation);
			
			L0Sin0 = lineThickness*sin0;
			L0Cos0 = lineThickness*cos0;
			L1Sin1 = lineThickness*sin1;
			L1Cos1 = lineThickness*cos1;
			
			if(lineStyleEnabled)
				graphics.lineStyle(lineWidth, sampleColor, alpha);
			
			graphics.beginFill(sampleColor, alpha);
			
			controlVecX = 0.33*dist*sin0;
			controlVecY = -0.33*dist*cos0;
			controlX1 = lastMouseX + L0Cos0 + controlVecX;
			controlY1 = lastMouseY + L0Sin0 + controlVecY;
			controlX2 = lastMouseX - L0Cos0 + controlVecX;
			controlY2 = lastMouseY - L0Sin0 + controlVecY;
			
			graphics.moveTo(lastMouseX + L0Cos0, lastMouseY + L0Sin0);
			graphics.curveTo(controlX1,controlY1, mouseX + L1Cos1, mouseY + L1Sin1);
			graphics.lineTo(mouseX - L1Cos1, mouseY - L1Sin1);
			graphics.curveTo(controlX2, controlY2, lastMouseX - L0Cos0, lastMouseY - L0Sin0);
			graphics.lineTo(lastMouseX + L0Cos0, lastMouseY + L0Sin0);
			
			graphics.endFill();
			
			objects.push({
				t:6,
				lineStyleEnabled:lineStyleEnabled,
				lineWidth:lineWidth,
				sampleColor:sampleColor,
				alpha:alpha,
				mouseX:mouseX,
				mouseY:mouseY,
				lastMouseX:lastMouseX,
				lastMouseY:lastMouseY,
				L0Cos0:L0Cos0,
				L0Sin0:L0Sin0,
				L1Cos1:L1Cos1,
				L1Sin1:L1Sin1,
				controlX1:controlX1,
				controlY1:controlY1,
				controlX2:controlX2,
				controlY2:controlY2
			});
			
			lastRotation = lineRotation;
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			lastColour = sampleColor;
			
			return objects;
		}
	}
}