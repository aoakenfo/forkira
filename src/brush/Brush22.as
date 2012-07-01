package brush
{
	import flash.display.Graphics;

	public class Brush22 extends Brush
	{
		public function Brush22()
		{
			super();
			
			brushNum = 22;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object
		{
			var w:int = 20;
			var h:int = 20;
			for ( var x:uint = 0; x < 10; x ++ )
			{
				graphics.lineStyle( 3, sampleColor, alpha);
				graphics.moveTo( lastMouseX + (Math.random() * w),  lastMouseY + (Math.random() * h) );
				graphics.lineTo( mouseX + (Math.random() * w),  mouseY + (Math.random() * h) );
			}
			
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			
			return {t:22};
		}
	}
}