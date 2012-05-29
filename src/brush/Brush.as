package brush
{
	import flash.display.Graphics;

	public class Brush
	{
		public var lineWidth:Number = 1;
		public var alpha:Number = 0.5;
		public var iterations:uint = 10;
		
		public function set radius(value:Number):void { }
		
		public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):void
		{
			
		}
	}
}