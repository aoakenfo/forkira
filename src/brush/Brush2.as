package brush
{
	import flash.display.Graphics;
	import flash.events.MouseEvent;

	public class Brush2 extends Brush
	{
		public function Brush2()
		{
			super();
		}
		
		override public function mouseDown(mouseX:Number, mouseY:Number):void
		{ 
			lastMouseX = mouseX;
			lastMouseY = mouseY;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object
		{
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			graphics.moveTo(lastMouseX, lastMouseY);
			graphics.lineTo(mouseX, mouseY);
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			
			return null;
		}
	}
}