package brush
{
	import flash.display.Graphics;

	public class Brush5 extends Brush
	{
		public function Brush5()
		{
			super();
			
			brushNum = 5;
			radius = 10;
			centerOffset = radius * 0.5;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			graphics.lineStyle(op.lw, op.sc, op.a);
			graphics.beginFill(op.sc, op.a);
			
			graphics.moveTo(op.mx, op.my); 
			graphics.curveTo(op.mx - op.r, op.my, op.mx + op.r, op.my + op.r); 
			graphics.curveTo(op.mx + op.r,  op.my - op.co, op.mx - op.r, op.my - op.r); 
			graphics.curveTo(op.mx, op.my + op.r, op.mx, op.my - op.r); 
			graphics.curveTo(op.mx, op.my, op.mx + op.r, op.my);
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object
		{
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			graphics.beginFill(sampleColor, alpha);
			
			graphics.moveTo(mouseX, mouseY); 
			graphics.curveTo(mouseX - radius, mouseY, mouseX + radius, mouseY + radius); 
			graphics.curveTo(mouseX + radius,  mouseY - centerOffset, mouseX - radius, mouseY - radius); 
			graphics.curveTo(mouseX, mouseY + radius, mouseX, mouseY - radius); 
			graphics.curveTo(mouseX, mouseY, mouseX + radius, mouseY); 
			
			return {
				t:5,
				lw:lineWidth,
				a:alpha,
				sc:sampleColor,
				mx:mouseX,
				my:mouseY,
				r:radius,
				co:centerOffset
			};
		}	
	}
}