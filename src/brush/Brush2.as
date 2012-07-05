package brush
{
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;

	public class Brush2 extends Brush
	{
		public function Brush2()
		{
			super();
			
			brushNum = 2;
		}
		
		override public function mouseDown(mouseX:Number, mouseY:Number):void
		{ 
			lastMouseX = mouseX;
			lastMouseY = mouseY;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			graphics.lineStyle(op.lw, op.sc, op.a);
			graphics.moveTo(op.lmx, op.lmy);
			graphics.lineTo(op.mx, op.my);
			
			lastMouseX = op.mx;
			lastMouseY = op.my;	
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			graphics.moveTo(lastMouseX, lastMouseY);
			graphics.lineTo(mouseX, mouseY);
			
			var obj:Object = {
				t:2,
				lw:lineWidth,
				sc:sampleColor,
				a:alpha,
				mx:mouseX,
				my:mouseY,
				lmx:lastMouseX,
				lmy:lastMouseY
			};
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			
			return obj;
		}
	}
}