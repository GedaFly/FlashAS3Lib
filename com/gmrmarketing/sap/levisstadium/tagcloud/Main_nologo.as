/**
 * This version comments out the switch in init() that sets the bottomBar text title
 */

package com.gmrmarketing.sap.levisstadium.tagcloud
{
	import com.gmrmarketing.sap.levisstadium.ISchedulerMethods;
	import flash.display.*;
	import com.gmrmarketing.sap.levisstadium.tagcloud.RectFinder;	
	import flash.events.*;
	
	public class Main_nologo extends MovieClip implements ISchedulerMethods
	{
		public static const READY:String = "ready"; //scheduler requires the READY event to be the string "ready"
		private var dict:TagCloud;//tags from the service
		private var ra:RectFinder;
		private var bmp:Bitmap;
		private var tagName:String; //set in setConfig, one of: levis,offense,defense	
		
		public function Main_nologo()
		{		
			//TESTING
			//init("levis,0xFFFFFF,0xCCCCCC,0xEEB500");
			
			dict = new TagCloud(2, 28, 4);
			dict.addEventListener(TagCloud.TAGS_READY, tagsLoaded, false, 0, true);
			
		}
		
		
		/**
		 * ISChedulerMethods
		 * initValue is tagName, array of colors: levis,0xffffff,0xcccccc,0x678900,etc
		 */
		public function init(initValue:String = ""):void
		{
			var i:int = initValue.indexOf(",");
			tagName = initValue.substring(0, i);
			var cols:String = initValue.substr(i + 1);
			var colors:Array = cols.split(",");
			
			ra = new RectFinder(2);
			/*
			switch(tagName) {
				case "levis":
					bottomBar.theText.text = "#LevisStadium";					
					break;
				case "offense":
					bottomBar.theText.text = "#Offense";
					break;
				case "defense":
					bottomBar.theText.text = "#Defense";
					break;
				case "49ers":
					bottomBar.theText.text = "#49ers";
					break;
			}
				*/		
			dict.refreshTags(tagName, colors);//calls tagsLoaded when ready
		}
		
		
		/**
		 * ISChedulerMethods
		 * show will be called once ready event is received
		 */
		public function show():void
		{		
			
			var bmd:BitmapData = new BitmapData(768, 512, true, 0x00000000);
			bmp = new Bitmap(bmd);
			addChildAt(bmp, 0);	
			
			var tagImage:BitmapData;
			switch(tagName) {
				case "levis":
					tagImage = new sap();
					break;
				case "offense":
					tagImage = new helmet();
					break;
				case "defense":
					tagImage = new helmet_flip();
					break;
				case "49ers":
					tagImage = new helmet();
					break;
			}
			
			ra.create(bmd, tagImage, dict.getTags(), this.stage);
		}
		
		/**
		 * ISChedulerMethods
		 */
		public function hide():void
		{
			if (contains(bmp)) {
				removeChild(bmp);
			}
		}
		
		/**
		 * ISChedulerMethods
		 */
		public function doStop():void
		{
			ra.stop();
		}
		
		
		/**
		 * ISChedulerMethods
		 */
		public function kill():void
		{
			dict.kill();
			ra.kill();
			//dict = null;
			ra = null;
		}
		
		/**
		 * callback from setConfig()
		 * @param	e
		 */
		private function tagsLoaded(e:Event):void
		{
			//show();//TESTING
			dispatchEvent(new Event(READY));
		}
	}
	
}