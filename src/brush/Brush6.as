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
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{	
			mouseChangeVectorX = mouseX - lastMouseX;
			mouseChangeVectorY = mouseY - lastMouseY;
			
			lineThickness = Math.random() * 20;
			
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
			
			//trace(lineRotation);
			
			L0Sin0 = lineThickness*sin0;
			L0Cos0 = lineThickness*cos0;
			L1Sin1 = lineThickness*sin1;
			L1Cos1 = lineThickness*cos1;
			
			graphics.lineStyle(1, sampleColor, alpha);
			graphics.beginFill(sampleColor, alpha);
				
			/*
			mc.graphics.moveTo(lastMouseX + L0Cos0, lastMouseY + L0Sin0);
			mc.graphics.lineTo(bitmapHolder.mouseX + L1Cos1, bitmapHolder.mouseY + L1Sin1);
			mc.graphics.lineTo(bitmapHolder.mouseX - L1Cos1, bitmapHolder.mouseY - L1Sin1);
			mc.graphics.lineTo(lastMouseX - L0Cos0, lastMouseY - L0Sin0);
			mc.graphics.lineTo(lastMouseX + L0Cos0, lastMouseY + L0Sin0);
			*/
			
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
			
			/*
			// info graphics
			mc.graphics.lineStyle(1, 0xffffff, 0.5);
			mc.graphics.moveTo(lastMouseX, lastMouseY);
			mc.graphics.lineTo(evt.localX, evt.localY);//bitmapHolder.mouseX, bitmapHolder.mouseY);
			*/
			
			lastRotation = lineRotation;
		
			lastMouseX = mouseX;//bitmapHolder.mouseX;
			lastMouseY = mouseY;//bitmapHolder.mouseY;
			
			lastColour = sampleColor;
			
			return {t:6};
		}
	}
}