package brush
{
	import flash.display.Graphics;

	public class Brush20 extends Brush
	{
		public function Brush20()
		{
			super();
			
			brushNum = 20;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object
		{
			var centerX : Number = mouseX;
			var centerY : Number = mouseY;
			var r : Number = 10;
			
			graphics.lineStyle( 1, sampleColor );
			for ( var x:uint = 0; x < 25; x ++ )
			{
				if(x==0)
					graphics.moveTo(centerX + (Math.sin( x ) * r ), centerY + (Math.cos( x ) * r ) );
				else
					graphics.lineTo(centerX + (Math.sin( x ) * r ), centerY + (Math.cos( x ) * r ) );
				r ++;
			}
			
			return {t:20};
		}
	}
}