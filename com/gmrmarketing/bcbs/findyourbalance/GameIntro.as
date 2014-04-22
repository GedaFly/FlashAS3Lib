/**
 * Intro screen and leaderboard
 * 
 */
package com.gmrmarketing.bcbs.findyourbalance
{	
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.greensock.TweenMax;
	
	
	public class GameIntro
	{
		private var clip:MovieClip;
		private var clip2:MovieClip;
		private var container:DisplayObjectContainer;
		private var leaders:Array;
		private var switchTimer:Timer;
		
		
		public function GameIntro()
		{
			clip = new mcIntro();
			clip2 = new mcLeaderboard();
			
			switchTimer = new Timer(10000, 1);			
		}
		
		
		public function setContainer($container:DisplayObjectContainer):void
		{
			container = $container;
		}
		
		
		/**
		 * leaders will contain 0 to 10 leaderboard entries
		 * from WebService.getLeaderboard()
		 * each entry is an array containing
		 * fname,lname,email,phone,state,entry,optin,moreInfo,q1a,q2a,event,score
		 * @param	$leaders Array with at max 10 entries
		 */
		public function show(leaders:Array):void
		{
			//populate leaderboard with names/scores
			for (var i:int = 0; i < leaders.length; i++) {
				clip2["n" + i].text = leaders[i][0] + " " + String(leaders[i][1]).substr(0, 1) + ".";
				clip2["s" + i].text = String(leaders[i][11]);				
			}
			showLeaderboard();
		}
		
		
		private function showLeaderboard(e:TimerEvent = null):void
		{
			switchTimer.removeEventListener(TimerEvent.TIMER, showLeaderboard);
			
			if (container.contains(clip2)) {
				container.removeChild(clip2);
			}
			
			TweenMax.killTweensOf(clip.balance);
			
			container.addChild(clip2);
			clip2.alpha = 0;
			TweenMax.to(clip2, 1, { alpha:1 } );			
			
			switchTimer.reset();
			switchTimer.addEventListener(TimerEvent.TIMER, showIntro, false, 0, true);
			switchTimer.start();
		}
		
		
		private function showIntro(e:TimerEvent = null):void
		{
			switchTimer.removeEventListener(TimerEvent.TIMER, showIntro);
			
			if (container.contains(clip)) {
				container.removeChild(clip);
			}
			container.addChild(clip);
			clip.alpha = 0;
			
			TweenMax.to(clip, 1, { alpha:1 } );
			animRight();
			
			switchTimer.reset();
			switchTimer.addEventListener(TimerEvent.TIMER, showLeaderboard, false, 0, true);
			switchTimer.start();
		}
		
		
		private function animRight():void
		{
			TweenMax.to(clip.balance, 1, { rotation:Math.random() * 8, onComplete:animLeft } );
		}
		
		
		private function animLeft():void
		{
			TweenMax.to(clip.balance, 1, { rotation:-(Math.random() * 8), onComplete:animRight } );
		}
		
		
		public function hide():void
		{
			switchTimer.reset();
			
			if (container.contains(clip)) {
				container.removeChild(clip);
			}
			if (container.contains(clip2)) {
				container.removeChild(clip2);
			}
		}
		
	}
	
}