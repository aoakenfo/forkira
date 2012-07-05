package brush
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;

	public class Brush17 extends Brush
	{
		public function Brush17()
		{
			super();
			
			brushNum = 17;
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object
		{
			var centerX:Number = mouseX;
			var centerY:Number = mouseY;
			var locRadius:Number = 1;
			
			graphics.beginFill(sampleColor, .8);
			for ( var x:uint = 0; x < iterations; x ++ )
			{
				graphics.drawCircle( centerX + (Math.sin( x ) * locRadius ), centerY + (Math.cos( x ) * locRadius ), Math.random() * 10 );
				locRadius += Math.random() * 1;
			}
			graphics.endFill();
			
			return {t:17};
		}
	}
}