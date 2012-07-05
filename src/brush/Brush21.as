package brush
{
	import flash.display.Graphics;
	
	import mx.collections.ArrayList;

	public class Brush21 extends Brush
	{
		public function Brush21()
		{
			super();
			
			brushNum = 21;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{
			graphics.lineStyle( lineWidth, sampleColor, alpha );
			graphics.beginFill(sampleColor, alpha );
			var xOffset:Number = Math.random() * 50;
			var yOffset:Number = Math.random() * 50;
			graphics.drawRoundRect( mouseX - (xOffset * 0.5),  mouseY - (yOffset * 0.5), xOffset, yOffset, 20, 20 );
			graphics.endFill();
			
			return {t:21};
		}
	}
}