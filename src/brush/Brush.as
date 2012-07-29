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
		
		protected var mouseChangeVectorX:Number;
		protected var mouseChangeVectorY:Number;
		protected var dx:Number;
		protected var dy:Number;
		protected var dist:Number;
		protected var startX:Number;
		protected var startY:Number;
		public var lineThickness:Number = 15;
		public var lineThicknessMultiplier:Number = 1;
		protected var lineRotation:Number;
		protected var lastRotation:Number;
		protected var L0Sin0:Number;
		protected var L0Cos0:Number;
		protected var L1Sin1:Number;
		protected var L1Cos1:Number;
		protected var sin0:Number;
		protected var cos0:Number;
		protected var sin1:Number;
		protected var cos1:Number;
		protected var controlVecX:Number;
		protected var controlVecY:Number;
		protected var controlX1:Number;
		protected var controlY1:Number;
		protected var controlX2:Number;
		protected var controlY2:Number;
		protected var lastColour:uint;
		
		protected var smoothedMouseX:Number = 0;
		protected var smoothedMouseY:Number = 0;
		protected var lastSmoothedMouseX:Number = 0;
		protected var lastSmoothedMouseY:Number = 0;
		protected var smoothingFactor:Number = 0.3;  //Should be set to something between 0 and 1.  Higher numbers mean less smoothing.
		
		protected var lastMouseChangeVectorX:Number;
		protected var lastMouseChangeVectorY:Number;
		
		protected var targetLineThickness:Number;
		protected var minThickness:Number = 0.2;
		public var thicknessFactor:Number = 0.25;
		protected var lastThickness:Number = 0;
		protected var thicknessSmoothingFactor:Number = 0.3;
		
		protected var tipTaperFactor:Number = 0.8;
		protected var currentOffsetX:Number = 0;
		protected var currentOffsetY:Number = 0;
		protected var currentColorListIndex:int = 0;
		
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
		public function draw(graphics:Graphics, mouseX:Number, mouseY:Number, colorList:ArrayList = null):Array { return null; }
		
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