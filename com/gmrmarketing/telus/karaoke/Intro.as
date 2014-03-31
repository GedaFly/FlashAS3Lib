package com.gmrmarketing.telus.karaoke
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	
	
	public class Intro extends EventDispatcher
	{
		public static const GET_STARTED:String = "getStarted";
		
		private var clip:MovieClip;
		private var container:DisplayObjectContainer;
		
		public function Intro()
		{
			clip = new mcIntro();
		}		
		
		public function setContainer($container:DisplayObjectContainer):void
		{
			container = $container;
		}		
		
		public function show():void
		{
			if (!container.contains(clip)) {
				container.addChild(clip);
			}			
			clip.btn.addEventListener(MouseEvent.MOUSE_DOWN, doStart, false, 0, true);	
			clip.alpha = 0;
			TweenMax.to(clip, 1, { alpha:1 } );
		}
		
		
		public function hide():void
		{
			clip.btn.removeEventListener(MouseEvent.MOUSE_DOWN, doStart);
			if (container.contains(clip)) {
				container.removeChild(clip);
			}
		}
		
		private function doStart(e:MouseEvent):void
		{
			clip.btn.removeEventListener(MouseEvent.MOUSE_DOWN, doStart);
			dispatchEvent(new Event(GET_STARTED));
		}
		
	}
	
}