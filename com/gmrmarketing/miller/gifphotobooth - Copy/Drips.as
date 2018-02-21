package com.gmrmarketing.miller.gifphotobooth
{	
	import flash.display.*;
	import flash.filters.*;
	import flash.events.*;
	import flash.geom.*;	
	import com.greensock.TweenMax;
	
	
	public class Drips 
	{
		private var disps:Array;
		private var myBG:MovieClip;
		private var myContainer:DisplayObjectContainer;
		
		public function Drips(c:DisplayObjectContainer)
		{
			disps = [];			
			
			myContainer = c;
			myContainer.visible = false;
			
			for(var i:int = 0; i < 2; i++){
				
				var o:Object = {};
				
				var filterL:DisplacementMapFilter = new DisplacementMapFilter();
				filterL.scaleX = 8;
				filterL.scaleY = 10;
				filterL.componentX = BitmapDataChannel.RED;
				filterL.componentY = BitmapDataChannel.RED;
				filterL.mode = DisplacementMapFilterMode.IGNORE;
				filterL.alpha = 0;
				filterL.color = 0x000000;
				
				//12 * 15 original
				var sc:Number = .5 + Math.random() * 1.5;
				var bmd:BitmapData = new BitmapData(12 * sc, 15 * sc);
				var m:Matrix = new Matrix();
				m.scale(sc, sc);
				
				var d:BitmapData = new dropDisp();	
				bmd.draw(d, m, null, null, null, true);
	
				//var d:BitmapData = new dropDisp();//lib clip				
				filterL.mapBitmap = bmd;// d;
				
				o.filt = filterL;
				
				o.drip = new mcDrip();//lib
				myContainer.addChild(o.drip);
				o.drip.y = 800 * Math.random();
				if (o.drip.y < 300) {
					o.drip.x = 1670 + Math.random() * 250;
				}else{
					o.drip.x = 1550 + Math.random() * 370;
				}
				
				o.drip.scaleX = o.drip.scaleY = sc;
				o.drip.alpha = .5 + Math.random() * .5;
				o.speed = 1 + Math.random() * 1.5;
				o.finalY = 1080 + Math.random() * 150;
				
				disps.push(o);
			}
			
		}		
		
		
		public function set bg(c:MovieClip):void
		{
			myBG = c;			
			myBG.addEventListener(Event.ENTER_FRAME, update);
			myContainer.visible = true;
		}
		
		
		public function pause():void
		{
			if(myBG){
				myBG.removeEventListener(Event.ENTER_FRAME, update);
			}
			
			myContainer.visible = false;
		}

		
		private function update(e:Event):void
		{
			var o:Object;
			var filt = [];
			
			for(var i:int = 0; i < 2; i++){
				o = disps[i];
				o.filt.mapPoint = new Point(o.drip.x,o.drip.y);//clip.pintL.x, clip.pintL.y
				
				o.drip.y += o.speed;
				if (o.drip.y >= o.finalY) {
					
					var sc:Number = .5 + Math.random() * 1.5;
					var m:Matrix = new Matrix();
					m.scale(sc, sc);
					
					var d:BitmapData = new dropDisp();	
					
					var bmd:BitmapData = new BitmapData(12 * sc, 15 * sc);
					bmd.draw(d, m, null, null, null, true);
					
					o.filt.mapBitmap = bmd;
			
					o.drip.y = 800 * Math.random();
					if (o.drip.y < 300) {
						o.drip.x = 1670 + Math.random() * 250;
					}else{
						o.drip.x = 1550 + Math.random() * 370;
					}
					o.speed = 1 + Math.random() * 1.5;
					o.drip.scaleX = o.drip.scaleY = sc;
					
					var a:Number = .5 + Math.random() * .5;
					o.drip.alpha = 0;
					o.finalY = 1080 + Math.random() * 15
					TweenMax.to(o.drip, .5, { alpha:a, delay: 2 * Math.random() } );
				}
				filt.push(o.filt);
			}
			myBG.filters = filt;
		}
		
	}
	
}