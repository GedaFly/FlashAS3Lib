package com.gmrmarketing.sap.metlife.quote
{
	import com.gmrmarketing.sap.metlife.ISchedulerMethods;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.text.TextFormat;
	
	
	public class Main extends MovieClip implements ISchedulerMethods
	{
		public static const FINISHED:String = "finished";//dispatched when the task is complete. Player will call cleanup() now
		private var playerImage:Bitmap;
		private var localCache:Object;
		private var tempCache:Object; //json before the image is loaded
		private var myDate:String;
		
		
		public function Main()
		{
			//init("10/12/14");//TESTING
		}
		
		
		/**
		 * ISchedulerMethods
		 * @param	initValue
		 */
		public function init(initValue:String = ""):void
		{
			myDate = initValue;
			refreshData();
		}
		
		
		/**
		 * ISchedulerMethods
		 */ 
		public function getFlareList():Array
		{
			var fl:Array = new Array();
			
			//title
			fl.push([314, 71, 692, "line", 3]);//x, y, to x, type, delay
			fl.push([324, 114, 680, "point", 3.3]);//x, y, to x, type, delay			
			
			//quote
			fl.push([420, 152, 942, "line", 6]);//x, y, to x, type, delay
			fl.push([420, 82, 868, "point", 6]);//x, y, to x, type, delay
			
			//player pic
			fl.push([73, 168, 415, "point", 8]);//x, y, to x, type, delay
			fl.push([73, 448, 415, "point", 8.3]);//x, y, to x, type, delay
			
			return fl;
		}
		
		
		/**
		 * ISchedulerMethods
		 * Returns true if localCache has data in it
		 * ie if the service has completed successfully at least once
		 * @return
		 */
		public function isReady():Boolean
		{
			return localCache != null;
		}
		
		private function refreshData():void
		{
			var hdr:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			var r:URLRequest = new URLRequest("http://sapmetlifeapi.thesocialtab.net/api/GameDay/GetPlayerQuotes?gamedate=" + myDate + "&abc=" + String(new Date().valueOf()));
			r.requestHeaders.push(hdr);
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, dataLoaded, false, 0, true);
			l.addEventListener(IOErrorEvent.IO_ERROR, dataError, false, 0, true);
			try{
				l.load(r);
			}catch (e:Error) {
				
			}
		}
		
		private function dataError(e:IOErrorEvent):void	{ }
		
		private function dataLoaded(e:Event):void
		{
			tempCache = JSON.parse(e.currentTarget.data);
			var imageURL:String = tempCache.HeadshotURL + "?abc=" + String(new Date().valueOf());
			if(tempCache.HeadshotURL){
				var l:Loader = new Loader();
				l.contentLoaderInfo.addEventListener(Event.COMPLETE, imLoaded, false, 0, true);			
				l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imError, false, 0, true);			
				l.load(new URLRequest(imageURL));
			}
		}
		
		
		/**
		 * Called once FOTD data and image have successfully loaded
		 * refreshes the data in the slider.fotd clip
		 * @param	e
		 */
		private function imLoaded(e:Event):void
		{
			//remove old image from clip
			if(playerImage){
				if (picHolder.contains(playerImage)) {
					picHolder.removeChild(playerImage);
				}
			}
			
			playerImage = Bitmap(e.target.content);
			playerImage.smoothing = true;
			
			picHolder.addChild(playerImage);
			playerImage.x = 6;
			playerImage.y = 5;
			
			picHolder.x = 420;
			picHolder.alpha = 0;
			
			localCache = tempCache;
			//show();//TESTING
		}
			
		
		private function imError(e:IOErrorEvent):void
		{
			//do nothing if image error
			trace("imageError");
			picHolder.x = 420;
			picHolder.alpha = 0;
		}
		
		/**
		 * ISchedulerMethods
		 * Called right before the task is placed on screen
		 */
		public function show():void
		{					
			theVideo.play();
			
			theText.text = localCache.Body;
			theByline.text = " - " + localCache.Byline;
			
			theText.y = 172 + ((212 - theText.textHeight) * .5);
			
			var baseSize:int = 33;
			var myFormat:TextFormat = new TextFormat();			
			while (theText.y < 172) {
				baseSize--;
				myFormat.size = baseSize;
				theText.setTextFormat(myFormat);
				theText.y = 172 + ((212 - theText.textHeight) * .5);
			}
			
			TweenMax.to(picHolder, .5, { x:71, delay:1 } );
			TweenMax.to(picHolder, 0, { alpha:1, delay:1 } );
			TweenMax.delayedCall(20, complete);
		}
		
		
		private function complete():void
		{
			dispatchEvent(new Event(FINISHED));
		}
		
		/**
		 * ISchedulerMethods
		 * 
		 */
		public function cleanup():void
		{
			theVideo.seek(0);
			theVideo.stop();
			refreshData(); //preload next trivia			
		}
		
	}
	
}