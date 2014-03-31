package com.gmrmarketing.bcbs.findyourbalance
{
	import flash.display.*;
	import flash.events.*;
	import com.greensock.TweenMax;
	
	public class ControllerSweeps extends EventDispatcher
	{
		public static const DONE:String = "sweepsComplete";
		
		private var clip:MovieClip;
		private var clip2:MovieClip;
		private var container:DisplayObjectContainer;
		
		
		public function ControllerSweeps()
		{
			clip = new mcSweeps();//lib clips
			clip2 = new mcThanks();//fades in at end
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
			
			clip.alpha = 0;
			clip.btnSweeps.addEventListener(MouseEvent.MOUSE_DOWN, sweepsClicked, false, 0, true);
			clip.btnOptin.addEventListener(MouseEvent.MOUSE_DOWN, optInClicked, false, 0, true);
			clip.btnSubmit.addEventListener(MouseEvent.MOUSE_DOWN, submitClicked, false, 0, true);
			
			clip.checkSweeps.gotoAndStop(1);
			clip.checkOptin.gotoAndStop(1);
			
			TweenMax.to(clip, 1, { alpha:1 } );
		}
		
		
		public function hide():void
		{
			clip.btnSweeps.removeEventListener(MouseEvent.MOUSE_DOWN, sweepsClicked);
			clip.btnOptin.removeEventListener(MouseEvent.MOUSE_DOWN, optInClicked);
			clip.btnSubmit.removeEventListener(MouseEvent.MOUSE_DOWN, submitClicked);
			
			//sweeps
			if (container.contains(clip)) {
				container.removeChild(clip);
			}
			//thanks
			if (container.contains(clip2)) {
				container.removeChild(clip2);
			}
		}
		
		
		private function sweepsClicked(e:MouseEvent):void
		{			
			if (clip.checkSweeps.currentFrame == 1) {
				clip.checkSweeps.gotoAndStop(2);
			}else {
				clip.checkSweeps.gotoAndStop(1);
			}		
		}
		
		
		private function optInClicked(e:MouseEvent):void
		{			
			if (clip.checkOptin.currentFrame == 1) {
				clip.checkOptin.gotoAndStop(2);
			}else {
				clip.checkOptin.gotoAndStop(1);
			}		
		}
		
		
		private function submitClicked(e:MouseEvent):void
		{
			container.addChild(clip2);
			clip2.alpha = 0;
			TweenMax.to(clip2, 1, { alpha:1, onComplete:done } );
		}
		
		
		/**
		 * called from ControllerMain.sweepsDone()
		 * @return
		 */
		public function getData():Array
		{
			var r:Array = new Array();
			
			if (clip.checkSweeps.currentFrame == 1) {
				r.push("false");
			}else {
				r.push("true");
			}
			if (clip.checkOptin.currentFrame == 1) {
				r.push("false");
			}else {
				r.push("true");
			}
			return r;
		}
		
		
		private function done():void
		{
			dispatchEvent(new Event(DONE));
		}
		
	}
	
}