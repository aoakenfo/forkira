package brush
{
	import flash.display.Graphics;

	public class Brush1 extends Brush
	{
		protected var prevMouseX:Number = -1;
		protected var prevMouseY:Number = -1;
		
		private var _radius:Number;
		private var _halfRadius:Number;
		public var iterations:uint = 50;
		private var i:uint = 0;
		
		public function radius(value:Number):void
		{
			_radius = value;
			_halfRadius = value * 0.5;
		}
		
		public function Brush1()
		{
			_radius = 20;
			_halfRadius = _radius * 0.5;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):void
		{
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			
			graphics.moveTo(mouseX, mouseY);
			
			for(i = 0; i < iterations; ++i)
				graphics.lineTo(mouseX - _halfRadius + Math.random() * _radius, mouseY - _halfRadius + Math.random() * _radius);
		}
	}
}