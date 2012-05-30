package brush
{
	import flash.display.Graphics;
	import flash.events.MouseEvent;

	public class Brush
	{
		public var lineWidth:Number = 1;
		public var alpha:Number = 0.5;
		public var iterations:uint = 10;
		public var lastMouseX:Number = -1;
		public var lastMouseY:Number = -1;
		
		public function set radius(value:Number):void { }
		
		public function mouseDown(mouseX:Number, mouseY:Number):void { }
			
		public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):void { }
	}
}