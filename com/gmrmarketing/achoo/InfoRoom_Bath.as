﻿/**
 * InfoRoom
 * Bathroom 
 *  
 * Kleenex Achoo Game
 */

package com.gmrmarketing.achoo
{ 
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import com.greensock.TweenLite;
	import com.greensock.easing.*	
		
	
	public class InfoRoom_Bath extends MovieClip
	{		
		private var hilites:Array;		
		private var myContainer:DisplayObjectContainer;
		private var dialog:MovieClip;
		private var channel:SoundChannel;
		
		
		/**
		 * CONSTRUCTOR
		 */
		public function InfoRoom_Bath(container:DisplayObjectContainer):void
		{			
			myContainer = container;
			
			hilites = new Array(0, 0, 0); //0 for each hilite in the room - three in this room
			//hilites use naming convention o1 - o3 in this room
			
			o1.addEventListener(MouseEvent.CLICK, o1Click);
			o2.addEventListener(MouseEvent.CLICK, o2Click);
			o3.addEventListener(MouseEvent.CLICK, o3Click);
			
			o1.alpha = 0;
			o2.alpha = 0;
			o3.alpha = 0;
			
			channel = new SoundChannel();
			
			addEventListener(Event.ADDED_TO_STAGE, test);
		}
		
		
		/**
		 * Called from Intro.removeInfo
		 */
		public function killDialog():void
		{
			if(dialog){
				if (myContainer.contains(dialog)) {
					dialog.removeEventListener(MouseEvent.CLICK, dialogClose);
					myContainer.removeChild(dialog);
					channel.removeEventListener(Event.SOUND_COMPLETE, checkHilites);
				}
			}
		}
		
		
		private function test(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, test);
			showDialog(11);
			if(Engine.USE_VOICE){
				channel.stop();
				var s:DYK_Begin = new DYK_Begin();			
				channel = s.play();
			}
			//bring in the highlights
			TweenLite.to(o1, 1, { alpha:1 } );
			TweenLite.to(o2, 1, { alpha:1, delay:.5} );
			TweenLite.to(o3, 1, { alpha:1, delay:1 } );
		}
		
		
		/**
		 * Sends the dialog to the given frame
		 * @param	f unit Frame number 
		 */
		private function showDialog(f:uint)
		{
			/*
			if(dialog){
				if (myContainer.contains(dialog)) {
					dialogClose(new MouseEvent(MouseEvent.CLICK));
				}
			}*/
			if (!dialog) {
				dialog = new DidYouKnow();
			}
			if (!myContainer.contains(dialog)) {
				myContainer.addChild(dialog);
			}
			dialog.x = Engine.GAME_WIDTH / 2 - (dialog.width / 2);
			dialog.y = Engine.GAME_HEIGHT / 2 - (Engine.DYK_HEIGHTS[f] / 2) - 80;
			
			dialog.scaleX = .4;
			dialog.scaleY = .4;
			TweenLite.to(dialog, 1.5, { scaleX:1, scaleY:1, ease:Elastic.easeOut } );
			
			//frame 10 is the 'ready - click to begin' frame
			if(f != 10){
				dialog.addEventListener(MouseEvent.CLICK, dialogClose);
			}else {
				if(Engine.USE_VOICE){
					channel.stop();
					var s:DYK_Ready = new DYK_Ready();			
					channel = s.play();
				}
				dialog.removeEventListener(MouseEvent.CLICK, dialogClose);
				dialog.addEventListener(MouseEvent.CLICK, gameBegin);
			}
			dialog.gotoAndStop(f);
		}
		
		private function dialogClose(e:MouseEvent)
		{
			dialog.removeEventListener(MouseEvent.CLICK, dialogClose);
			myContainer.removeChild(dialog);
			channel.stop();
			checkHilites(1);
		}
		
		private function gameBegin(e:MouseEvent)
		{
			channel.stop();
			dialog.removeEventListener(MouseEvent.CLICK, dialogClose);
			myContainer.removeChild(dialog);
			dispatchEvent(new Event("roomComplete"));
		}
		
		private function o1Click(e:MouseEvent)
		{	
			if(Engine.USE_VOICE){
				channel.stop();
				var s:Maria_DYK_Bath1 = new Maria_DYK_Bath1();			
				channel = s.play();
				channel.addEventListener(Event.SOUND_COMPLETE, checkHilites);
			}
							
			showDialog(1);			
			o1.visible = false;
			hilites[0] = 1;			
		}
		
		private function o2Click(e:MouseEvent)
		{
			if(Engine.USE_VOICE){
				channel.stop();
				var s2:Maria_DYK_Bath2 = new Maria_DYK_Bath2();			
				channel = s2.play();
				channel.addEventListener(Event.SOUND_COMPLETE, checkHilites);
			}
			showDialog(2);		
			o2.visible = false;
			hilites[1] = 1;			
		}
		
		private function o3Click(e:MouseEvent)
		{
			if(Engine.USE_VOICE){
				channel.stop();
				var s3:Maria_DYK_Bath3 = new Maria_DYK_Bath3();			
				channel = s3.play();
				channel.addEventListener(Event.SOUND_COMPLETE, checkHilites);
			}
			showDialog(3);			
			o3.visible = false;
			hilites[2] = 1;			
		}		
		
		/**
		* Checks to see if any 0's are left in the hilite array
		*/
		private function checkHilites(e:*):void
		{
			channel.removeEventListener(Event.SOUND_COMPLETE, checkHilites);
			if (hilites.indexOf(0) == -1) {
				//all hilites clicked
				o1.removeEventListener(MouseEvent.CLICK, o1Click);
				o2.removeEventListener(MouseEvent.CLICK, o2Click);
				o3.removeEventListener(MouseEvent.CLICK, o3Click);
				channel.stop();
				showDialog(10);
			}
		}	
	} 
}