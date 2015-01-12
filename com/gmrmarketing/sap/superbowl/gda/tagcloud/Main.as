package com.gmrmarketing.sap.superbowl.gda.tagcloud
{
	import com.gmrmarketing.sap.superbowl.gda.IModuleMethods;
	import flash.display.*;
	import com.gmrmarketing.sap.metlife.tagcloud.RectFinder;	
	import com.gmrmarketing.sap.superbowl.gda.tagcloud.TagCloud;
	import flash.events.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;	
	import flash.filters.DropShadowFilter;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	
	public class Main extends MovieClip implements IModuleMethods
	{
		public static const FINISHED:String = "finished";//dispatched when the task is complete. Player will call cleanup() now
		
		private var dict:TagCloud;//tags from the service
		private var ra:RectFinder;
		private var ra2:RectFinder;
		private var tagName:String; //set in setConfig, one of: levis,offense,defense
		private var tagContainer:Sprite;//these two for the smaller clouds
		private var tagContainer2:Sprite;
		private var tagContainer3:Sprite; //this one for the big cloud
		
		private var localCache:Object;
		private var myDate:String; //from xml
		private var myColors:Array; //from xml
		
		private var TESTING:Boolean = true;
		private var single:Boolean = true;
		
		public function Main()
		{			
			ra = new RectFinder(4);
			ra2 = new RectFinder(4);
			
			dict = new TagCloud(4, 40, 10);
			dict.addEventListener(TagCloud.TAGS_READY, tagsLoaded, false, 0, true);
			
			tagContainer = new Sprite();
			tagContainer2 = new Sprite();
			tagContainer3 = new Sprite();
			
			tagContainer.x = 10;
			tagContainer.y = 170;
			tagContainer2.y = 170;
			tagContainer2.x = 325;
			tagContainer3.x = 52;
			tagContainer3.y = 120;
			
			if (TESTING) {
				init("single");
			}
		}		
		
		
		public function init(initValue:String = "single"):void
		{			
			if (initValue == "single") {
				single = true;
				team1.visible = false;
				team2.visible = false;
				addChild(tagContainer3);
			}else {
				single = false;
				team1.visible = true;
				team2.visible = true;
				team1.x = -250;
				team2.x = 640;
				addChild(tagContainer);
				addChild(tagContainer2);
			}
			
			dict.refreshTags([0xffffff], "12/28/14");//TagCloud calls tagsLoaded when ready - this loads all the tags
		}			
		
		
		/**
		 * callback from calling TagCloud.refreshTags()
		 * all tags are ready now - all levels
		 * @param	e
		 */
		private function tagsLoaded(e:Event):void
		{
			localCache = 1;//this just so isready() will return true			
			if (TESTING) {
				show();
			}
		}		
		
		
		public function isReady():Boolean
		{
			return localCache != null;
		}		
		
	
		public function show():void
		{			
			if (single) {				
				ra.create(tagContainer3, new cloudBig(), dict.getTags("sb49"), true, false, 8000, 0, new DropShadowFilter(4, 45, 0, .8, 6, 6, 1, 2));
				ra.addEventListener(RectFinder.FINISHED, tagsComplete, false, 0, true);
			}else {				
				team1.x = -250;
				team2.x = 640;
				TweenMax.to(team1, .5, { x:66, ease:Back.easeOut } );
				TweenMax.to(team2, .5, { x:353, delay:.1, ease:Back.easeOut } );
				ra.create(tagContainer, new cloudSmall(), dict.getTags("nfc"), true, false, 8000, 0, new DropShadowFilter(4,45,0,.8,6,6,1,2));
				ra2.create(tagContainer2, new cloudSmall(), dict.getTags("afc"), true, false, 8000, 0, new DropShadowFilter(4, 45, 0, .8, 6, 6, 1, 2));
				ra.addEventListener(RectFinder.FINISHED, tagsComplete, false, 0, true);
				ra2.addEventListener(RectFinder.FINISHED, tagsComplete2, false, 0, true);				
			}				
		}
		
		
		/**
		 * called when the cloud has completed
		 * @param	e
		 */
		private function tagsComplete(e:Event):void
		{
			ra.removeEventListener(RectFinder.FINISHED, tagsComplete);
			//transitionLevel or done
		}
		private function tagsComplete2(e:Event):void
		{
			ra2.removeEventListener(RectFinder.FINISHED, tagsComplete);
			//transitionLevel or done
		}
		
		
		private function done(e:TimerEvent = null):void
		{
			dispatchEvent(new Event(FINISHED));//will call cleanup
		}
		
		
		private function transition(e:TimerEvent = null):void
		{			
			var n:int = tagContainer.numChildren - 1;
			var t:Bitmap;
			var delay:Number = 0;
			for (var i:int = n; i >= 1; i--) {
				t = Bitmap(tagContainer.getChildAt(i));
				TweenMax.to(t, .75, { z: -500, y:"-25", alpha:0, delay:delay } );
				delay += .015;
			}
			t = Bitmap(tagContainer.getChildAt(0));
			TweenMax.to(t, .75, { z: -500, y:"-25", alpha:0, delay:delay, onComplete:clearLevel } );
		}
		
		
		private function clearLevel():void
		{
			while (tagContainer.numChildren) {
				tagContainer.removeChildAt(0);
			}			
		}		
		
		
		public function cleanup():void
		{	
			clearLevel();
			dict.refreshTags(myColors, myDate);//calls tagsLoaded when ready
		}		
		
	}
	
}