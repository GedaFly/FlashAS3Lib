package com.gmrmarketing.sap.metlife.eventsTicker
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.gmrmarketing.sap.metlife.FlareManager;
	
	public class Main extends MovieClip
	{		
		private var fanCache:Object;//last good pull of FOTD JSON from the web service
		private var eventsCache:Object;//last good pull of events JSON from the web service
		private var fanImage:Bitmap;
		private var slideIndex:int; //current showing slide in the slider
		private var totalSlides:int; //total number of slides - starts at 3
		private var flares:FlareManager;
		
		public function Main()
		{
			flares = new FlareManager();//will be part of scheduler
			flares.setContainer(this);
			totalSlides = 3; //two logos and fotd
			refreshFOTD();
		}
		
		
		/**
		 * refreshes FOTD data from the web service
		 */
		private function refreshFOTD():void
		{
			var hdr:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			var r:URLRequest = new URLRequest("http://wall.thesocialtab.net/SocialPosts/GetPosts?ProgramID=52&Count=5&Grouping=SAPJets" + "&abc=" + String(new Date().valueOf()));
			r.requestHeaders.push(hdr);
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, dataLoaded, false, 0, true);
			l.addEventListener(IOErrorEvent.IO_ERROR, dataError, false, 0, true);
			try{
				l.load(r);
			}catch (e:Error) {
				
			}
		}
		
		
		private function dataLoaded(e:Event):void
		{
			fanCache = JSON.parse(e.currentTarget.data);			
			loadFOTDImage();
		}
		
		
		private function dataError(e:IOErrorEvent):void
		{
			//do nothing if error...			
			trace("dateError()");
		}
		
		
		private function loadFOTDImage():void
		{			
			var imageURL:String = fanCache.SocialPosts[0].MediumResURL;			
			if(imageURL){
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
			if(fanImage){
				if (slider.fotd.contains(fanImage)) {
					slider.fotd.removeChild(fanImage);
				}
			}
			
			fanImage = Bitmap(e.target.content);
			fanImage.smoothing = true;
			
			var r:Number;
			if (144 / fanImage.width > 145 / fanImage.height) {
				//height is greater than width
				r = 144 / fanImage.width;
			}else {
				r = 145 / fanImage.height;
			}
			fanImage.width = fanImage.width * r;
			fanImage.height = fanImage.height * r;
			
			slider.fotd.addChild(fanImage);
			fanImage.x = 43;//TODO: Center if too big still?
			fanImage.y = 78;
			fanImage.mask = slider.fotd.picMask;
			
			slider.fotd.userName.text = fanCache.SocialPosts[0].AuthorName;
			slider.fotd.theText.text = fanCache.SocialPosts[0].Text;	
			
			refreshEvents();
		}
		
		
		private function imError(e:IOErrorEvent):void
		{
			//do nothing if image error
			trace("imageError");
		}
		
		
		//TODO: Date has to come from config file...
		private function refreshEvents():void
		{			
			var hdr:URLRequestHeader = new URLRequestHeader("Accept", "application/json");
			var r:URLRequest = new URLRequest("http://sapmetlifeapi.thesocialtab.net/api/GameDay/GetGameDayEvents?gamedate=10/12/14" + "&abc=" + String(new Date().valueOf()));
			r.requestHeaders.push(hdr);
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, eventsLoaded, false, 0, true);
			l.addEventListener(IOErrorEvent.IO_ERROR, eventsError, false, 0, true);
			try{
				l.load(r);
			}catch (e:Error) {
				
			}
		}
		
		
		private function eventsLoaded(e:Event):void
		{
			eventsCache = JSON.parse(e.currentTarget.data);
			//for each event add an events clip t the end of the slider
			for (var i:int = 0; i < eventsCache.length; i++) {
				var ev:MovieClip = new event(); //lib clip
				ev.x = slider.width;
				slider.addChild(ev);
				ev.headline.text = eventsCache[i].Headline;
				ev.displayTime.text = eventsCache[i].DisplayTime;
				ev.title.text = eventsCache[i].Title;
				ev.hashtag.text = eventsCache[i].Hashtag;
				totalSlides++;
			}
			//add sap logo to end
			var l:MovieClip = new logoLockup();
			l.x = slider.width;
			slider.addChild(l);
			totalSlides++;
			resetSlide();
		}
		
		
		private function eventsError(e:IOErrorEvent):void
		{
			//do nothing if error...			
		}
		
		
		private function resetSlide():void
		{
			slider.x = 0;
			slideIndex = 0;
			slideNext();
		}
		
		
		private function slideNext():void
		{
			slideIndex++;
			if (slideIndex == 1) {
				//fotd will be showing next
				slider.fotd.theMask.x = -619;
			}
			TweenMax.to(slider, .75, { x:"-1008", delay:10, onStart:checkFOTD, onComplete:checkForEnd } );
		}		
		
		private function checkFOTD():void
		{
			if (slideIndex == 1) {
				TweenMax.to(slider.fotd.theMask, .5, { x:191, delay:.5 } );
				flares.newFlare(190, 85, 530, 1.5);	//x,y,toX,delay		
				flares.newFlare(80, 240, 925, 1);	//x,y,toX,delay		
			}
			if (slideIndex > 2 && slideIndex < totalSlides-1) {
				flares.newFlare(90, 75, 920, 1.5);	//x,y,toX,delay		
				flares.newFlare(135, 228, 870, 1);	//x,y,toX,delay		
			}
		}
		
		private function checkForEnd():void
		{
			if (slider.x <= -slider.width + 1008) {
				resetSlide();
			}else {
				slideNext();
			}
		}
		
	}
	
}