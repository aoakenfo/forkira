package brush
{
	import flash.display.Graphics;

	public class Brush18 extends Brush
	{
		public function Brush18()
		{
			super();
			
			brushNum = 18;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object
		{
			var centerX : Number = mouseX;
			var centerY : Number = mouseY;
			var locRadius : Number = 10;
			
			graphics.lineStyle( 1, sampleColor, alpha );
			for ( var x:uint = 0; x < 25; x ++ )
			{
				graphics.drawCircle( centerX + (Math.sin( x ) * locRadius ), centerY + (Math.cos( x ) * locRadius ), Math.random() * 4 );
				locRadius += Math.random() * 5;
			}
			
			return {t:18};
		}
	}
}