package brush
{
	import flash.display.Graphics;

	public class Brush19 extends Brush
	{
		public function Brush19()
		{
			super();
			
			brushNum = 19;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object
		{
			var centerX : Number = mouseX;
			var centerY : Number = mouseY;
			var increment : Number = 3;
			
			graphics.lineStyle( 1, sampleColor );
			for ( var r:uint = 0; r < 30; r ++ )
			{
				graphics.drawCircle( centerX, centerY, r );
				r += 3;
			}
			graphics.endFill();
			
			return {t:19};
		}
	}
}