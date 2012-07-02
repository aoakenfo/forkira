package brush
{
	import flash.display.Graphics;
	import flash.events.MouseEvent;

	public class Brush
	{
		public var brushNum:Number = -1;
		public var lineWidth:Number = 1;
		public var alpha:Number = 0.5;
		public var iterations:uint = 10;
		public var lastMouseX:Number = -1;
		public var lastMouseY:Number = -1;
		protected var _radius:Number = -1;
		public var centerOffset:Number = -1;
		
		public function get radius():Number { return _radius; }
		
		public function set radius(value:Number):void
		{
			_radius = value;
			centerOffset = value * 0.5;
		}
		
		public function mouseDown(mouseX:Number, mouseY:Number):void { }
		public function mouseUp(mouseX:Number, mouseY:Number):void { }
		public function drawOp(graphics:Graphics, op:Object):void { }
		public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object { return null; }
		
		protected function toRad(a:Number):Number
		{
			return a*Math.PI/180;
		}
	}
}