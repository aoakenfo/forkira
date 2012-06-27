package brush
{
	import flash.display.Graphics;

	public class Brush4 extends Brush
	{
		public function Brush4()
		{
			super();
			
			brushNum = 4;
			radius = 100;
			centerOffset = radius * 0.5;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			graphics.lineStyle(op.lw, op.sc, op.a);
			graphics.beginFill(op.sc, op.a);
			
			graphics.moveTo(op.mx, op.my); 
			graphics.curveTo(op.mx + op.co, op.my + op.co, op.mx + (Math.random() * op.co), op.my + (Math.random() * op.co));
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object
		{
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			graphics.beginFill(sampleColor, alpha);
			
			graphics.moveTo(mouseX, mouseY); 
			graphics.curveTo(mouseX + centerOffset, mouseY + centerOffset, mouseX + (Math.random() * centerOffset), mouseY + (Math.random() * centerOffset));
			
			return {
				t:4,
				lw:lineWidth,
				sc:sampleColor,
				a:alpha,
				mx:mouseX,
				my:mouseY,
				co:centerOffset
			};
		}	
	}
}