﻿package {
	import flash.display.Sprite;
	
	public class Ball extends Sprite {
		public var radius:Number;
		public var color:uint;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var mass:Number;
		
		public function Ball(radius:Number=40, color:uint=0xff0000) {
			this.radius = radius;
			mass = radius * 4;
			this.color = color;
			init();
		}
		public function init():void {
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		}
	}
}