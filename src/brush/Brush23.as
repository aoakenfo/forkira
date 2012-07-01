package brush
{
	import flash.display.Graphics;

	public class Brush23 extends Brush
	{
		public function Brush23()
		{
			super();
			
			brushNum = 23;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object
		{
			
			
			return {t:23};
		}
	}
}