package com.gmrmarketing.sap.nhl2015.gda.cali
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.utils.Timer;
	import flash.text.TextFieldAutoSize;
	import flash.net.*;
	
	
	public class Tweet extends EventDispatcher
	{
		public static const COMPLETE:String = "tweetComplete";
		
		private var clip:MovieClip;//from lib - contains text field at 6,6 - contains rectContainer
		private var rectContainer:Sprite; //for drawing bg gradient rect - contains outlineContainer
		private var outlineContainer:Sprite;//so we can make a shadowed outline rect above the gradient bg rect
		private var lineContainer:Sprite; //for shooting the ray to the lat/lon loc
		private var container:DisplayObjectContainer;
		private var tweenOb:Object;
		//private var dot:MovieClip;
		private var myQuadrant:int; // 1 or 2
		private var vx:Number;
		private var vy:Number;
		private var drawToX:int;
		private var drawToY:int;
		private var lineColor:Number;
		private var fanImage:Bitmap;
		private var noPicBMP:Bitmap;
		
		//lib clip - 'clip' contains rectContainer on layer 0 - behind text already in the clip
		//rectContainer contains outlineContainer
		public function Tweet()
		{
			outlineContainer = new Sprite();//foreground outline and line to gps spot on map
			//outlineContainer.filters = [new DropShadowFilter(0, 0, 0x000000, .8, 7, 7)];
			
			lineContainer = new Sprite();
			//lineContainer.filters = [new DropShadowFilter(0, 0, 0x000000, .8, 7, 7)];
			
			rectContainer = new Sprite();//for drawing bg shape into
			//rectContainer.filters = [new DropShadowFilter(0, 0, 0x000000, .8, 7, 7)]
			
			rectContainer.addChild(lineContainer);
			rectContainer.addChild(outlineContainer);	
			
			vx = 0;
			vy = 0;
			
			tweenOb = new Object();//just a holder of tweening properties
			
			//dot = new mapDot(); //lib clip - animated expanding circle at lat/lon
			
			clip = new mcTweet();//lib clip - contains text field	
			clip.addChildAt(rectContainer, 0); //add behind text already in the clip	
			
			noPicBMP = new Bitmap(new noPic());//lib image
		}
		
		
		public function setContainer($container:DisplayObjectContainer):void
		{
			container = $container;
		}
		
		
		/**
		 * Shows this tweet message
		 * 
		 * @param	message up to 140 char message - no checks prevent > 140 though	
		 * @param 	pic String URL of user profile pic
		 * @param	toX Where to shoot the line to - the lat/lon spot
		 * @param	toY 
		 * @param	quadrant which quadrant the message goes in 1 - 4
		 */
		public function show(userName:String, message:String, pic:String, toX:int, toY:int, quadrant:int):void
		{
			if (!container.contains(clip)) {
				container.addChild(clip);
			}
			
			var imLoader:Loader = new Loader();
			imLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imLoaded, false, 0, true);			
			imLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imError, false, 0, true);			
			imLoader.load(new URLRequest(pic));
			
			clip.userPic.alpha = 0;
			clip.userBG.alpha = 0;
			clip.theText.alpha = 0; //contains the two text fields
			clip.theText.theUser.text = userName;			
						
			clip.theText.theText.autoSize = TextFieldAutoSize.LEFT;
			clip.theText.theText.text = message;
			var rectWidth:int = Math.max(200, clip.theText.theText.textWidth + 12);
			
			drawToX = toX;
			drawToY = toY;
			
			myQuadrant = quadrant;			
			
			//animated dot
			//dot.x = drawToX;
			//dot.y = drawToY;
			//dot.scaleX = dot.scaleY = .1;
			//dot.alpha = 1;
			//container.addChild(dot);
			//var sc:Number = .7 + 2 * Math.random();			
			//TweenMax.to(dot, 1, { alpha:0, scaleX:sc, scaleY:sc, rotation:45 + Math.random() * 90 } );
			
			switch(quadrant) {
				case 1:
					clip.x = 32 + Math.random() * 10;
					clip.y = 290 + Math.random() * 10;					
					drawToX = toX - clip.x;
					break;
				case 2:
					clip.x = 485 + Math.random() * 10;
					clip.y = 200 + Math.random() * 10;
					drawToX = clip.x - toX;
					break;
			}	
			
			var r:Number = Math.random();
			if (r < .33) {
				lineColor = 0xeeb400;//orange
			}else if (r < .66 ) {
				lineColor = 0x008fd3;//blue
			}else {
				lineColor = 0xa19a92;//gray
			}
			
			//animated line			
			//lineContainer.graphics.lineStyle(2, lineColor, 1);			
			
			//change toX,toY to screen coords, instead of outlineContainer coords			
			drawToX = toX - clip.x;			
			drawToY = toY - clip.y;
			
			//lineContainer.graphics.moveTo(drawToX, drawToY);
			tweenOb.x = drawToX;// clip.userPic.x + 45;
			tweenOb.y = drawToY;// clip.userPic.y + 45;
			//if (myQuadrant == 2) {
				//point on the left of the tweet	
				//TweenMax.to(tweenOb, .5, { x:drawToX, y:drawToY, onUpdate:drawLine, delay:.75, ease:Linear.easeNone, onComplete:drawTweetBox} );						
			//}else {			
				//TweenMax.to(tweenOb, .25, { x:rectWidth, y: -22, onUpdate:drawLine, delay:.75, ease:Linear.easeNone, onComplete:drawTweetBox } );			
			//}	
			drawTweetBox();
			
		}
		
		
		private function imLoaded(e:Event):void
		{	
			//remove old image from clip
			if(fanImage){
				if (clip.userPic.contains(fanImage)) {
					clip.userPic.removeChild(fanImage);
				}
			}
			
			fanImage = Bitmap(e.target.content);
			fanImage.smoothing = true;	
			fanImage.width = fanImage.height = 90;
			
			clip.userPic.addChildAt(fanImage, 1);
			fanImage.mask = clip.userPic.fanMask;
			TweenMax.to(clip.userPic, .5, { alpha:1, onComplete:drawLine } );
		}
		
		
		private function imError(e:IOErrorEvent):void
		{
			if(fanImage){
				if (clip.userPic.contains(fanImage)) {
					clip.userPic.removeChild(fanImage);
				}
			}
			
			fanImage = noPicBMP;
			fanImage.smoothing = true;	
			fanImage.width = fanImage.height = 90;
			
			clip.userPic.addChildAt(fanImage, 1);
			fanImage.mask = clip.userPic.fanMask;
			TweenMax.to(clip.userPic, .5, { alpha:1, onComplete:drawLine } );
		}
		
		
		//called by tweenMax onUpdate from show()
		private function drawLine():void
		{
			var g:Graphics = lineContainer.graphics;
			g.clear();
			g.beginFill(lineColor);			
			g.moveTo(clip.userPic.x, clip.userPic.y + 30);
			g.lineTo(tweenOb.x, tweenOb.y);
			g.lineTo(clip.userPic.x + 60, clip.userPic.y + 30);
			g.lineTo(clip.userPic.x, clip.userPic.y + 30);
			g.endFill();
		}
		
		
		private function drawTweetBox():void
		{
			TweenMax.to(lineContainer, 1, { alpha:0, delay:2 } );
			//clip.addEventListener(Event.ENTER_FRAME, drift);
			
			var rectWidth:int = Math.max(200, clip.theText.theText.textWidth + 12);
			
			//outline rect
			//outlineContainer.graphics.lineStyle(1, 0xffffff, 1, true);
			//outlineContainer.graphics.drawRoundRect(0, 0, rectWidth, clip.theText.theText.textHeight + 15, 18, 18);
			
			var g:Graphics = outlineContainer.graphics;
			
			var m:Matrix = new Matrix();
			m.createGradientBox(rectWidth, clip.theText.theText.textHeight + 15, 1.5707963);//the 1.57...PI/2 radians - 90º
			g.beginGradientFill(GradientType.LINEAR, [0xffffff, 0xc0c0c0], [1,1], [20, 255], m);
			g.drawRoundRect(0, 5, rectWidth, clip.theText.theText.textHeight + 15, 18, 18);
			g.endFill()			
			
			var u:Graphics = clip.userBG.graphics;
			u.beginFill(lineColor, 1);
			u.drawRoundRect(0, 0, rectWidth, 36, 18, 18);
			u.endFill();
			u.lineStyle(2, 0xffffff);
			u.drawRoundRect(0, 0, rectWidth, 36, 18, 18);
			
			//TweenMax.to(clip.userBG, 0, { colorTransform: { tint:lineColor, tintAmount:1 }} );			
			//clip.userBG.width = rectWidth;
			
			TweenMax.to(clip.theText, 1, { alpha:1 } );
			TweenMax.to(clip.userBG, 1, { alpha:1, onComplete:startEndTimer } );
		}
		
		
		private function startEndTimer():void
		{
			var tLen:int = Math.max(1, clip.theText.theText.length / 24);			
			var end:Timer = new Timer(tLen * 1000, 1);
			end.addEventListener(TimerEvent.TIMER, tweetComplete);
			end.start();
		}
		
		
		public function getQuadrant():int
		{
			return myQuadrant;
		}
		
		
		private function tweetComplete(e:TimerEvent):void
		{			
			TweenMax.to(clip, 1, { alpha:0, onComplete:dispose } );
		}
		
		
		public function dispose():void
		{
			lineContainer.graphics.clear();
			outlineContainer.graphics.clear();
			clip.userBG.graphics.clear();
			
			
			if (rectContainer.contains(outlineContainer)) {
				rectContainer.removeChild(outlineContainer);
			}
			if (rectContainer.contains(lineContainer)) {
				rectContainer.removeChild(lineContainer);
			}
			while (clip.numChildren) {
				clip.removeChildAt(0);
			}
			if (container.contains(clip)) {
				container.removeChild(clip);
			}
			/*
			if (container.contains(dot)) {
				container.removeChild(dot);
			}
			*/
			outlineContainer = null;
			lineContainer = null;
			rectContainer = null;
			clip = null;
			//dot = null;
			
			dispatchEvent(new Event(COMPLETE));
		}
	}
	
}