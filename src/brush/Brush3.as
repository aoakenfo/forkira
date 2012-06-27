package brush
{
	import flash.display.Graphics;

	public class Brush3 extends Brush
	{
		public function Brush3()
		{
			super();
			
			brushNum = 3;
			radius = 20;
			centerOffset = radius * 0.5;
		}
		
		override public function drawOp(graphics:Graphics, op:Object):void
		{
			graphics.lineStyle(op.lw, op.sc, op.a);
			graphics.beginFill(op.sc, op.a);
			
			graphics.moveTo(op.mx, op.my - op.co); 
			graphics.lineTo(op.mx + op.co, op.my + op.co); 
			graphics.lineTo(op.mx - op.co, op.my + op.co); 
			graphics.lineTo(op.mx, op.my - op.co); 
		}
		
		override public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number):Object
		{
			graphics.lineStyle(lineWidth, sampleColor, alpha);
			graphics.beginFill(sampleColor, alpha);
			
			graphics.moveTo(mouseX, mouseY - centerOffset); 
			graphics.lineTo(mouseX + centerOffset, mouseY + centerOffset); 
			graphics.lineTo(mouseX - centerOffset, mouseY + centerOffset); 
			graphics.lineTo(mouseX, mouseY - centerOffset); 

			return {
				t:3,
				lw:lineWidth,
				a:alpha,
				sc:sampleColor,
				mx:mouseX,
				my:mouseY,
				co:centerOffset
			};
		}	
	}
}