package brush
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import mx.collections.ArrayList;
	
	import spark.components.Image;

	public class Brush
	{
		public var sourceBitmap:Image = null;
		
		public var brushNum:Number = -1;
		public var lineWidth:Number = 1;
		public var alpha:Number = 0.5;
		public var iterations:uint = 10;
		public var lastMouseX:Number = -1;
		public var lastMouseY:Number = -1;
		protected var _radius:Number = -1;
		public var centerOffset:Number = -1;
		
		public var bristles:Array = new Array();
		public var sourceLocal:Point = new Point();
		public var sampleColor:Number = 0;
		public var randomizeOffset:Boolean = false;
		public var plusMinusOffsetRange:Number = 45;
		public var renderGroupOffsetX:Number = 0;
		public var renderGroupOffsetY:Number = 0;
		public var lineStyleEnabled:Boolean = false;
		public var offsetBristles:Boolean = true;
		
		public var offsetX:Number = 0;
		public var offsetY:Number = 0;
		
		public function updateSampleColor(mouseX:Number, mouseY:Number):void
		{
			sourceLocal = sourceBitmap.globalToLocal(new Point(mouseX + renderGroupOffsetX, mouseY + renderGroupOffsetY));
			
			// clamp
			if(sourceLocal.x < 0)
				sourceLocal.x = 0;
			else if(sourceLocal.x > sourceBitmap.source.bitmapData.width)
				sourceLocal.x = sourceBitmap.source.bitmapData.width - 1;
			if(sourceLocal.y < 0)
				sourceLocal.y = 0;
			else if(sourceLocal.y > sourceBitmap.source.bitmapData.height)
				sourceLocal.y = sourceBitmap.source.bitmapData.height - 1;
			
			sampleColor = sourceBitmap.source.bitmapData.getPixel32(sourceLocal.x, sourceLocal.y);
		}
		
		public function get radius():Number { return _radius; }
		
		public function set radius(value:Number):void
		{
			_radius = value;
			centerOffset = value * 0.5;
		}
		
		public function totalBristles(numBristles:Number):void { }
		public function mouseDown(mouseX:Number, mouseY:Number):void { }
		public function mouseUp(mouseX:Number, mouseY:Number):void { }
		public function drawOp(graphics:Graphics, op:Object):void { }
		public function draw(graphics:Graphics, sampleColor:Number, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Object { return null; }
		public function draw2(graphics:Graphics, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Array { return null; }
		
		protected function toRad(a:Number):Number
		{
			return a*Math.PI/180;
		}
		
		protected function darkenColor(c:uint, factor:Number):uint
		{
			var r:Number = (c >> 16);
			var g:Number = (c >> 8) & 0xFF;
			var b:Number = c & 0xFF;
			
			var newRed:Number = Math.min(255, r*factor);
			var newGreen:Number = Math.min(255, g*factor);
			var newBlue:Number = Math.min(255, b*factor);
			
			return (newRed << 16) | (newGreen << 8) | (newBlue);
		}
		
		protected function map(value:Number,
							 low1:Number,
							 high1:Number,
							 low2:Number = 0,
							 high2:Number = 1):Number {
			//if the value and the 1st range low are equal to
			// the new value must be low2
			if (value == low1) {
				return low2;
			}
			
			//normalize both sets to a 0-? range
			var range1:Number = high1 - low1;
			var range2:Number = high2 - low2;
			
			//normalize the value to the new normalized range
			var result:Number = value - low1;
			
			//define the range as a percentage (0.0 to 1.0)
			var ratio:Number = result / range1;
			
			//find the value in the new normalized-range
			result = ratio * range2;
			
			//un-normalize the value in the new range
			result += low2;
			
			return result;
		}
		
	}
}